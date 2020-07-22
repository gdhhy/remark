CREATE PROCEDURE [dbo].[ljMedicine](@logID INT)
AS
DECLARE
  @lastID         INT,
  @insertRowCount INT,
  @deleteRowCount INT,
  @updateRowCount INT,
  @startTime      DATETIME
BEGIN
  SELECT @startTime = getdate();
  /*药品字典 Medicine*/
  CREATE TABLE #Medicine
  (
    medicineID       INT PRIMARY KEY IDENTITY,
    no               VARCHAR(20),        --医院的编码
    ypID             varchar(50),
    goodsID          int,
    pinyin           VARCHAR(50),
    healthNo         VARCHAR(20),        --匹配通用名时自动选择，不可改变
    chnName          VARCHAR(100),
    engName          VARCHAR(100),
    dose             VARCHAR(50),        --匹配通用名时自动选择，可改变
    spec             VARCHAR(100),       --规格
    price            DECIMAL(18, 4),
    contents         DECIMAL(18, 4),
    producer         VARCHAR(50),        --生产厂家
    insurance        TINYINT,            --医保分类,0：非医保，1：甲类，2：乙类
    packUnit         VARCHAR(20),        --包装单位，瓶、盒、支
    minUnit          VARCHAR(20),        --最小单位,使用时
    measureUnit      VARCHAR(20),        --计量单位, 计算DDD值得含量，mg，ml等，（力锦：改为门诊单位）
    clinicUnit       VARCHAR(20),        --门诊单位
    minOfpack        INT,                -- 包装转换比
    matchDrugID      INT,                --匹配通用名ID
    matchInstrID     INT,                --匹配的说明书ID
    memo             TEXT,               --备注
    route            TINYINT,            -- 1	口服，  2	注射，  3	大输液，  4	外用，  5	材料，  6	其他
    orally           TINYINT,
    antiClass        SMALLINT DEFAULT 0, --抗菌药级别，   1非限制，2限制，3特殊, todo -1:非抗菌药
    ddd              DECIMAL(18, 4),
    usageCounter     INT,
    western          TINYINT  DEFAULT 1,
    base             TINYINT,            --基本药物
    dealer           VARCHAR(50),
    lastPurchaseTime SMALLDATETIME,
    mental           BIT,
    maxContent       FLOAT,
    maxDay           INT,
    menstruum        INT,                --//0无定义，1：盐水；2：糖水
    isDelete         INT,
    injection        int,
    authCode         varchar(100),
    json             varchar(2000)
  );
  --主体数据
  insert into #Medicine(goodsID, ypID, no, pinyin, ChnName, engName, dose, spec, price, Western, contents, mental,
                        antiClass, producer, injection, base, packUnit, minUnit, clinicUnit, authCode, json, insurance)
  select A.id, B.YbIdCode, A.code, A.pycode, A.Name, A.engdesc, E.name, A.spec, A.priceIn,
         case A.lsRpType when 1 then 3 when 2 then 1 when 3 then 4 end                               as western,
         --A.lsRpType,--处方项目：1-中成药；2-西药；3-中药；4-检验；5-检查；6-手术；7-治疗；8-床位；9-其他；10
         --OuRecipeTemp.LsRepType 1-西药，2：中药u
         A.LimitTotalMz,
         case when B.IsMental = 1 then 1 when B.IsSecMental = 2 then 1 when B.IsAnaes = 1 then 4 end as mental,
         B.IsAntiBacterial, C.name                                                                      producer, B.IsInject,
         case when IsSpecSum = 1 then 3 when OptionPrice = 1 then 2 else 0 end                       as base,--省基3，国基2
         B.UnitKc, A.UnitTakeId, A.UnitDiagId, B.passNo,
         '{"批准文号":"' + B.passNo + '","药品来源":"' +
         case B.LsImport when 1 then '进口药' when 2 then '合资药' when 3 then '国产药' else '不明' end + '"}'  as json,
         D.LsYbType
  from YBHis.LJHis.dbo.BsItem A
         left join YBHis.LJHis.dbo.BsItemDrug B ON A.ID = B.itemID
         left join YBHis.LJHis.dbo.BsManufacturer C on B.manuID = C.ID
         left join (select itemID, min(LsYbType) LsYbType from YBHis.LJHis.dbo.BsItemYb group by itemID) D on A.ID = D.itemID
         left join YBHis.LJHis.dbo.BsDrugForm E on B.FormId = E.ID
  where A.lsGroupType = 1
    and A.IsActive = 1;
  --and A.id not in (select refID from Medicine);
  --包装单位、最小使用单位、DDD计算单位
  /*update A
  set minOfpack=B.DrugRatio
  FROM #Medicine A
         LEFT JOIN YBHis.LJHis.dbo.BsUnitRatio B ON A.goodsID = B.itemID and A.packUnit = B.UnitId1 and A.minUnit = B.unitID2;
*/
  update A
  set packUnit=B.Name
  FROM #Medicine A
         LEFT JOIN YBHis.LJHis.dbo.BsUnit B ON A.packUnit = B.ID;

  update A
  set minUnit=B.Name
  FROM #Medicine A
         LEFT JOIN YBHis.LJHis.dbo.BsUnit B ON A.minUnit = B.ID;
  update A
  set clinicUnit=B.Name
  FROM #Medicine A
         LEFT JOIN YBHis.LJHis.dbo.BsUnit B ON A.clinicUnit = B.ID;

  update #Medicine set measureUnit=minUnit where minUnit like '%g' or minUnit like '%l' or minUnit = '克';
  --最后采购时间、经销商
  update A
  set lastPurchaseTime=C.OperTime,
      dealer=D.Name
  FROM #Medicine A
         LEFT JOIN YBHis.LJHis.dbo.HuStockDtl B ON A.goodsID = B.ItemID
         left join YBHis.LJHis.dbo.HuStock C on B.BillID = C.ID
         left join YBHis.LJHis.dbo.BsCompany D on C.CompId = D.ID;

  -- 新增部分
  INSERT INTO Medicine (updateTime, ypID, goodsID, no, pinyin, ChnName, engName, dose, spec, price, western, contents, mental, antiClass, producer, injection,
                        base, packUnit, minUnit, clinicUnit, authCode, json, lastPurchaseTime)
  SELECT getdate(), ypID, goodsID, no, pinyin, ChnName, engName, dose, spec, price, Western, contents, mental, antiClass, producer, injection,
         base, packUnit, minUnit, clinicUnit, authCode, json, lastPurchaseTime
  FROM #Medicine
  WHERE goodsID NOT IN (SELECT goodsID FROM Medicine);
  SELECT @insertRowCount = @@rowcount;
  --select 'insert:'+convert(varchar(2),@insertRowCount);
  -- remove update base & healthNo
  UPDATE A
  SET A.no=B.no,
      A.ypID=B.ypID,
      A.goodsID=B.goodsID,
      A.pinyin=B.pinyin,
      A.chnName = B.chnName,
      A.engName = B.engName,
      A.dose = B.dose,
      A.spec = B.spec,
      A.price = B.price,
      A.western = B.western,
      --A.contents = B.contents,
      A.mental = B.mental,
      --A.antiClass = B.antiClass,
      -- A.producer = B.producer,
      --A.injection = B.injection,
      --A.base = B.base,
      A.packUnit = B.packUnit,
      A.minUnit = B.minUnit,
      A.clinicUnit = B.clinicUnit,
      A.minOfpack = B.minOfpack,
      A.authCode = B.authCode,
      A.json = B.json,
      --A.dealer = B.dealer,
      A.lastPurchaseTime = B.lastPurchaseTime
      --A.insurance= B.insurance,
      --A.updateUser= null
    /*,
    A.UpdateTime = GetDate()*/
  FROM Medicine A,
       #Medicine B
  WHERE A.goodsID = B.goodsID
  /*AND ((A.no != B.no)   OR (A.pinyin != B.pinyin) OR (A.chnName != B.chnName) OR (A.engName != B.engName) OR (A.dose != B.dose) OR (A.spec != B.spec) OR
       (A.price != B.price) OR (A.western != B.western) OR (A.contents != B.contents) OR (A.mental != B.mental) OR (A.antiClass != B.antiClass) OR (A.producer != B.producer) OR
       (A.injection != B.injection) OR (A.base != B.base) OR (A.packUnit != B.packUnit) OR (A.minUnit != B.minUnit) OR (A.minOfpack != B.minOfpack) OR (A.json != B.json) OR
       (A.dealer != B.dealer) OR (A.insurance != B.insurance) OR (A.lastPurchaseTime != B.lastPurchaseTime))*/;
  SELECT @updateRowCount = @@rowcount;
  /*update A
  set A.dealer=B.dealer,
      A.producer=B.producer,
      A.matchDrugID=B.matchDrugID,
      A.matchDrugNo=B.matchDrugNo,
      A.matchInstrID=B.matchInstrID,
      A.matchInstrNo=B.matchInstrNo,
      A.injection = B.injection,
      A.contents = B.contents,
      A.healthNo=B.healthNo,
      A.ddd=B.ddd,
      A.base=B.base,
      A.antiClass=B.antiClass,
      A.route=B.route
  from Medicine A, reviewDb.review.dbo.Medicine B
  where A.no=B.no*/
  -- SELECT 'update:'+convert(varchar(2),@updateRowCount);
  --按剂型更新给药途径
  /*  update M
    set route =D.value
    from Medicine M,
         Dict D
    where M.dose = D.name and D.parentID = 2 and M.route is null;*/

  -- 删除
  UPDATE Medicine SET IsDelete = 1, UpdateTime = GetDate() WHERE goodsID NOT IN (SELECT goodsID FROM #Medicine);
  SELECT @deleteRowCount = @@rowcount;
  DROP TABLE #Medicine;

  /*--根据批准文号，自动匹配药品，更新说明书*/
  update A
  set matchInstrID =B.instructionID,
      matchDrugID=C.drugID,
      antiClass=D.antiClass,
      healthNo=D.healthNo,
      ddd=D.ddd
  from medicine A
         left join Instruction B on A.authCode = B.authCode
         left join (SELECT instructionID, max(drugID) drugID FROM DrugDose group by instructionID) C on B.instructionID = C.instructionID
         left join Drug D on D.drugID = C.drugID
  where B.authCode != '' and (A.matchInstrID is null or A.matchDrugID is null);

  IF (@logID > 0)
    BEGIN
      SELECT @lastID = CASE WHEN max(medicineID) IS NULL THEN 0 ELSE max(medicineID) END FROM Medicine;
      EXEC monitorUpdateTaskLog @logID, 'ljMedicine', 'Medicine', @lastID, @deleteRowCount, @insertRowCount, @updateRowCount, @startTime;
    END;
END;
go

