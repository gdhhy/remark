ALTER  PROCEDURE [dbo].[ljMedicine](@logID INT)
  AS
  DECLARE
    @lastID INT,
    @insertRowCount INT,
    @deleteRowCount INT,
    @updateRowCount INT,
    @startTime DATETIME
  BEGIN
    SELECT @startTime = getdate();
    /*药品字典 Medicine*/
    CREATE TABLE #Medicine (
                             medicineID       INT PRIMARY KEY IDENTITY,
                             no               VARCHAR(20), --医院的编码
                             goodsID   int,
                             pinyin           VARCHAR(50),
                             healthNo         VARCHAR(20), --匹配通用名时自动选择，不可改变
                             chnName          VARCHAR(100),
                             engName          VARCHAR(100),
                             dose             VARCHAR(50), --匹配通用名时自动选择，可改变
                             spec             VARCHAR(100), --规格
                             price            DECIMAL(18, 4),
                             contents         DECIMAL(18, 4),
                             producer         VARCHAR(50), --生产厂家
                             insurance        TINYINT, --医保分类,0：非医保，1：甲类，2：乙类
                             packUnit         VARCHAR(20), --包装单位，瓶、盒、支
                             minUnit          VARCHAR(20), --最小单位,使用时
                             measureUnit      VARCHAR(20), --计量单位, 计算DDD值得含量，mg，ml等
                             minOfpack        INT, -- 包装转换比
                             matchDrugID      INT, --匹配通用名ID
                             matchInstrID     INT, --匹配的说明书ID
                             memo             TEXT, --备注
                             route            TINYINT, --1:口服, 2:注射, 3:大输液, 4:其他
                             orally           TINYINT,
                             antiClass        SMALLINT DEFAULT 0, --抗菌药级别，   1非限制，2限制，3特殊, todo -1:非抗菌药
                             ddd              DECIMAL(18, 4),
                             usageCounter     INT,
                             western          TINYINT DEFAULT 1,
                             base             TINYINT, --基本药物
                             dealer           VARCHAR(50),
                             lastPurchaseTime SMALLDATETIME,
                             mental           BIT,
                             maxContent       FLOAT,
                             maxDay           INT,
                             menstruum        INT, --//0无定义，1：盐水；2：糖水
                             isDelete         INT,
                             injection int,
                             json varchar(2000),
                             refID int
    );
    --主体数据
    insert into #Medicine(refID,no,goodsID,pinyin,ChnName,engName,spec,price,Western,contents,mental,antiClass,producer,injection,base,packUnit,minUnit,json)
    select A.id,A.code,A.code,A.pycode,A.Name,A.engdesc,A.spec,A.priceIn,
           case A.lsRpType when 1 then 3 when 2 then 1 when 3 then 4 end as western,
           A.LimitTotalMz,
           case when B.IsMental=1 then 1 when B.IsAnaes=1 then 4 end as mental, B.IsAntiBacterial,C.name producer, B.IsInject,
           case when IsSpecSum=1 then 3 when OptionPrice=1 then 2 end  as base,
           B.UnitKc,A.UnitTakeId,
           '{"批准文号":"'+B.passNo+'","药品来源":"'+
           case B.LsImport when 1 then '进口药' when 2 then '合资药' when 3 then  '国产药' else '不明' end +'"}' as json
           --,OptionPrice ,IsSpecSum
    from YBHis.YueBeiHis.dbo.BsItem A  left join YBHis.YueBeiHis.dbo.BsItemDrug  B ON A.ID=B.itemID
                                       left join YBHis.YueBeiHis.dbo.BsManufacturer C on B.manuID=C.ID
    where  A.lsGroupType=1 and  A.IsActive=1;
    --and A.id not in (select refID from Medicine);

    --包装单位、最小使用单位、DDD计算单位
    update A  set packUnit=B. Name
    FROM #Medicine A LEFT JOIN  YBHis.YueBeiHis.dbo.BsUnit  B ON A.packUnit = B.ID;
    update A  set minUnit=B. Name
    FROM #Medicine A LEFT JOIN  YBHis.YueBeiHis.dbo.BsUnit  B ON A.minUnit = B.ID;
    update #Medicine set measureUnit=minUnit where minUnit like '%g' or minUnit like '%l'  or minUnit ='克';
    --最后采购时间、经销商
    update A  set lastPurchaseTime=C.OperTime,dealer=D.Name
    FROM #Medicine A LEFT JOIN  YBHis.YueBeiHis.dbo.HuStockDtl  B  ON A.refID = B.ItemID
                     left join  YBHis.YueBeiHis.dbo.HuStock C on B.BillID=C.ID
                     left join YBHis.YueBeiHis.dbo.BsCompany D on C.CompId=D.ID;

    -- 新增部分
    INSERT INTO  Medicine (updateTime, refID,no,goodsID,pinyin,ChnName,engName,spec,price,western,contents,mental,antiClass,producer,injection,base,packUnit,minUnit,json, lastPurchaseTime)
    SELECT getdate(),refID,no,goodsID,pinyin,ChnName,engName,spec,price,Western,contents,mental,antiClass,producer,injection,base,packUnit,minUnit,json, lastPurchaseTime
    FROM #Medicine WHERE refID NOT IN (SELECT refID FROM Medicine);
    SELECT @insertRowCount = @@rowcount;
    --select 'insert:'+convert(varchar(2),@insertRowCount);
    -- remove update base & healthNo
    UPDATE A SET A.no=B.no, A.goodsID=B.goodsID, A.pinyin=B.pinyin, A.chnName = B.chnName, A.engName = B.engName,  A.spec = B.spec, A.price = B.price,
                 A.western = B.western, A.contents = B.contents,  A.mental = B.mental, A.antiClass = B.antiClass, A.producer = B.producer, A.injection = B.injection,
                 A.base = B.base,	A.packUnit = B.packUnit, A.minUnit  = B.minUnit, A.json = B.json,
                 A.dealer = B.dealer, A.lastPurchaseTime = B.lastPurchaseTime,  A.updateUser=null, A. UpdateTime  = GetDate()
    FROM  Medicine A, #Medicine B
    WHERE A.refID = B.refID
      AND ((A.no!=B.no) OR (A.goodsID!=B.goodsID) OR (A.pinyin!=B.pinyin) OR ( A.chnName != B.chnName) OR ( A.engName != B.engName) OR (  A.spec != B.spec) OR ( A.price != B.price) OR
           (A.western != B.western) OR (A.contents != B.contents) OR (  A.mental != B.mental) OR ( A.antiClass != B.antiClass) OR ( A.producer != B.producer) OR ( A.injection != B.injection) OR
           (A.base != B.base) OR (	A.packUnit != B.packUnit) OR ( A.minUnit  != B.minUnit) OR ( A.json != B.json) OR ( A.dealer != B.dealer) OR ( A.lastPurchaseTime != B.lastPurchaseTime));
    SELECT @updateRowCount = @@rowcount;
    -- SELECT 'update:'+convert(varchar(2),@updateRowCount);

    -- 删除
    UPDATE Medicine SET IsDelete = 1, UpdateTime = GetDate() WHERE refID NOT IN (SELECT refID FROM #Medicine);
    SELECT @deleteRowCount = @@rowcount;

    DROP TABLE #Medicine;
    IF (@logID > 0)
      BEGIN
        SELECT @lastID = CASE WHEN max(medicineID) IS NULL THEN 0 ELSE max(medicineID) END FROM  Medicine;
        EXEC  monitorUpdateTaskLog @logID, 'ljMedicine', 'Medicine', @lastID, @deleteRowCount, @insertRowCount, @updateRowCount, @startTime;
      END;
  END;