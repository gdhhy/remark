ALTER PROCEDURE [dbo].[importDrugRecords](@logID INT)
    AS
    DECLARE
        @lastID           INT,
        @maxLastID        INT,
        @insertRowCount   INT,
        @deleteRowCount   INT,
        @startTime        DATETIME,
        @DrugRecordsTable VARCHAR(100),
        @sql              nVARCHAR(1000)
    BEGIN
        --his_lydmx
        SELECT @startTime = getdate(), @deleteRowCount = -1, @insertRowCount = -1;
        --启动事务
        --SET XACT_ABORT ON;
        --BEGIN TRANSACTION;
        SELECT @lastID = 0;
        SELECT TOP 1 @lastID = lastID FROM MonitorTaskDetail WHERE tableName = 'review..DrugRecordsTable' ORDER BY detailID DESC;
        /*--todo insert into MOnitorTaskDetail (tableName,lastID) values('review..DrugRecordsTable',(select max(drID) from drugreCords_2015));*/
        SELECT @maxLastID = max(lydmx_id) FROM review_import.dbo.his_lydmx;

        select @DrugRecordsTable = 'DrugRecords_' + cast(DATEPART(year, max(fyrq)) as varchar) from review_import.dbo.his_lyd;
        if object_id(@DrugRecordsTable, N'U') is null
            begin
                exec sp_copy_table 'DrugRecords_2015', @DrugRecordsTable;
                exec sp_copy_index 'DrugRecords_2015', @DrugRecordsTable;
            end;

        -- select @lastID,@maxLastID;
        if (@maxLastID > @lastID)
            begin
                --先删除数据
                select @sql = 'DELETE FROM ' + @DrugRecordsTable +
                              ' WHERE convert(VARCHAR(10), dispensingDate, 120) IN (SELECT DISTINCT convert(VARCHAR(10), fyrq, 120) FROM review_import.dbo.his_lyd' +
                              ' WHERE lydno in (select lydno from his_lydmx where lydmx_id>' + cast(@lastID as varchar) + ' and lydmx_id<=' + cast(@maxLastID as varchar) + '))';
                exec (@sql);
                select @deleteRowCount = @@rowcount;


                select @sql = 'INSERT INTO  ' + @DrugRecordsTable + ' (drID,recordID,drugstore,dispensingDate,patientName,dispensingNo,' +
                              'invoiceNo,department,  goodsID,goodsNo,unit,spec,' +
                              'quantity,price,amount,doctorName,adviceType)
                select   A.lydmx_id,A.lydno,B.yf,B.fyrq,B.brxm,B.fyid,' +
                              'B.fph,B.ks,A.fyypid,A.ypbm,A.dw,A.gg,' +
                              'A.fysl,A.ypdj, A.fyje,A.ys,A.yztype
                from review_import.dbo.his_lydmx A join review_import.dbo.his_lyd B on A.lydno=B.lydno ' +
                              'WHERE lydmx_id>' + cast(@lastID as varchar) + ' and lydmx_id<=' + cast(@maxLastID as varchar);
                --B.dAge,B.clinicType
                exec (@sql);
                select @insertRowCount = @@rowcount;

                IF (@insertRowCount > 0)
                    BEGIN
                        DELETE review_import.dbo.his_lyd WHERE lydno in (select lydno from review_import.dbo.his_lydmx WHERE lydmx_id > @lastID AND lydmx_id <= @maxLastID);
                        DELETE review_import.dbo.his_lydmx WHERE lydmx_id > @lastID AND lydmx_id <= @maxLastID;
                        SELECT @lastID = @maxLastID;
                    END;
            end;


        IF (@logID > 0)
            BEGIN
                select @sql = 'SELECT @lastID = CASE WHEN max(drID) IS NULL THEN 0 ELSE max(drID) END  FROM ' + @DrugRecordsTable;
                execute sp_executesql @sql, N'@lastID int out', @lastID out
                EXEC monitorUpdateTaskLog @logID, 'importDrugRecords', 'review..DrugRecordsTable', @lastID, @deleteRowCount, @insertRowCount, -1, @startTime;
            END;
    END;