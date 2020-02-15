--注意！不能跨年！
  ALTER  PROCEDURE [dbo].[ljDrugRecords](@logID INT, @fromDate VARCHAR(10), @toDate VARCHAR(10))
  AS
  DECLARE
    @lastID INT,
    @dstTableName varchar(220),
    @insertRowCount INT,
    @deleteRowCount INT,
    @startTime DATETIME,
    @nextDate SMALLDATETIME,
    @sqlString varchar(1023),
    @timeSpent INT
  BEGIN
    --BEGIN TRAN --此时 @@TRANCOUNT为 1
    SELECT @startTime = getdate(), @nextDate = dateadd(DAY, datediff(DAY, 0, @toDate), 1),@dstTableName='DrugRecords_'+left(@fromDate,4);

    --门诊发药
    insert into DrugRecords(recordID,drugstore,dispensingDate,patientID,dispensingNo,departID, department,goodsID,unit,quantity,price,doctorID,usage,clinicType)
    select  A.ID,E.name,B.OperTime,B.mzRegID,B.MzRegNo,B.locationID,B.LocationName, A.itemID,D.name,A.Totality,A.price,A.doctorID,C.name,
            case B.LsRepType when 1 then '西药方' when 2 then '草药方' else '' end
    from YBHis.YueBeiHis.dbo.OuRecipeDtl A
           join YBHis.YueBeiHis.dbo.OuRecipeTemp B On A.recipeID=B.recipeID
           left join YBHis.YueBeiHis.dbo.BSUsage  C on A.UsageId=C.ID
           left join YBHis.YueBeiHis.dbo.BSUnit D on A.UnitDiagId=D.ID
           left join YBHis.YueBeiHis.dbo.BsRoom E ON B.RoomId=E.ID
    where A.IsCancel=0  AND B.isIssue=1 and B.isBack=0   and B.OperTime>=@fromDate and B.OperTime<@nextDate;
    select @lastID=SCOPE_IDENTITY ();

    --急诊、普通方、主任医师。。。，门诊病人姓名
    UPDATE A SET A.clinicType= case when A.clinicType='草药方'	then '草药方' else T.regTypeName end,
                 A.patientID=T.ID,A.patientName=T.patientName
    FROM  DrugRecords A
            left   join  (select B.ID,B.mzRegNo,B.name patientName,C.name regTypeName
                          FROM YBHis.YueBeiHis.dbo.OuHosInfo  B left join  YBHis.YueBeiHis.dbo.BsRegType  C on C.ID=B.RegTypeId) T
                         on T.mzRegNo=A.dispensingNo ;
    --todo 挂号儿科，就是儿科方？

    --住院领药
    insert into DrugRecords(recordID,drugstore,dispensingDate,patientID,dispensingNo,departID,goodsID,unit,quantity,price,doctorID,usage,adviceId)
    select   A.ID,C.name,B.ConfirmDate,A.HospId,B.RequestNo,B.LocationId,A.itemID,D.name,A.Totality,A.priceIn,A.DoctorID,A.F3,A.adviceId
    from YBHis.YueBeiHis.dbo.InDrugReqdtl A
           left join YBHis.YueBeiHis.dbo.InDrugReq B ON A.requestID=B.ID
           left join YBHis.YueBeiHis.dbo.BsRoom C ON B.RoomId=C.ID
           left join YBHis.YueBeiHis.dbo.BSUnit D on A.UnitReq=D.ID
    where isIssued=1 and B.ConfirmDate>=@fromDate and B.confirmDate<@nextDate;
    select @lastID=SCOPE_IDENTITY ();

    --医生姓名
    UPDATE A SET  A.doctorName=B.name
    FROM  DrugRecords A , YBHis.YueBeiHis.dbo.BsDoctor  B where A.doctorID=B.ID;
    --科室名
    UPDATE A SET A.department=B.name
    FROM  DrugRecords A , YBHis.YueBeiHis.dbo.BsLocation  B where A.departID=B.ID;
    --住院病人姓名 todo 性别、年龄
    UPDATE A SET A.patientName=B.name
    FROM  DrugRecords A , YBHis.YueBeiHis.dbo.InHosinfo  B where A.patientID=B.ID and A.adviceID>0;
    --长嘱、临嘱、出院带药
    UPDATE A SET A.clinicType= case LsMarkType when 1 then '长嘱' when 2 then '临嘱' when 5 then '出院带药' else '' end
    FROM  DrugRecords A , YBHis.YueBeiHis.dbo.InExecute  B where A.adviceId=B.ID;

    --按年放入表
    if object_id(@dstTableName, N'U') is  null
      begin
        exec sp_copy_table 'DrugRecords',@dstTableName;
        exec sp_copy_index 'DrugRecords',@dstTableName;
      end
    set @sqlString='delete from '+@dstTableName+' where dispensingDate>='''+@fromDate+''' and dispensingDate<'''+convert (varchar(10),@nextDate,120)+''';';
    --select @sqlstring;
    exec (@sqlString);
    SELECT @deleteRowCount = @@rowcount;

    set @sqlString='insert into '+@dstTableName+
                   '(recordID,drugstore,dispensingDate,patientID,patientName,dispensingNo,departID,department,' +
                   'clinicType,goodsID,unit,quantity,price,doctorID,doctorName,usage,adviceId)
                      select recordID,drugstore,dispensingDate,patientID,patientName,dispensingNo,departID,department,' +
                   'clinicType,goodsID,unit,quantity,price,doctorID,doctorName,usage,adviceId from DrugRecords;'
    exec (@sqlString);
    SELECT @insertRowCount = @@rowcount;

    delete from DrugRecords;

    IF (@logID > 0)
      BEGIN
        if(@lastID=0)
          SELECT @lastID = CASE WHEN max(drID) IS NULL THEN 0 ELSE max(drID) END FROM  DrugRecords;
        SELECT @timeSpent = datediff(MS, @startTime, getdate());
        EXEC  monitorUpdateTaskLog2 @logID, 'ljDrugRecords', @dstTableName, @lastID, @deleteRowCount, @insertRowCount, 0, @startTime, @timeSpent;
      END;
  END ;