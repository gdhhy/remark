--从源表拷贝索引到目标表
    alter procedure sp_copy_index @srcTableName varchar(200), @dstTable varchar(220)
    as
    declare
        @ixName varchar(100), @ddlSql varchar(1000)
    --set @tabname = 'AdviceItem_2020' --表名

    begin
        if (object_id('tempdb.dbo.#IDX') is not null)
            begin
                DROP TABLE #IDX;
                DROP TABLE #IDX2;
                DROP TABLE #IDX3;
                DROP TABLE #IDX4;
            end

        SELECT a.name IndexName,
               c.name TableName,
               d.name IndexColumn,
               i.is_primary_key,--为主键=1，其他为0
               i.is_unique_constraint, --唯一约束=1，其他为0
               b.keyno --列的次序,0为include的列
        into #IDX
        FROM sysindexes a
                 JOIN sysindexkeys b ON a.id = b.id AND a.indid = b.indid
                 JOIN sysobjects c ON b.id = c.id
                 JOIN syscolumns d ON b.id = d.id AND b.colid = d.colid
                 join sys.indexes i on i.index_id = a.indid and c.id = i.object_id
        WHERE a.indid NOT IN (0, 255) --indid = 0 或 255则为表，其他为索引。
          -- and   c.xtype='U'  /*U = 用户表*/ and   c.status>0 --查所有用户表
          AND c.name = @srcTableName  --查指定表
          and c.type <> 's'           --S = 系统表
        ORDER BY c.name, a.name, b.keyno;

        SELECT IndexName,
               TableName,
               is_primary_key,       --为主键=1，其他为0
               is_unique_constraint, --唯一约束=1，其他为0
               [IndexColumn] =
                   stuff((SELECT ',' + [IndexColumn]
                          FROM (select * from #IDX where keyno <> 0) n
                          WHERE t.IndexName = n.IndexName
                            AND t.TableName = n.TableName
                            AND t.is_primary_key = n.is_primary_key
                            AND t.is_unique_constraint = n.is_unique_constraint
                          FOR XML PATH ( '' )),
                         1, 1, '')
        into #IDX2
        FROM (select * from #IDX where keyno <> 0) t
        GROUP BY IndexName, TableName, is_primary_key, is_unique_constraint;

        SELECT IndexName,
               TableName,
               is_primary_key,       --为主键=1，其他为0
               is_unique_constraint, --唯一约束=1，其他为0
               [IndexColumn] =
                   stuff((SELECT ',' + [IndexColumn]
                          FROM (select * from #IDX where keyno = 0) n
                          WHERE t.IndexName = n.IndexName
                            AND t.TableName = n.TableName
                            AND t.is_primary_key = n.is_primary_key
                            AND t.is_unique_constraint = n.is_unique_constraint
                          FOR XML PATH ( '' )),
                         1, 1, '')
        into #IDX3
        FROM (select * from #IDX where keyno = 0) t
        GROUP BY IndexName, TableName, is_primary_key, is_unique_constraint;

--FillFactor值为  100   时表示页将填满，所留出的存储空间量最小。只有当不会对数据进行更改时（例如，在只读表中）才会使用此设置
        select @ixName = 'IX_' + @dstTable + '_';
        select case
                   when a.is_primary_key = 1
                       then 'ALTER TABLE ' + @dstTable + ' ADD CONSTRAINT ' + @ixName + SUBSTRING(REPLACE(NEWID(), '-', ''), 1, 10) + ' PRIMARY KEY  (' + a.IndexColumn + ')'
                   when a.is_unique_constraint = 1
                       then 'ALTER TABLE ' + @dstTable + ' ADD CONSTRAINT ' + @ixName + SUBSTRING(REPLACE(NEWID(), '-', ''), 1, 10) + ' UNIQUE NONCLUSTERED(' + a.IndexColumn +
                            ') WITH(FillFactor=80)'
                   else 'create index ' + @ixName + SUBSTRING(REPLACE(NEWID(), '-', ''), 1, 10) + ' on ' + @dstTable + '(' + a.IndexColumn + ') ' +
                        (case when b.IndexColumn is null then '' else 'include(' + b.IndexColumn + ') ' end) + 'WITH(FillFactor=80)' end INDEX_DDL
        into #IDX4
        from #IDX2 a
                 left join #IDX3 b on a.indexname = b.indexname
        where a.is_primary_key = 0;
        --去掉主键

        --开始执行存储在#IDX4的索引DDL
        DECLARE cur CURSOR LOCAL FOR SELECT * FROM #IDX4;
        OPEN cur;
        FETCH NEXT FROM cur INTO @ddlSql;
        WHILE (@@Fetch_Status = 0)
            BEGIN
                exec (@ddlSql);
                FETCH NEXT FROM cur INTO @ddlSql;
            end
        CLOSE cur;
        DEALLOCATE cur;
    end;