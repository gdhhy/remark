
create table DrugRecords_2015(
                                 drID int   ,--lydmx_id
                                 recordID int ,--lydno
                                 drugstore varchar(20),--药房
                                 dispensingDate datetime ,--发药日期
                                 patientName varchar(30),--病人姓名
                                 dispensingNo varchar(20),--发药ID fyid
                                 invoiceNo varchar(20),--发票号
                                 department varchar(20),--科室
                                 age float,
                                 clinicType varchar(10),--门诊类型：急诊、儿科、麻、精一
                                 goodsID int ,--fyypid
                                 goodsNo varchar(11) ,--ypbm
                                 unit varchar(10),
                                 spec varchar(30),
                                 quantity numeric(15,4),--fysl
                                 price decimal(15,2),
                                 amount numeric(15,4),
                                 doctorName varchar(30),--
                                 adviceType varchar(30),--静滴、肌注静注
                                 valid tinyint
);

--药品分析（天）
CREATE NONCLUSTERED INDEX  DrugRecords_2015_dispensingDate
    ON [dbo].[DrugRecords_2015] ([dispensingDate])
    INCLUDE ([dispensingNo],[invoiceNo],[goodsID],[quantity],[amount]);

CREATE NONCLUSTERED INDEX  DrugRecords_2015_dispensingDate2
    ON [dbo].[DrugRecords_2015] ([dispensingDate])
    INCLUDE ([dispensingNo],[invoiceNo],[department],[goodsID],[quantity],[amount]);
--抗菌药品种统计
CREATE NONCLUSTERED INDEX  DrugRecords_goodsNo
    ON [dbo].[DrugRecords_2015] ([goodsNo])
    INCLUDE ([dispensingDate],[dispensingNo],[invoiceNo],[quantity],[amount],[adviceType])
--用药概况
CREATE NONCLUSTERED INDEX DrugRecords_2015_dispensingDate3
    ON [dbo].[DrugRecords_2015] ([dispensingDate])
    INCLUDE ([dispensingNo],[goodsNo],[adviceType]);

CREATE NONCLUSTERED INDEX RecipeItem_serialNo
    ON [dbo].[RecipeItem] ([serialNo])
    INCLUDE ([medicineNo]);
CREATE NONCLUSTERED INDEX  Recipe_outDate
    ON [dbo].[Recipe] ([outDate])
    INCLUDE ([serialNo]);

CREATE NONCLUSTERED INDEX  IX_RxDetail_PrescribeDate2
    ON [dbo].[RxDetail] ([prescribeDate])
    INCLUDE ([serialNo],[dosage]);


CREATE NONCLUSTERED INDEX  IX_RxDetail_PrescribeDate3
    ON [dbo].[RxDetail] ([prescribeDate])
    INCLUDE ([serialNo],[medicineNo]);

CREATE NONCLUSTERED INDEX IX_RxDetail_medicineNo_PrescribeDate3
    ON [dbo].[RxDetail] ([medicineNo],[prescribeDate])
    INCLUDE ([serialNo]);


CREATE NONCLUSTERED INDEX IX_Rx_clinicType_prescribeDate
    ON [dbo].[Rx] ([clinicType],[prescribeDate])
    INCLUDE ([serialNo]);

INSERT INTO  DrugRecords_2015 (drID,recordID,drugstore,dispensingDate,patientName,dispensingNo,invoiceNo,department,age,
                               clinicType,goodsID,goodsNo,unit,spec,quantity,price,amount,doctorName,adviceType,valid)
select   A.lydmx_id,A.lydno,B.yf,B.fyrq,B.brxm,B.fyid,B.fph,B.ks,B.dAge,B.clinicType,A.fyypid,A.ypbm,A.dw,A.gg,A.fysl,A.ypdj,
         A.fyje,A.ys,A.yztype,B.valid
from his_lydmx A   join his_lyd B on A.lydno=B.lydno where B.fyrq>'2015-01-01' and B.fyrq<'2016-01-01'

INSERT INTO  DrugRecords_2013 (drID,recordID,drugstore,dispensingDate,patientName,dispensingNo,invoiceNo,department,age,
                               clinicType,goodsID,goodsNo,unit,spec,quantity,price,amount,doctorName,adviceType,valid)
select   A.lydmx_id,A.lydno,B.yf,B.fyrq,B.brxm,B.fyid,B.fph,B.ks,B.dAge,B.clinicType,A.fyypid,A.ypbm,A.dw,A.gg,A.fysl,A.ypdj,
         A.fyje,A.ys,A.yztype,B.valid
from his_lydmx_2013 A   join his_lyd_2013 B on A.lydno=B.lydno;
INSERT INTO  DrugRecords_2014 (drID,recordID,drugstore,dispensingDate,patientName,dispensingNo,invoiceNo,department,age,
                               clinicType,goodsID,goodsNo,unit,spec,quantity,price,amount,doctorName,adviceType,valid)
select   A.lydmx_id,A.lydno,B.yf,B.fyrq,B.brxm,B.fyid,B.fph,B.ks,B.dAge,B.clinicType,A.fyypid,A.ypbm,A.dw,A.gg,A.fysl,A.ypdj,
         A.fyje,A.ys,A.yztype,B.valid
from his_lydmx_2014 A   join his_lyd_2014 B on A.lydno=B.lydno;
INSERT INTO  DrugRecords_2017 (drID,recordID,drugstore,dispensingDate,patientName,dispensingNo,invoiceNo,department,age,
                               clinicType,goodsID,goodsNo,unit,spec,quantity,price,amount,doctorName,adviceType,valid)
select   A.lydmx_id,A.lydno,B.yf,B.fyrq,B.brxm,B.fyid,B.fph,B.ks,B.dAge,B.clinicType,A.fyypid,A.ypbm,A.dw,A.gg,A.fysl,A.ypdj,
         A.fyje,A.ys,A.yztype,B.valid
from his_lydmx_2017 A   join his_lyd_2017 B on A.lydno=B.lydno;

