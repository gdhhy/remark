/************************************************************
 * 表结构复制（含约束）存储过程
 * Time: 2017/7/23 19:54:38
 ************************************************************/
if object_id(N'sp_copy_table', N'P') is not null
    drop procedure sp_copy_table;
go

create procedure sp_copy_table @srcTableName varchar(200), @dstTableName varchar(220)
as
    set nocount on

begin try
    -- 如果源表不存在，则抛出异常
    declare @tabID varchar(30) = object_id(@srcTableName, N'U');
    if @tabID is null
        raiserror ('src table not exists' ,16 ,1);

    -- 如果目标表已经存在，则抛出异常
    if object_id(@dstTableName, N'U') is not null
        raiserror ('destination table already exists' ,16 ,1);

    -- 创建表（不复制数据）
    declare @createSql varchar(max) = '';
    set @createSql = 'SELECT * INTO ' + @dstTableName + ' FROM ' + @srcTableName + ' WHERE 1 > 1';
    exec (@createSql);

    -- ============== 添加约束 ================
    --
    -- ============= 1. unique constraint / primary constraint =============
    declare @tb1 table
                 (
                     IdxName  varchar(255),
                     colName  varchar(255),
                     consType tinyint
                 )

    declare @tb2 table
                 (
                     IdxName  varchar(255),
                     colName  varchar(255),
                     consType tinyint
                 )

    -- 查询原表的主键约束、唯一约束(统一约束可能作用与多列上，结果集中作为多列)
    insert into @tb1
    select idx.name as      idxName,
           col.name as      colName,
           (case
                when idx.is_primary_key = 1 then 1
                when idx.is_unique_constraint = 1 then 2
                else 0 end) consType
    from sys.indexes idx
             join sys.index_columns idxCol
                  on (
                          idx.object_id = idxCol.object_id
                          and idx.index_id = idxCol.index_id
                          and (idx.is_unique_constraint = 1 or idx.is_primary_key = 1)
                      )
             join sys.columns col
                  on (idx.object_id = col.object_id and idxCol.column_id = col.column_id)
    where idx.[object_id] = @tabID;

    -- 按照约束名，将同一约束的多行结果集合并为一行，写入临时表
    insert into @tb2
    select idxName,
           stuff((select ',' + colName from @tb1 where IdxName = a.idxName and consType = a.consType for xml path ('')), 1, 1, ''),
           a.consType
    from @tb1 a;

    -- @tb1 临时表数据已经没用，删除
    delete from @tb1;

    -- 循环遍历约束，写入目标表
    declare @checkName varchar(255),@colName varchar(255),@consType varchar(255),@tmp varchar(max);

    while exists(select 1 from @tb2)
        begin
            select @checkName = IdxName, @colName = colName, @consType = consType from @tb2;

            -- 主键约束
            if @consType = 1
                begin
                    set @tmp = 'ALTER TABLE ' + @dstTableName + ' ADD CONSTRAINT ' +
                               'PK_' + @dstTableName + '_' + SUBSTRING(REPLACE(NEWID(), '-', ''), 1, 10) +
                               ' PRIMARY KEY (' + @colName + ')';
                    exec (@tmp);
                end-- 	唯一约束
            else
                if @consType = 2
                    begin
                        set @tmp = 'ALTER TABLE ' + @dstTableName + ' ADD CONSTRAINT ' +
                                   'UNQ_' + @dstTableName + '_' + SUBSTRING(REPLACE(NEWID(), '-', ''), 1, 10) +
                                   ' UNIQUE (' + @colName + ')';
                        exec (@tmp);
                    end

            -- 使用完后，删除
            delete from @tb2 where IdxName = @checkName and colName = @colName;
        end

    -- ================= 2. 外键约束 ===================
    declare @tb3 table
                 (
                     fkName       varchar(255),
                     colName      varchar(255),
                     referTabName varchar(255),
                     referColName varchar(255)
                 )

    -- 查询源表外键约束，写入临时表
    insert into @tb3
    select fk.name      as fkName
         , SubCol.name  as colName
         , oMain.name   as referTabName
         , MainCol.name as referColName
    from sys.foreign_keys fk
             join sys.all_objects oSub
                  on (fk.parent_object_id = oSub.object_id)
             join sys.all_objects oMain
                  on (fk.referenced_object_id = oMain.object_id)
             join sys.foreign_key_columns fkCols
                  on (fk.object_id = fkCols.constraint_object_id)
             join sys.columns SubCol
                  on (oSub.object_id = SubCol.object_id and fkCols.parent_column_id = SubCol.column_id)
             join sys.columns MainCol
                  on (oMain.object_id = MainCol.object_id
                      and fkCols.referenced_column_id = MainCol.column_id)
    where oSub.[object_id] = @tabID;

    -- 遍历每一个外键约束，写入目标表
    declare @referTabName varchar(255),@referColName varchar(255);
    while exists(select 1 from @tb3)
        begin
            select @checkName = fkName, @colName = colName, @referTabName = referTabName, @referColName = referColName from @tb3;

            set @tmp = 'ALTER TABLE ' + @dstTableName + ' ADD CONSTRAINT ' +
                       'FK_' + @dstTableName + '_' + SUBSTRING(REPLACE(NEWID(), '-', ''), 1, 10) +
                       ' FOREIGN KEY (' + @colName + ') REFERENCES ' +
                       @referTabName + '(' + @referColName + ')';
            exec (@tmp);

            delete from @tb3 where fkName = @checkName;
        end

    -- =============== 3.CHECK约束 ===================
    declare @tb4 table
                 (
                     checkName  varchar(255),
                     colName    varchar(255),
                     definition varchar(max)
                 );

    insert into @tb4
    select chk.name as checkName, col.name as colName, chk.definition
    from sys.check_constraints chk
             join sys.columns col
                  on (chk.parent_object_id = col.object_id and chk.parent_column_id = col.column_id)
    where chk.parent_object_id = @tabID

    -- 遍历每一个CHECK约束，为目标表添加约束
    declare @definition varchar(max);
    while exists(select 1 from @tb4)
        begin
            select @checkName = checkName, @colName = colName, @definition = [definition] from @tb4;

            set @tmp = 'ALTER TABLE ' + @dstTableName + ' ADD CONSTRAINT ' +
                       'CH_' + @dstTableName + '_' + SUBSTRING(REPLACE(NEWID(), '-', ''), 1, 10) +
                       ' CHECK ' + @definition;
            exec (@tmp);

            delete from @tb4 where checkName = @checkName;
        end

    --  ================ 4. default约束 =====================
    insert into @tb4
    select df.name as checkName, c.name as colName, df.definition
    from sys.default_constraints df
             join sys.[columns] as c
                  on df.parent_column_id = c.column_id
                      and df.parent_object_id = c.[object_id]
    where df.parent_object_id = @tabID;

    -- 遍历每一个default 约束
    while exists(select 1 from @tb4)
        begin
            select @checkName = checkName, @colName = colName, @definition = [definition] from @tb4;

            set @tmp = 'ALTER TABLE ' + @dstTableName + ' ADD CONSTRAINT ' +
                       'DF_' + @dstTableName + '_' + SUBSTRING(REPLACE(NEWID(), '-', ''), 1, 10) +
                       ' DEFAULT ' + @definition + ' FOR ' + @colName;
            --print 'default: ' + @tmp;
            exec (@tmp);

            delete from @tb4 where checkName = @checkName;
        end
end try
begin catch
    -- 输出错误信息
    select error_number()    as ErrorNumber
         , error_severity()  as ErrorSeverity
         , error_state()     as ErrorState
         , error_procedure() as ErrorProcedure
         , error_line()      as ErrorLine
         , error_message()   as ErrorMessage
end catch