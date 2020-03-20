alter PROCEDURE importRxDetail(@logID INT)
    AS
    DECLARE
        @lastID                 INT,
        @maxLastID              INT,
        @insertRowCount         INT,
        @deleteRxDetailRowCount INT,
        @RxDetailTable          VARCHAR(100),
        @sql                    nVARCHAR(1000),
        @startTime              DATETIME
    BEGIN

        --HIS_MZCFMX = > RxDetail
        SELECT @startTime = getdate(), @deleteRxDetailRowCount = -1, @insertRowCount = -1;
        --启动事务
        --SET XACT_ABORT ON;
        --BEGIN TRANSACTION;
        SELECT @lastID = 600000;
        SELECT TOP 1 @lastID = lastID FROM MonitorTaskDetail WHERE tableName = 'review..RxDetailTable' ORDER BY detailID DESC;
        /*--todo insert into MOnitorTaskDetail (tableName,lastID) values('review..RxDetailTable',0);*/
        SELECT @maxLastID = max(mzcfmx_id) FROM review_import.dbo.HIS_MZCFMX;

        select @RxDetailTable = 'RxDetail_' + cast(DATEPART(year, max(rq)) as varchar) from review_import.dbo.HIS_MZCFMX;
        if object_id(@RxDetailTable, N'U') is null
            begin
                exec sp_copy_table 'RxDetail_2015', @RxDetailTable;-- todo remove _2015
                exec sp_copy_index 'RxDetail_2015', @RxDetailTable;-- todo remove _2015
            end;


        if (@maxLastID > @lastID)
            begin
                --先删除数据
                select @sql = 'DELETE FROM ' + @RxDetailTable +
                              ' WHERE convert(VARCHAR(10), prescribeDate, 120) IN (SELECT DISTINCT convert(VARCHAR(10), rq, 120) FROM review_import.dbo.HIS_MZCFMX WHERE mzcfmx_id>' +
                              cast(@lastID as varchar) + ' AND mzcfmx_id <= ' + cast(@maxLastID as varchar) + ')';
                exec (@sql);
                select @deleteRxDetailRowCount = @@rowcount;

                select @sql =
                       ' INSERT INTO ' + @RxDetailTable + ' (rxDetailID, hospID, rxNo, prescribeDate, orderID, medicineNo, quantity, price, money, frequency, eachQuantity,' +
                       ' num, dayNum, unit, adviceType, minOfpack, spec, groupID, dosage)
             SELECT mzcfmx_id, JZID, CFJID, RQ, XH, YPID, SL, DJ, JE, YF, MCL, CS, TS, DW, CLZT, ZH, GG, cfzh, cfxx
             FROM review_import.dbo.HIS_MZCFMX WHERE mzcfmx_id IN (
             SELECT max(mzcfmx_id) FROM review_import.dbo.HIS_MZCFMX WHERE mzcfmx_id > ' + cast(@lastID as varchar) + ' AND mzcfmx_id <= ' + cast(@maxLastID as varchar) + '
                    GROUP BY jzid, cfjid, ypid, rq, xh, cfzh)';
                exec (@sql);

                SELECT @insertRowCount = @@rowcount;

                IF (@insertRowCount > 0)
                    BEGIN
                        -- DELETE review_import.dbo.HIS_MZCFMX WHERE mzcfmx_id > @lastID AND mzcfmx_id <= @maxLastID; // 待旧系统停止后，执行这句
                        SELECT @lastID = @maxLastID;
                    END;
            END;

        --COMMIT TRANSACTION;

        IF (@logID > 0)
            BEGIN
                select @sql = 'SELECT  @lastID = CASE WHEN max(rxDetailID) IS NULL THEN 0 ELSE max(rxDetailID) END FROM ' + @RxDetailTable;
                execute sp_executesql @sql, N'@lastID int out', @lastID out
                EXEC monitorUpdateTaskLog @logID, 'importRxDetail', 'review..RxDetailTable', @lastID, @deleteRxDetailRowCount, @insertRowCount, -1, @startTime;
            END;

    END;