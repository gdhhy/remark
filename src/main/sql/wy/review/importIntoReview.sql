--@fromDate 日期格式：yyyy-MM-dd
--@toDate 日期格式：yyyy-MM-dd
ALTER PROCEDURE importIntoReview (@fromDate VARCHAR(10), @toDate VARCHAR(10), @logID INT OUTPUT) AS
DECLARE
@startTime DATETIME,
@timeSpent INT,
@errMsg VARCHAR(1023)
BEGIN
  EXEC monitorWriteTaskLog '从Import导入HIS数据', @fromDate, @toDate, @logID OUTPUT;

  SELECT @startTime = getDate(), @errMsg = '';

--PRINT '@logID=' + cast(@logID AS VARCHAR);
--具体任务
  BEGIN TRY
--BEGIN TRANSACTION

  EXEC importDrugRecords @logID;
  EXEC importRxDetail @logID;
  EXEC importRecipeItem @logID;

  EXEC importLYD @logID;
  EXEC importClinic @logID;
  EXEC importHospital @logID;

--todo 写日志
  EXEC updateClinicPatientNAge;

  EXEC buildClinicStat @fromDate, @toDate, @logID;
  EXEC calcConcurAntiNum @fromDate, @toDate, @logID;
  EXEC searchIncompatibilityRx @fromDate, @toDate, @logID;
  EXEC analyseClinic @fromDate, @toDate, @logID;
  EXEC analyseRecipe @fromDate, @toDate, @logID;

--commit transaction
  END TRY
  BEGIN CATCH
    SELECT @errMsg = '消息 ' + cast(ERROR_NUMBER() AS VARCHAR(10)) + '，级别 ' + cast(ERROR_SEVERITY() AS VARCHAR(10)) + '，状态 ' + cast(ERROR_STATE() AS VARCHAR(10)) +
                     '，过程 ' + CASE WHEN ERROR_PROCEDURE() IS NULL THEN '' ELSE '，过程 ' + ERROR_PROCEDURE() END +
                     '，第 ' + cast(ERROR_LINE() AS VARCHAR(10)) + ' 行 <br />' + CHAR(10) + ERROR_MESSAGE();
    IF (XACT_STATE() = -1)
      ROLLBACK TRANSACTION;
  END CATCH

--写日志
  SELECT @timeSpent = DATEDIFF(MS, @startTime, getdate());
  UPDATE A SET timeSpent = @timeSpent, errMsg = @errMsg, deleteCount = B.deleteCount, insertCount = B.insertCount, updateCount = B.updateCount
  FROM monitorTaskLog A, (SELECT logID, sum(CASE WHEN deleteCount > 0 THEN deleteCount ELSE 0 END) deleteCount,
                                        sum(CASE WHEN insertCount > 0 THEN insertCount ELSE 0 END) insertCount,
                                        sum(CASE WHEN updateCount > 0 THEN updateCount ELSE 0 END) updateCount FROM monitorTaskDetail
                          GROUP BY logID) B
  WHERE A.logID = B.logID AND A.logID = @logID;

END;