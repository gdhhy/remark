--注意！不能跨年！
CREATE PROCEDURE [dbo].[ljClinic](@logID INT, @fromDate VARCHAR(10), @toDate VARCHAR(10))
AS
DECLARE
  @lastID         INT,
  @dstTableName   varchar(220),
  @insertRowCount INT,
  @deleteRowCount INT,
  @startTime      DATETIME,
  @nextDate       SMALLDATETIME,
  @sqlString      nvarchar(1023),
  @timeSpent      INT
BEGIN
  --BEGIN TRAN --此时 @@TRANCOUNT为 1
  SELECT @startTime = getdate(), @nextDate = dateadd(DAY, datediff(DAY, 0, @toDate), 1), @dstTableName = 'RxDetail_' + left(@fromDate, 4);
  delete Rx where prescribeDate >= @fromDate and prescribeDate < @nextDate;
  SELECT @deleteRowCount = @@rowcount;

  insert into Rx(ouRecipeID, hospID, rxNo, recipeNum, mzNo, prescribeDate, patientID, patientName, sex,
                 ageString, nAge, department, diagnosis,
                 doctorID, clinicType, copyNum, isWestern, Memo)
  SELECT E.ID, A.mzRegID, A.RecipeId, E.recipeNum, A.MzRegNo, A.recipeTime, B.patID, A.name, case A.sex when '女' then 0 else 1 end,
         B.ageString, B.age, A.LocationName, B.F3 IllDesc,
         -- case when B.F3 is null then  stuff((select distinct ','+IllDesc from YBHis.LJHis.dbo.OuClincDiag where mzRegID=A.mzRegID for XML PATH('')),1,1,'') else B.F3 end  IllDesc,
         A.DoctorId, case when C.Name is null then '普通门诊' else C.Name end, A.howMany, E.LsRepType, E.memo
  from YBHis.LJHis.dbo.OuRecipe E
         left join YBHis.LJHis.dbo.OuRecipeTemp A on E.mzRegID = A.mzRegID and A.isBack = 0 and A.isIssue = 1
         left join YBHis.LJHis.dbo.OuHosInfo B on A.MzRegNo = B.MzRegNo
         left join YBHis.LJHis.dbo.BsRegType C on C.ID = B.RegTypeId
  where A.recipeTime >= @fromDate and A.recipeTime < @nextDate;
  /*2020-07-08
  update A
set diagnosis=B.IllDesc
FROM Rx A
       LEFT JOIN YBHis.LJHis_yber.dbo.OuClincDiag B ON A.hospID = B.mzRegID;*/
  /*SELECT distinct A.mzRegID, A.RecipeId, A.MzRegNo, A.recipeTime, B.patID, A.name, case A.sex when '女' then 0 else 1 end,
                  A.BabyMonth, A.age, A.LocationName, A.IllDesc, A.DoctorId, case when C.Name is null then '普通门诊' else C.Name end, A.howMany, A.LsRepType
  from YBHis.LJHis.dbo.OuRecipeTemp A
         left join YBHis.LJHis.dbo.OuHosInfo B on A.RecipeNum = B.MzRegNo
         left join YBHis.LJHis.dbo.BsRegType C on C.ID = B.RegTypeId
  where (A.LsRepType = 1 or A.LsRepType = 2) and A.isBack = 0 AND A.recipeTime >= @fromDate and A.recipeTime < @nextDate;*/

  /*--todo 重复待确认
  SELECT * FROM YBHis.LJHis.dbo.OuRecipeTemp where ( LsRepType = 1 or LsRepType = 2 ) and isBack=0  and mzregNo in(
  SELECT MzRegNo FROM YBHis.LJHis.dbo.OuRecipeTemp where ( LsRepType = 1 or LsRepType = 2 ) and isBack=0  group by MzRegNo having count(MzRegNo)>1) order by mzregno

  SELECT  distinct RecipeId,MzRegId,MzRegNo,RegTime,Sex,Age,BabyMonth,AddressHome,IllDesc,Name,LsRepType,RecipeNum,RecipeTime,LocationId,DoctorId,HowMany,IsPriority,Memo,IsPend,IsExecuted,CardNo,ContactPhone,PyCode1,WbCode1,PyCode2,WbCode2,PyCode3,
WbCode3,Amount,DoctorName,LocationName,HospitalId,RoomId,IsIssue,IsBack,RoomWindowName,F1,F2,F3,F4,OperTime,LsReportType,DosageOperId,DosageTime FROM "dbo"."OuRecipeTemp"
where   mzRegID  = 226658   ;
  */
  /*Insert into Rx (rxID,hospID,rxNo,prescribeDate,patientName,sex,age,nAge,department,diagnosis,doctorID,clinicType )
  select rxID,hospID,rxNo,prescribeDate,patientName,sex,age,nAge,department,diagnosis,doctorID,clinicType from #Rx;*/
  SELECT @insertRowCount = @@rowcount;

  IF (@logID > 0)
    BEGIN
      SELECT @lastID = CASE WHEN max(rxID) IS NULL THEN 0 ELSE max(rxID) END FROM Rx;
      --SELECT @timeSpent = datediff(MS, @startTime, getdate());
      EXEC monitorUpdateTaskLog @logID, 'ljClinic', 'Rx', @lastID, @deleteRowCount, @insertRowCount, -1, @startTime;
      select @lastID = 0;
    END;

  insert into RxDetail(rxNo, prescribeDate, goodsID, quantity, money, frequency, freqNum, unit, eachUnit,
                       dosage, spec, usage, eachQuantity, dayNum, price, orderID, groupID, paperNo, memo)
  select A.RecipeId, A.recipeTime, A.ItemId, A.Totality, A.price * A.Totality money, C.name Frequency, C.Times, B.Name, F.name,
         E.name                                                               medicineName, E.spec, D.name usageName, A.Dosage, A.days, A.price, A.ID, A.groupNum, listNum, A.memo
         --A.groupNum, A.listNum,recNum
  from YBHis.LJHis.dbo.OuRecipeDtl A
         join YBHis.LJHis.dbo.BSItem E on A.ItemId = E.ID
         left join YBHis.LJHis.dbo.BSUnit B on A.UnitDiagId = B.ID
         left join YBHis.LJHis.dbo.BSUnit F on A.UnitTakeId = F.ID
         left join YBHis.LJHis.dbo.BsFrequency C on A.FrequencyId = C.ID
         left join YBHis.LJHis.dbo.BsUsage D on A.UsageId = D.ID
  where isissue = 1 and isCancel = 0 and isBack = 0 and E.LsGroupType = 1 and recipeTime >= @fromDate and recipeTime < @nextDate;
  --按年放入表
  if object_id(@dstTableName, N'U') is null
    begin
      exec sp_copy_table 'RxDetail', @dstTableName;
      exec sp_copy_index 'RxDetail', @dstTableName;
    end
  set @sqlString = 'delete from ' + @dstTableName + ' where prescribeDate>=''' + @fromDate + ''' and prescribeDate<''' + convert(varchar(10), @nextDate, 120) + ''';';
  --select @sqlstring;
  exec (@sqlString);
  SELECT @deleteRowCount = @@rowcount;

  set @sqlString = 'insert into ' + @dstTableName +
                   '(rxNo, prescribeDate,goodsID,quantity,money,frequency,freqNum,unit,eachUnit,
                     dosage,spec,usage,eachQuantity,dayNum,price,orderID,groupID,paperNo,memo)
                   select rxNo, prescribeDate,goodsID,quantity,money,frequency,freqNum,unit,eachUnit,
                     dosage,spec,usage,eachQuantity,dayNum,price,orderID,groupID,paperNo,memo from RxDetail;'
  exec (@sqlString);
  SELECT @insertRowCount = @@rowcount;

  delete from RxDetail;


  IF (@logID > 0)
    BEGIN
      if (@lastID = 0)
        begin
          set @sqlString = 'SELECT @lastID = CASE WHEN max(rxDetailID) IS NULL THEN 0 ELSE max(rxDetailID) END FROM ' + @dstTableName;
          EXEC SP_EXECUTESQL @sqlString, N'@lastID int OUTPUT', @lastID OUTPUT;
        end
      EXEC monitorUpdateTaskLog @logID, 'ljClinic', @dstTableName, @lastID, @deleteRowCount, @insertRowCount, -1, @startTime;
    END;
END ;
go

