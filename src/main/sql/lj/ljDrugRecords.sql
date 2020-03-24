CREATE PROCEDURE [dbo].[ljDrugRecords](@logID INT, @fromDate VARCHAR(10), @toDate VARCHAR(10))
AS
DECLARE
  @lastID         INT,
  @dstTableName   varchar(220),
  @insertRowCount INT,
  @startTime      DATETIME,
  @nextDate       SMALLDATETIME,
  @sqlString      nvarchar(1023),
  @timeSpent      INT
BEGIN
  --hospID=对于门诊：OuHosInfo.ID
  --hospID=对于住院：InHosinfo.Id
  SELECT @startTime = getdate(), @nextDate = dateadd(DAY, datediff(DAY, 0, @toDate), 1), @dstTableName = 'DrugRecords_' + left(@fromDate, 4);

  --门诊发药
  insert into DrugRecords(recordID, drugstore, dispensingDate, hospID, dispensingNo, departID, department, goodsID, unit, quantity, price, amount,
                          doctorID, usage, clinicType)
  select A.ID, E.name, A.RecipeTime, B.mzRegID, B.MzRegNo, B.locationID, B.LocationName, A.itemID, D.name, A.Totality, A.price, A.Totality * A.price,
         A.doctorID, C.name, case B.LsRepType when 1 then '西药方' when 2 then '草药方' else '' end
  from YBHis.LJHis.dbo.OuRecipeDtl A
         join (select distinct recipeID, mzRegID, MzRegNo, locationID, LocationName, roomID, LsRepType
               from YBHis.LJHis.dbo.OuRecipeTemp
               where isIssue = 1 and isBack = 0) B On A.recipeID = B.recipeID
         left join YBHis.LJHis.dbo.BSUsage C on A.UsageId = C.ID
         left join YBHis.LJHis.dbo.BSUnit D on A.UnitDiagId = D.ID
         left join YBHis.LJHis.dbo.BsRoom E ON B.RoomId = E.ID
  where A.isissue = 1 and A.isCancel = 0 and A.isBack = 0 and A.RecipeTime >= @fromDate and A.RecipeTime < @nextDate;
  /* todo OuRecipeTemp 有重复！
  select A.ID, E.name, B.OperTime, B.mzRegID, B.MzRegNo, B.locationID, B.LocationName, A.itemID, D.name, A.Totality, A.price, A.Totality * A.price,
         A.doctorID, C.name, case B.LsRepType when 1 then '西药方' when 2 then '草药方' else '' end
  from YBHis.LJHis.dbo.OuRecipeDtl A
         left join YBHis.LJHis.dbo.OuRecipeTemp B On A.recipeID = B.recipeID
         left join YBHis.LJHis.dbo.BSUsage C on A.UsageId = C.ID
         left join YBHis.LJHis.dbo.BSUnit D on A.UnitDiagId = D.ID
         left join YBHis.LJHis.dbo.BsRoom E ON B.RoomId = E.ID
  where A.IsCancel = 0 AND B.isIssue = 1 and B.isBack = 0 and B.OperTime >= @fromDate and B.OperTime < @nextDate;*/
  select @lastID = SCOPE_IDENTITY();

  --急诊、普通方、主任医师。。。
  UPDATE A
  SET A.clinicType= case when A.clinicType = '草药方' then '草药方' else T.regTypeName end,
      A.hospID=T.ID,
      A.patientName=T.patientName
  FROM DrugRecords A
         left join (select B.ID, B.mzRegNo, B.name patientName, C.name regTypeName
                    FROM YBHis.LJHis.dbo.OuHosInfo B
                           left join YBHis.LJHis.dbo.BsRegType C on C.ID = B.RegTypeId) T on T.mzRegNo = A.dispensingNo;
  --todo 挂号儿科，就是儿科方？

  --住院领药
  insert into DrugRecords(recordID, drugstore, dispensingDate, hospID, dispensingNo, departID, goodsID, unit, quantity, price, amount,
                          doctorID, usage, adviceId)
  select A.ID, C.name, B.ConfirmDate, A.HospId, B.RequestNo, B.LocationId, A.itemID, D.name, A.Totality, A.priceIn, A.Totality * A.priceIn,
         A.DoctorID, A.F3, A.adviceId
  from YBHis.LJHis.dbo.InDrugReqdtl A
         left join YBHis.LJHis.dbo.InDrugReq B ON A.requestID = B.ID
         left join YBHis.LJHis.dbo.BsRoom C ON B.RoomId = C.ID
         left join YBHis.LJHis.dbo.BSUnit D on A.UnitReq = D.ID
  where isIssued = 1 and B.ConfirmDate >= @fromDate and B.confirmDate < @nextDate;
  select @lastID = SCOPE_IDENTITY();

  --医生姓名
  UPDATE A
  SET A.doctorName=B.name
  FROM DrugRecords A,
       YBHis.LJHis.dbo.BsDoctor B
  where A.doctorID = B.ID;
  --病人姓名 todo 性别、年龄
  UPDATE A
  SET A.patientName=B.name
  FROM DrugRecords A,
       YBHis.LJHis.dbo.InHosinfo B
  where A.hospID = B.ID and A.adviceID > 0;
  --科室名
  UPDATE A
  SET A.department=B.name
  FROM DrugRecords A,
       YBHis.LJHis.dbo.BsLocation B
  where A.departID = B.ID;
  --长嘱、临嘱、出院带药
  UPDATE A
  SET A.clinicType= case LsMarkType when 1 then '长嘱' when 2 then '临嘱' when 5 then '出院带药' else '' end
  FROM DrugRecords A,
       YBHis.LJHis.dbo.InExecute B
  where A.adviceId = B.ID;
  -- todo 出院带药没数据，需要通过adviceID关联医嘱更新
  --按年放入表
  if object_id(@dstTableName, N'U') is null
    begin
      exec sp_copy_table 'DrugRecords', @dstTableName;
      exec sp_copy_index 'DrugRecords', @dstTableName;
    end
  set @sqlString = 'insert into ' + @dstTableName +
                   '(recordID,drugstore,dispensingDate,hospID,patientName,dispensingNo,departID,department,clinicType,goodsID,unit,
                   quantity,price,doctorID,doctorName,usage,amount,adviceId,valid)
                      select recordID,drugstore,dispensingDate,hospID,patientName,dispensingNo,departID,department,clinicType,goodsID,unit,
                      quantity,price,doctorID,doctorName,usage,amount,adviceId,valid from DrugRecords;'
  exec (@sqlString);
  SELECT @insertRowCount = @@rowcount;
  IF (@logID > 0)
    BEGIN
      if (@lastID = 0 or @lastID is null)
        begin
          set @sqlString = N'SELECT @lastID = CASE WHEN max(drID) IS NULL THEN 0 ELSE max(drID) END FROM ' + @dstTableName;
          EXEC SP_EXECUTESQL @sqlString, N'@lastID int OUTPUT', @lastID OUTPUT;
        end
      EXEC monitorUpdateTaskLog @logID, 'ljDrugRecords', @dstTableName, @lastID, 0, @insertRowCount, 0, @startTime;
    END;

  delete from DrugRecords;
END ;
go

