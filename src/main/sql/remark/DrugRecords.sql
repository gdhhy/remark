CREATE TABLE [dbo].[his_lyd]
(
    [lyd_id]     int                                   NOT NULL,
    [lydno]      int                                   NOT NULL,
    [yf]         varchar(20) COLLATE Chinese_PRC_CI_AS NULL,
    [fyrq]       datetime                              NOT NULL,
    [brxm]       varchar(30) COLLATE Chinese_PRC_CI_AS NULL,
    [fyid]       varchar(20) COLLATE Chinese_PRC_CI_AS NULL,
    [fph]        varchar(20) COLLATE Chinese_PRC_CI_AS NULL,
    [ks]         varchar(20) COLLATE Chinese_PRC_CI_AS NULL,
    [dAge]       float(53)                             NULL,
    [clinicType] varchar(10) COLLATE Chinese_PRC_CI_AS NULL,
    [valid]      int                                   NULL
)
    ON [PRIMARY]
GO

ALTER TABLE [dbo].[his_lyd]
    SET (LOCK_ESCALATION = TABLE)

CREATE TABLE [dbo].[his_lydmx]
(
    [lydmx_id] int                                   NOT NULL,
    [lydno]    int                                   NOT NULL,
    [fyypid]   int                                   NOT NULL,
    [ypbm]     varchar(11) COLLATE Chinese_PRC_CI_AS NULL,
    [dw]       varchar(10) COLLATE Chinese_PRC_CI_AS NULL,
    [gg]       varchar(30) COLLATE Chinese_PRC_CI_AS NULL,
    [fysl]     numeric(15, 4)                        NOT NULL,
    [ypdj]     decimal(12, 4)                        NULL,
    [fyje]     numeric(15, 4)                        NOT NULL,
    [ys]       varchar(30) COLLATE Chinese_PRC_CI_AS NULL,
    [yztype]   varchar(30) COLLATE Chinese_PRC_CI_AS NULL
)
    ON [PRIMARY]
GO

ALTER TABLE [dbo].[his_lydmx]
    SET (LOCK_ESCALATION = TABLE)

create table DrugRecords(
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


SELECT top 0 * INTO DrugRecords_2019 FROM DrugRecords_2014;

INSERT INTO  DrugRecords (drID,recordID,drugstore,dispensingDate,patientName,dispensingNo,invoiceNo,department,age,
                          clinicType,goodsID,goodsNo,unit,spec,quantity,price,amount,doctorName,adviceType,valid)
select   A.lydmx_id,A.lydno,B.yf,B.fyrq,B.brxm,B.fyid,B.fph,B.ks,B.dAge,B.clinicType,A.fyypid,A.ypbm,A.dw,A.gg,A.fysl,A.ypdj,
         A.fyje,A.ys,A.yztype,B.valid
from his_lydmx A   join his_lyd B on A.lydno=B.lydno;

INSERT INTO  DrugRecords (drID,recordID,drugstore,dispensingDate,patientName,dispensingNo,invoiceNo,department,age,
                          clinicType,goodsID,goodsNo,unit,spec,quantity,price,amount,doctorName,adviceType,valid)
select   A.lydmx_id,A.lydno,B.yf,B.fyrq,B.brxm,B.fyid,B.fph,B.ks,B.dAge,B.clinicType,A.fyypid,A.ypbm,A.dw,A.gg,A.fysl,A.ypdj,
         A.fyje,A.ys,A.yztype,B.valid
from his_lydmx_2013 A   join his_lyd_2013 B on A.lydno=B.lydno;
INSERT INTO  DrugRecords (drID,recordID,drugstore,dispensingDate,patientName,dispensingNo,invoiceNo,department,age,
                          clinicType,goodsID,goodsNo,unit,spec,quantity,price,amount,doctorName,adviceType,valid)
select   A.lydmx_id,A.lydno,B.yf,B.fyrq,B.brxm,B.fyid,B.fph,B.ks,B.dAge,B.clinicType,A.fyypid,A.ypbm,A.dw,A.gg,A.fysl,A.ypdj,
         A.fyje,A.ys,A.yztype,B.valid
from his_lydmx_2014 A   join his_lyd_2014 B on A.lydno=B.lydno;
INSERT INTO  DrugRecords (drID,recordID,drugstore,dispensingDate,patientName,dispensingNo,invoiceNo,department,age,
                          clinicType,goodsID,goodsNo,unit,spec,quantity,price,amount,doctorName,adviceType,valid)
select   A.lydmx_id,A.lydno,B.yf,B.fyrq,B.brxm,B.fyid,B.fph,B.ks,B.dAge,B.clinicType,A.fyypid,A.ypbm,A.dw,A.gg,A.fysl,A.ypdj,
         A.fyje,A.ys,A.yztype,B.valid
from his_lydmx_2017 A   join his_lyd_2017 B on A.lydno=B.lydno;

