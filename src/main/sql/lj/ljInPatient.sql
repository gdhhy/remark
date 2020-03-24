--注意！不能跨年！
CREATE PROCEDURE [dbo].[ljInPatient](@logID INT, @fromDate VARCHAR(10), @toDate VARCHAR(10))
AS
DECLARE
  @lastID         INT,
  @dstTableName   varchar(220),
  @insertRowCount INT,
  @deleteRowCount INT,
  @startTime      DATETIME,
  @nextDate       SMALLDATETIME,
  @year           int,
  @sqlString      nvarchar(1023)
BEGIN
  --BEGIN TRAN --此时 @@TRANCOUNT为 1sex
  SELECT @startTime = getdate(), @nextDate = dateadd(DAY, datediff(DAY, 0, @toDate), 1), @dstTableName = 'AdviceItem_' + left(@fromDate, 4), @lastID = 0;

  delete InPatient where outDate >= @fromDate and outDate < @nextDate;
  SELECT @deleteRowCount = @@rowcount;

  insert into InPatient(hospID, hospNo, patientID, patientName, sex, age, inDate, outDate, inHospitalDay, department, diagnosis, diagnosis2, incision,
                        masterDoctorID, masterDoctorName, dAge, money,stay)
  select A.ID, A.hospNo, A.patID, A.Name, case sex when 'M' then 1 else 0 end, A.age, inTime, outTime, datediff(dd, inTime, outTime) + 1 inHospitalDay, B.name,
         stuff((select distinct ',' + IllDesc from YBHis.LJHis.dbo.InHosMzIll where HospId = A.id and LsInOut = 1 for XML PATH ('')), 1, 1, '') diagnosis,
         stuff((select distinct ',' + IllDesc from YBHis.LJHis.dbo.InHosMzIll where HospId = A.id and LsInOut = 2 for XML PATH ('')), 1, 1, '') diagnosis2,
         stuff((select distinct ',' + cast(LsCut as varchar) from YBHis.LJHis.dbo.InHosOps where HospId = A.id for XML PATH ('')), 1, 1, '') incision,
         A.doctorID, C.name, A.age, E.Beprice,A.IsIllegal
  from YBHis.LJHis.dbo.InHosInfo A
         left join YBHis.LJHis.dbo.BsLocation B on A.locationID = B.ID
         left join YBHis.LJHis.dbo.InInvoice E on A.ID = E.hospID and E.LsPayType = 2 and E.isCancel = 0 --todo 确认发票没有中途结账开发票
         left join Doctor C on A.doctorID = C.doctorID
  where outTime >= @fromDate and outTime < @nextDate; -- todo or outTime is null;未出院的导不导？

  SELECT @insertRowCount = @@rowcount;
  IF (@logID > 0)
    BEGIN
      if (@lastID = 0)
        SELECT @lastID = CASE WHEN max(inPatientID) IS NULL THEN 0 ELSE max(inPatientID) END FROM InPatient;
      EXEC monitorUpdateTaskLog @logID, 'ljInPatient', 'InPatient', @lastID, @deleteRowCount, @insertRowCount, -1, @startTime;
    END;

  select @lastID = 0;
  insert into AdviceItem(hospID, longAdvice, adviceDate, advice, spec, adviceType, goodsID, doctorName, nurseName, endDate, endDoctorName,
                         endNurseName, quantity, unit, frequency, usage, total, price, orderID, groupID)
  select A.hospID, 1, A.adviceTime, case when B.name = '记事医嘱' then A.Memo else B.name end advice, B.Spec,
         B.LsGroupType adviceType, A.itemID, C.name doctorName, D.name nurseName, A.EndOperTime,
         I.name stopDoctorName, E.name endNurseName, A.Dosage, F.name, G.name frequency,
         H.name usage, A.totality, A.priceIn, A.ID, A.groupNum
  from YBHis.LJHis.dbo.InAdviceLong A
         left join YBHis.LJHis.dbo.BSItem B on A.ItemId = B.ID
         left join Doctor C on A.doctorID = C.doctorID
         left join YBHis.LJHis.dbo.BsUser D on A.AuthOperID = D.ID
         left join YBHis.LJHis.dbo.BsUser E on A.EndOperID = E.ID
         left join YBHis.LJHis.dbo.BSUnit F on A.UnitTakeId = F.ID
         left join YBHis.LJHis.dbo.BsFrequency G on A.FrequencyId = G.ID
         left join YBHis.LJHis.dbo.BsUsage H on A.UsageId = H.ID
         left join Doctor I on A.EndDoctorID = I.doctorID
  where hospID in (select id from YBHis.LJHis.dbo.InHosInfo where outTime >= @fromDate and outTime < @nextDate);
  --where adviceTime >= @fromDate and adviceTime < @nextDate;

  insert into AdviceItem(hospID, longAdvice, adviceDate, advice, spec, adviceType, goodsID, doctorName, nurseName,
                         quantity, unit, frequency, usage, total, price, orderID, groupID)
  select A.hospID, 2, A.adviceTime, case when B.name = '记事医嘱' then A.Memo else B.name end advice, B.Spec,
         B.LsGroupType adviceType, A.itemID, C.name doctorName, D.name nurseName,
         A.Dosage, F.name, G.name frequency, H.name usage, A.totality, A.priceIn, A.ID, A.groupNum
  from YBHis.LJHis.dbo.InAdviceTemp A
         left join YBHis.LJHis.dbo.BSItem B on A.ItemId = B.ID
         left join Doctor C on A.doctorID = C.doctorID
         left join YBHis.LJHis.dbo.BsUser D on A.AuthOperID = D.ID
         left join YBHis.LJHis.dbo.BSUnit F on A.UnitTakeId = F.ID
         left join YBHis.LJHis.dbo.BsFrequency G on A.FrequencyId = G.ID
         left join YBHis.LJHis.dbo.BsUsage H on A.UsageId = H.ID
  where hospID in (select id from YBHis.LJHis.dbo.InHosInfo where outTime >= @fromDate and outTime < @nextDate);
  --where adviceTime >= @fromDate and adviceTime < @nextDate;

  --按年放入表
  if object_id(@dstTableName, N'U') is null
    begin
      exec sp_copy_table 'AdviceItem', @dstTableName;
      exec sp_copy_index 'AdviceItem', @dstTableName;
    end
  --set @sqlString = 'delete from ' + @dstTableName + ' where adviceDate >=''' + @fromDate + ''' and adviceDate <''' + convert(varchar(10), @nextDate, 120) + ''';';
  set @sqlString = 'delete from ' + @dstTableName +
                   ' where hospID in(select hospID from inPatient where outDate>=''' + @fromDate +
                   ''' and outDate <''' + convert(varchar(10), @nextDate, 120) + ''');';
  --select @sqlstring;
  exec (@sqlString);
  SELECT @deleteRowCount = @@rowcount;

  set @sqlString = 'insert into ' + @dstTableName +
                   '(hospID,longAdvice,adviceDate,advice,spec,adviceType,goodsID,doctorName,nurseName,endDate,endDoctorName,endNurseName,quantity,unit,' +
                   'frequency,usage,total,price,orderID,groupID)
                select hospID,longAdvice,adviceDate,advice,spec,adviceType,goodsID,doctorName,nurseName,endDate,endDoctorName,endNurseName,quantity,unit,' +
                   'frequency,usage,total,price,orderID,groupID from AdviceItem;'
  exec (@sqlString);
  SELECT @insertRowCount = @@rowcount;

  delete from AdviceItem;

  IF (@logID > 0)
    BEGIN
      if (@lastID = 0)
        begin
          set @sqlString = N'SELECT @lastID = CASE WHEN max(adviceItemID) IS NULL THEN 0 ELSE max(adviceItemID) END FROM ' + @dstTableName;
          EXEC sp_executesql @sqlString, N'@lastID as int OUTPUT', @lastID OUTPUT;
        end
      EXEC monitorUpdateTaskLog @logID, 'ljInPatient', @dstTableName, @lastID, @deleteRowCount, @insertRowCount, -1, @startTime;
    END;

  --手术
  delete Surgery where operTime >= @fromDate and operTime < @nextDate;
  select @deleteRowCount = @@rowcount
  insert into Surgery (hospID, inEmrID,no, surgeryName, incision, surgeryDate, operTime)
  select distinct A.hospID, A.inEmrID, A.surgeryNo, a.surgeryName, B.incision, C.surgeryDate, A.operTime
  from (select case when xmlField like 'FOP[1-9]' then xmlValue else null end surgeryName, right(xmlField, 1) surgeryNo, hospID, inEmrID, operTime
        from YBHis.LjHis.dbo.InEmrXml
        where operTime >= @fromDate and operTime < @nextDate and xmlField like 'FOP[1-9]') A
         left join
       (select case when xmlField like 'fqiekou[1-9]' then xmlValue else null end incision, right(xmlField, 1) surgeryNo, hospID, inEmrID
        from YBHis.LjHis.dbo.InEmrXml
        where operTime >= @fromDate and operTime < @nextDate and xmlField like 'fqiekou[1-9]') B
       on A.hospID = B.hospID and A.surgeryNo = B.surgeryNo and A.inEmrID = B.inEmrID
         join
       (select case when xmlField like 'fopdate[1-9]' then xmlValue else null end surgeryDate, right(xmlField, 1) surgeryNo, hospID, inEmrID
        from YBHis.LjHis.dbo.InEmrXml
        where operTime >= @fromDate and operTime < @nextDate and xmlField like 'fopdate[1-9]') C
       on A.hospID = C.hospID and A.surgeryNo = C.surgeryNo and A.inEmrID = C.inEmrID

  SELECT @insertRowCount = @@rowcount;

  IF (@logID > 0)
    BEGIN
      SELECT @lastID = CASE WHEN max(surgeryID) IS NULL THEN 0 ELSE max(surgeryID) END FROM Surgery;
      EXEC monitorUpdateTaskLog @logID, 'ljInPatient', 'Surgery', @lastID, @deleteRowCount, @insertRowCount, -1, @startTime;
    END;

  --诊断 todo ?
  --整理AdviceItem，按出院日期存放
  /*select @year = cast(left(@fromDate, 4) as int);
  while @year > cast(left(@fromDate, 4) as int) - 5
  begin
    select @year = @year - 1;
    select @dstTableName = 'AdviceItem_' + cast(@year as varchar);

  end*/

END ;
go

