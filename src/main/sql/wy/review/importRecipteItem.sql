alter PROCEDURE importRecipeItem(@logID INT)
    AS
    DECLARE
        @lastID                   INT,
        @maxLastID                INT,
        @insertRowCount           INT,
        @deleteRecipeItemRowCount INT,
        @RecipeItemTable          VARCHAR(100),
        @sql                      nVARCHAR(1000),
        @startTime                DATETIME
    BEGIN

        --HIS_MZCFMX = > RecipeItem
        SELECT @startTime = getdate(), @deleteRecipeItemRowCount = -1, @insertRowCount = -1;
        --启动事务
        --SET XACT_ABORT ON;
        --BEGIN TRANSACTION;
        SELECT @lastID = 600000;
        SELECT TOP 1 @lastID = lastID FROM MonitorTaskDetail WHERE tableName = 'review..RecipeItemTable' ORDER BY detailID DESC;
        /*--todo insert into MOnitorTaskDetail (tableName,lastID) values('review..RecipeItemTable',0);*/
        SELECT @maxLastID = max(yz_id) FROM review_import.dbo.his_yz_bm;

        select @RecipeItemTable = 'RecipeItem_' + cast(DATEPART(year, max(rq)) as varchar) from review_import.dbo.HIS_MZCFMX;
        if object_id(@RecipeItemTable, N'U') is null
            begin
                exec sp_copy_table 'RecipeItem_2015', @RecipeItemTable;-- todo remove _2015
                exec sp_copy_index 'RecipeItem_2015', @RecipeItemTable;-- todo remove _2015
            end;


        if (@maxLastID > @lastID)
            begin
                select @sql = ' INSERT INTO ' + @RecipeItemTable + ' (recipeItemID, serialNo, longAdvice, recipeDate, advice, groupID, orderID, doctorName, nurseName, endDate, ' +
                              'endDoctorName, endNurseName, quantity, unit, adviceType, medicineNo)
                    SELECT yz_id, zyh, lx, kyzsj, yzxx, yzzh, yzxh, kyzys, gyzhs, tyzsj, tyzys, tyzhs, cast(cast(sl AS FLOAT) AS INT), dw, yfbz, bm
                     FROM review_import.dbo.his_yz_bm WHERE yz_id > ' + cast(@lastID as varchar) + ' AND yz_id <= ' + cast(@maxLastID as varchar) + '';
                exec (@sql);

                SELECT @insertRowCount = @@rowcount;

                IF (@insertRowCount > 0)
                    BEGIN
                        -- DELETE review_import.dbo.his_yz_bm WHERE yz_id > @lastID AND yz_id <= @maxLastID; // 待旧系统停止后，执行这句
                        SELECT @lastID = @maxLastID;
                    END;

                --删除过期医嘱、重复数据
                select @sql = 'DELETE FROM ' + @RecipeItemTable +
                              ' WHERE recipeItemID NOT IN (SELECT max(recipeItemID) FROM ' + @RecipeItemTable +
                              ' GROUP BY serialNo, longAdvice, orderID, groupID)';
                select @sql;
                exec (@sql);
                select @deleteRecipeItemRowCount = @@rowcount;
            END;

        --COMMIT TRANSACTION;

        IF (@logID > 0)
            BEGIN
                select @sql = 'SELECT  @lastID = CASE WHEN max(recipeItemID) IS NULL THEN 0 ELSE max(recipeItemID) END FROM ' + @RecipeItemTable;
                execute sp_executesql @sql, N'@lastID int out', @lastID out
                EXEC monitorUpdateTaskLog @logID, 'importRecipeItem', 'review..RecipeItemTable', @lastID, @deleteRecipeItemRowCount, @insertRowCount, -1, @startTime;
            END;

    END;