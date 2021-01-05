--！！！需要确保beginTime 、 endTime 同一年内！！！
CREATE PROCEDURE [dbo].[buildClinicInPatient](@logID INT, @beginTime VARCHAR(10), @endTime VARCHAR(10)) AS
DECLARE
  @startTime        DATETIME,
  @statdate         VARCHAR(10),
  @nextDate         VARCHAR(10),
  @fromClinicID     INT,
  @toClinicID       INT,
  @insertRowCount   INT,
  @updateRowCount   INT,
  @concurCount      INT,
  @rxDetailTable    varchar(100),
  @adviceItemTable1 varchar(100),
  @adviceItemTable2 varchar(100),--上一年
  @drugTable1       varchar(100),
  @drugTable2       varchar(100),--上一年
  @sqlString        varchar(8000),
  @sqlString2       varchar(8000),
  @sqlString3       varchar(8000),
  @sqlString4       varchar(8000),
  @sqlString5       varchar(1000),
  @sqlString6       varchar(1000)
BEGIN
  IF (@logID = 0)
    EXEC monitorWriteTaskLog '重建门诊、住院数据', @beginTime, @endTime, @logID OUTPUT;

  SELECT @startTime = getdate(), @insertRowCount = -1, @updateRowCount = -1,
         @nextDate = convert(VARCHAR(10), dateadd(DAY, datediff(DAY, 0, @endTime), 1), 120),
         @rxDetailTable = 'RxDetail_' + left(@beginTime, 4),
         @adviceItemTable1 = 'AdviceItem_' + left(@beginTime, 4),
         @adviceItemTable2 = 'AdviceItem_' + cast(datediff(year, 0, @beginTime) + 1899 as char(4)),
         @drugTable1 = 'DrugRecords_' + left(@beginTime, 4),
         @drugTable2 = 'DrugRecords_' + cast(datediff(year, 0, @beginTime) + 1899 as char(4));
  /*   between >= and <= */
  --********************************门诊部分********************************
  SELECT @fromClinicID = CASE WHEN max(clinicID) IS NULL THEN 0 ELSE max(clinicID) END + 1 FROM Clinic;

  --alter table Clinic add babyMonth int ;
  INSERT INTO Clinic (hospID, rxCount, mzNo, clinicDate, patientID, patientName, sex, age, ageString,department,
                      diagnosis, money, doctorID, confirmNo, apothecaryNo, isWestern, clinicType, copyNum,memo)
  SELECT hospID, count(hospID) rxCount, max(mzNo), max(prescribeDate), max(patientID), max(patientName), max(sex), max(nAge),max(ageString) ,max(department),
         max(diagnosis), 0, max(doctorID), max(confirmNo), max(apothecaryNo), isWestern, max(clinicType), max(copyNum), max(memo)
  FROM Rx
  WHERE isWestern > 0 AND hospID NOT IN (SELECT hospID FROM Clinic) AND valid = 1
  GROUP BY hospID, isWestern;
  SELECT @insertRowCount = @@rowCount, @toClinicID = IDENT_CURRENT('Clinic');

  update Clinic set clinicType='儿科方' where department like '%儿科%';-- todo confirm!
  update Clinic set clinicType='草药方' where isWestern = 2;
  set @sqlString = 'UPDATE R SET clinicID = P.clinicID ' +
                   'FROM ' + @rxDetailTable + ' R, Rx, Clinic P ' +
                   'WHERE R.rxNo = Rx.rxNo AND P.hospID = Rx.hospID AND P.isWestern = Rx.isWestern ';

  set @sqlString2 = 'UPDATE P ' +
                    'SET drugNum = B.drugNum, baseDrugNum = B.baseDrugNum, money = B.amount ' +
                    'FROM Clinic P,
        (SELECT clinicID, count(M.goodsID) drugNum, sum(CASE WHEN M.base >= 1 AND M.dose!=''大输液'' THEN 1 ELSE 0 END) baseDrugNum,' +
                    'sum(case when money > 0 then money when M.minOfpack > 0 then R.quantity * M.price / M.minOfpack else 0 end) amount
         FROM ' + @rxDetailTable + ' R JOIN Medicine M ON R.goodsID = M.goodsID
        GROUP BY R.clinicID HAVING sum(quantity) > 0) B WHERE P.clinicID = B.clinicID ';
  set @sqlString3 = 'UPDATE P ' +
                    'SET baseDrugMoney = B.baseDrugMoney, antiNum = B.antiNum, injectionNum = isNull(B.injectionNum, 0),
                        injectionAntiNum = B.injectionAntiNum, orallyAntiNum = B.orallyAntiNum, antiMoney = B.antiMoney,
                        injectionAntiMoney = B.injectionAntiMoney, orallyAntiMoney = B.orallyAntiMoney, insuranceMoney = B.insuranceMoney,
                        specAntiMoney = B.specAntiMoney
                    FROM Clinic P,
                         (SELECT A.clinicID,
                                 sum(CASE WHEN M.base >= 1 THEN money ELSE 0 END)                                      baseDrugMoney,
                                 sum(CASE WHEN M.antiClass > 0 AND M.isStat = 1 THEN 1 ELSE 0 END)                     antiNum,
                                 sum(CASE WHEN M.route = 2 THEN 1 ELSE 0 END)                                          injectionNum,
                                 sum(CASE WHEN M.route = 2 AND M.antiClass > 0 AND M.isStat = 1 THEN 1 ELSE 0 END)     injectionAntiNum,
                                 sum(CASE WHEN M.insurance > 0 THEN money ELSE 0 END)                                  insuranceMoney,
                                 sum(CASE WHEN M.route = 1 AND M.antiClass > 0 AND M.isStat = 1 THEN 1 ELSE 0 END)     orallyAntiNum,
                                 sum(CASE WHEN M.antiClass > 0 AND M.isStat = 1 THEN money ELSE 0 END)                 antiMoney,
                                 sum(CASE WHEN M.route = 2 AND M.antiClass > 0 AND M.isStat = 1 THEN money ELSE 0 END) injectionAntiMoney,
                                 sum(CASE WHEN M.route = 1 AND M.antiClass > 0 AND M.isStat = 1 THEN money ELSE 0 END) orallyAntiMoney,
                                 sum(CASE WHEN M.antiClass = 3 AND M.isStat = 1 THEN money ELSE 0 END)                 specAntiMoney,
                                 A.western
                          FROM (SELECT clinicID, R.goodsID, case when m.western = 1 then 1 else 2 end western, sum(money) money
                                FROM ' + @rxDetailTable + ' R, Medicine M ' +
                    ' WHERE R.goodsID = M.goodsID
                    GROUP BY clinicID, R.goodsID, M.western) A
                    JOIN Medicine M ON A.goodsID = M.goodsID
                    GROUP BY A.clinicID, A.western) B
                    WHERE B.clinicID = P.clinicID AND P.isWestern = B.western';
  --同种抗菌素      sameInjectAntiNum    sameOrallyAntiNum
  set @sqlString4 = 'UPDATE P ' +
                    'SET sameAntiNum = isnull(B.sameAntiNum, 0), sameInjectAntiNum = isnull(B.injectionAntiNum, 0), sameOrallyAntiNum = isnull(B.orallyAntiNum, 0)' +
                    'FROM Clinic P,
                         (SELECT clinicID,
                                 LEFT(healthNo, 6)                                      healthNo,
                                 count(left(healthNo, 6))                               sameAntiNum,
                                 count(CASE WHEN route = 2 THEN healthNo ELSE NULL END) injectionAntiNum,
                                 count(CASE WHEN route = 1 THEN healthNo ELSE NULL END) orallyAntiNum
                          FROM (SELECT clinicID, goodsID, sum(quantity) quantity, sum(money) money
                                FROM ' + @rxDetailTable +
                    ' GROUP BY clinicID, goodsID
                    HAVING sum(quantity) > 0) A ' +
                    'JOIN Medicine M ON A.goodsID = M.goodsID ' +
                    'WHERE M.antiClass > 0 AND M.isStat = 1 AND M.healthNo IS NOT NULL
                    GROUP BY clinicID, LEFT(healthNo, 6)
                     --HAVING COUNT(LEFT(healthNo, 6)) > 1
                   ) B WHERE B.clinicID = P.clinicID ';

  set @sqlString5 = ' UPDATE P SET clinicType = ''精神处方'' ' +
                    'FROM ' + @rxDetailTable + ' R,   Clinic P, Medicine M ' +
                    'WHERE R.clinicID=P.clinicID  and R.goodsID=M.goodsID and (M.mental=1 or M.mental=2) ';
  set @sqlString6 = ' UPDATE P SET clinicType = ''麻醉处方'' ' +
                    'FROM ' + @rxDetailTable + ' R,   Clinic P, Medicine M ' +
                    'WHERE R.clinicID=P.clinicID  and R.goodsID=M.goodsID and M.mental=4 ';

  IF (@insertRowCount > 0) --按id范围更新，给importIntoReview调用，@endTime赋值getdate()
    BEGIN
      print 'exec by between clinicID';
      set @sqlString = @sqlString + ' AND P.clinicID BETWEEN ' + cast(@fromClinicID as varchar(10)) + ' AND ' + cast(@toClinicID as varchar(10));
      set @sqlString2 = @sqlString2 + ' AND P.clinicID BETWEEN ' + cast(@fromClinicID as varchar(10)) + ' AND ' + cast(@toClinicID as varchar(10));
      set @sqlString3 = @sqlString3 + ' AND P.clinicID BETWEEN ' + cast(@fromClinicID as varchar(10)) + ' AND ' + cast(@toClinicID as varchar(10));
      set @sqlString4 = @sqlString4 + ' AND P.clinicID BETWEEN ' + cast(@fromClinicID as varchar(10)) + ' AND ' + cast(@toClinicID as varchar(10));
      set @sqlString5 = @sqlString5 + ' AND P.clinicID BETWEEN ' + cast(@fromClinicID as varchar(10)) + ' AND ' + cast(@toClinicID as varchar(10));
      set @sqlString6 = @sqlString6 + ' AND P.clinicID BETWEEN ' + cast(@fromClinicID as varchar(10)) + ' AND ' + cast(@toClinicID as varchar(10));
    END
  ELSE --按时间范围更新
    IF (@beginTime < @endTime) --单独调用 @beginTime为开始时间，@endTime为结束时间
      BEGIN
        print 'exec by between clinicDate';
        set @sqlString = @sqlString + ' AND P.clinicDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + '''';
        set @sqlString2 = @sqlString2 + ' AND P.clinicDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + '''';
        set @sqlString3 = @sqlString3 + ' AND P.clinicDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + '''';
        --同种抗菌素      sameInjectAntiNum    sameOrallyAntiNum
        set @sqlString4 = @sqlString4 + ' AND P.clinicDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + '''';
        set @sqlString5 = @sqlString5 + ' AND P.clinicDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + '''';
        set @sqlString6 = @sqlString6 + ' AND P.clinicDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + '''';
      END
  /* select @sqlString as sql
   union all
   select @sqlString2 as sql
   union all
   select @sqlString3 as sql
   union all
   select @sqlString4 as sql;*/

  exec (@sqlString);
  SELECT @updateRowCount = @@rowcount;
  exec (@sqlString2);
  SELECT @updateRowCount = @updateRowCount + @@rowcount;
  exec (@sqlString3);
  SELECT @updateRowCount = @updateRowCount + @@rowcount;
  exec (@sqlString4);
  SELECT @updateRowCount = @updateRowCount + @@rowcount;
  exec (@sqlString5);
  SELECT @updateRowCount = @updateRowCount + @@rowcount;
  exec (@sqlString6);
  SELECT @updateRowCount = @updateRowCount + @@rowcount;

  UPDATE P
  SET doctorName = D.name
  FROM Clinic P,
       Doctor D
  WHERE D.doctorID = P.doctorID AND doctorName IS NULL;
  --UPDATE P SET confirmName = D.name FROM Clinic P, Doctor D WHERE D.doctorNo = right(P.confirmNo, 3) AND confirmName IS NULL;
  --UPDATE P SET apothecaryName = D.name FROM Clinic P, Doctor D WHERE D.doctorNo = right(P.apothecaryNo, 3) AND apothecaryName IS NULL;
  EXEC monitorUpdateTaskLog @logID, 'buildClinicInPatient', 'Clinic', @toClinicID, -1, @insertRowCount, @updateRowCount, @startTime;

  -- 2021年增加，药剂科反馈：很多处方金额为零，删除它。也为后续导入检查方，提高阳光用药数据准确性。
  delete Clinic where money<0.001;
  --***********************住院部分********************************
  SELECT @startTime = getdate(), @updateRowCount = -1;
  --药品数量
  set @sqlString = 'UPDATE R SET drugNum = I.drugNum ' +
                   'FROM InPatient R, (SELECT R.hospID, COUNT(DISTINCT R.groupID + (R.longadvice - 1) * 99) drugNum FROM ' +
                   '(SELECT hospID, goodsID, groupID, longadvice FROM ' + @adviceItemTable1 +
                   ' UNION ALL ' +
                   ' SELECT hospID, goodsID, groupID, longadvice FROM ' + @adviceItemTable2 +
                   ')R, Medicine M WHERE R.goodsID = M.goodsID
                    AND hospID IN (SELECT hospID FROM InPatient R WHERE R.outDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + ''')
                  GROUP BY hospID) I ' +
                   'WHERE R.hospID = I.hospID AND  R.outDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + '''';
  -- OR outDate IS NULL
  --select @sqlString as 'sql3';
  exec (@sqlString);
  SELECT @updateRowCount = @@rowcount;
  --药敏和细菌培养
  /*   set @sqlString = 'UPDATE R SET checkItem = I.checkItem1 + I.checkItem2 + I.checkItem3+ I.checkItem4 ' +
                  'FROM InPatient R, (SELECT R.hospID,' +
                    '  max(CASE WHEN advice LIKE ''%涂片%'' OR advice LIKE ''%细菌培养%'' THEN 1 ELSE 0 END)  checkItem1,' +
                    '  max(CASE WHEN (advice LIKE ''%涂片%'' OR advice LIKE ''%细菌培养%'') and M.antiClass=2 THEN 4 ELSE 0 END)  checkItem2,' +--microbeLimit 微生物送检限制级
                    '  max(CASE WHEN (advice LIKE ''%涂片%'' OR advice LIKE ''%细菌培养%'') and M.antiClass=3 THEN 8 ELSE 0 END)  checkItem3,' +--microbeSpec 微生物送检特殊级
                    '  max(CASE WHEN advice LIKE ''%药敏%'' THEN 16 ELSE 0 END) checkItem4 FROM ' +
                    '(SELECT hospID, advice FROM ' + @adviceItemTable1 +
                    ' UNION ALL ' +
                    ' SELECT hospID, advice FROM ' + @adviceItemTable2 +
                    ') R WHERE hospID IN (SELECT hospID FROM InPatient R WHERE R.outDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + ''')
                   GROUP BY hospID) I ' +
                    'WHERE R.hospID = I.hospID AND  R.outDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + '''';*/
  -- OR outDate IS NULL
  --select @sqlString as 'sql4';
  exec (@sqlString);
  SELECT @updateRowCount = @updateRowCount + @@rowcount;
  --药敏和细菌培养
  --切口与术前用药
  set @sqlString = 'UPDATE R SET surgery=A.surgery, incision = A.incision, checkItem = A.checkItem0 + A.checkItem1 + A.checkItem2 + A.checkItem3 + A.checkItem4 ' +
                   'FROM InPatient R,' +
                   '  (SELECT S.hospID,' +
                   '      max(case when S.surgeryID>0 then 1 else 0 end) surgery,' +
                   '      max(CASE WHEN S.incision = ''Ⅰ'' THEN 1 ELSE 0 END) + max(CASE WHEN S.incision = ''Ⅱ''  THEN 2 ELSE 0 END) + max(CASE WHEN S.incision = ''Ⅲ''  THEN 4 ELSE 0 END)+
                            max(CASE WHEN S.incision = ''Ⅰ'' AND M.antiClass > 0 THEN 8 ELSE 0 END) + ' +-- 一类切口使用抗菌药
                   '        max(CASE WHEN S.incision = ''Ⅰ''  AND M.antiClass > 0 AND ' +
                   '          (datediff(mi, I.adviceDate, S.operTime) between 30 and 120 or advice LIKE ''%术前半小时%'' OR advice LIKE ''%术前30%'' OR advice LIKE ''%带入手术室%'') THEN 16 ELSE 0 END) incision, ' +-- 一类切口术前0.5-2小时预防用药
                   '      max(CASE WHEN (advice LIKE ''%涂片%'' OR advice LIKE ''%细菌培养%'') THEN 1 ELSE 0 END) checkItem0,' +----送检但不一定用抗菌药
                   '      max(CASE WHEN (advice LIKE ''%涂片%'' OR advice LIKE ''%细菌培养%'') and M.antiClass=1 THEN 2 ELSE 0 END) checkItem1,' +--非限制
                   '      max(CASE WHEN (advice LIKE ''%涂片%'' OR advice LIKE ''%细菌培养%'') and M.antiClass=2 THEN 4 ELSE 0 END) checkItem2,' +--microbeLimit 微生物送检限制级
                   '      max(CASE WHEN (advice LIKE ''%涂片%'' OR advice LIKE ''%细菌培养%'') and M.antiClass=3 THEN 8 ELSE 0 END) checkItem3,' +--microbeSpec 微生物送检特殊级
                   '      max(CASE WHEN advice LIKE ''%药敏%'' THEN 16 ELSE 0 END) checkItem4 ' +
                   '   FROM (SELECT hospID, goodsID, adviceDate, advice FROM ' + @adviceItemTable1 +
                   '          UNION ALL ' +
                   '         SELECT hospID, goodsID, adviceDate, advice FROM  ' + @adviceItemTable2 + ' ) I ' +
                   '        LEFT JOIN Surgery S ON I.hospID = S.hospID ' +
                   '        LEFT JOIN Medicine M ON I.goodsID = M.goodsID' +
                   '   GROUP BY S.hospID) A ' +
                   'WHERE R.hospID = A.hospID AND (R.outDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + ''' ' +
                   '                               OR R.hospID in (select hospID from Surgery where operTime between ''' + @beginTime + ''' AND ''' + @nextDate + ''') )';
  -- OR outDate IS NULL
  --select @sqlString as 'sql5';
  exec (@sqlString);
  SELECT @updateRowCount = @updateRowCount + @@rowcount;
  --药品金额、抗菌药金额
  set @sqlString = 'UPDATE R SET R.medicineMoney = A.medicineMoney, R.antiMoney     = A.antiMoney FROM InPatient R,' +
                   '( SELECT hospID, sum(amount) medicineMoney, sum(CASE WHEN M.anticlass > 0 AND isStat = 1 THEN D.amount ELSE 0 END) antiMoney FROM (' +
                   'SELECT hospID, amount, goodsID FROM ' + @drugTable1 + ' WHERE adviceId>0 ' +
                   ' UNION ALL ' +
                   'SELECT hospID, amount, goodsID FROM ' + @drugTable2 + ' WHERE adviceId>0 ' +
                   ') D LEFT JOIN Medicine M on M.goodsID = D.goodsID
             group by hospID) A WHERE R.hospID = A.hospID AND R.outDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + '''';
  -- OR outDate IS NULL
  --select @sqlString as 'sql6';
  exec (@sqlString);
  SELECT @updateRowCount = @updateRowCount + @@rowcount;
  set @sqlString = 'UPDATE R SET R.antiNum = A.antiNum FROM InPatient R,' +
                   '(SELECT X.hospID, COUNT(DISTINCT X.goodsID) antiNum FROM ' +
                   '(SELECT hospID, goodsID,adviceDate,endDate FROM ' + @adviceItemTable1 +
                   ' UNION ALL ' +
                   ' SELECT hospID, goodsID,adviceDate,endDate FROM ' + @adviceItemTable2 +
                   ') X, Medicine M ' +
                   ' WHERE X.goodsID = M.goodsID AND M.antiClass > 0 AND M.isStat = 1 AND (X.endDate IS NULL OR DATEDIFF(HH, X.adviceDate, endDate) > 1)
                      GROUP BY X.hospID) A ' +
                   'WHERE R.hospID = A.hospID AND  R.outDate BETWEEN ''' + @beginTime + ''' AND ''' + @nextDate + '''';
  -- OR outDate IS NULL
  --select @sqlString as 'sql7';
  exec (@sqlString);
  SELECT @updateRowCount = @updateRowCount + @@rowcount;

  EXEC monitorUpdateTaskLog @logID, 'buildClinicInPatient', 'InPatient', -1, -1, -1, @updateRowCount, @startTime;
END;
go