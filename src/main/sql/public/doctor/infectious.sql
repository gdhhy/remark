--传染病报告卡
DROP TABLE Infectious;
CREATE TABLE Infectious (
  infectiousID    INT           IDENTITY PRIMARY KEY,
  objectID        INTEGER, --执行clinicID或recipeID
  objectType      INTEGER, --1门诊，2：住院
  reportNo        VARCHAR(30),
  reportType      INT, --1:初次报告，2:订正报告
  patientName     VARCHAR(20), --姓名
  patientParent   VARCHAR(20), --患儿家长姓名
  idCardNo        VARCHAR(20),
  boy             int, --性别，男1，女：2
  birthday        VARCHAR(20), --出生日期
  age             VARCHAR(10), --多少岁、月、天
  ageUnit         VARCHAR(5), --岁、月、天
  workplace       VARCHAR(255), --工作单位
  linkPhone       VARCHAR(50), --联系电话
  belongTo        VARCHAR(20), --病人属于
  address         VARCHAR(255), --现在住址
  occupation      VARCHAR(20), --职业
  occupationElse  VARCHAR(20)   DEFAULT '', --职业(其它）
  caseClass       INT,
  accidentDate    VARCHAR(10), --发病日期
  diagnosisDate   VARCHAR(15), --诊断日期
--  diagnosisHour   VARCHAR(10), --诊断时间，小时
  deathDate       VARCHAR(10), --死亡日期
  infectiousClass INT, --0-3:甲乙丙，其它
  infectiousName  VARCHAR(100),
  correctName     VARCHAR(50), --订正病名
  cancelCause     VARCHAR(50), --退卡原因
  reportUnit      VARCHAR(50), --报告单位
  doctorPhone     VARCHAR(50),
  reportDoctor    VARCHAR(50),
  doctorUserID    INT,
  fillDate        VARCHAR(10),
  memo            VARCHAR(1023),
  workflow        INT,
  fillTime        SMALLDATETIME DEFAULT getdate()--填写时间
)
--感染病报告卡
DROP TABLE Contagion;
CREATE TABLE Contagion (
  contagionID     INT           IDENTITY PRIMARY KEY,
  objectID        INTEGER, --执行clinicID或recipeID
  objectType      INTEGER, --1门诊，2：住院
  department      VARCHAR(20),
  patientName     VARCHAR(20), --姓名
  idNo            VARCHAR(20),
  boy             INT, --性别，男1，女：2
  age             VARCHAR(20),
  inDate          VARCHAR(20), --入院日期
  hospitalDay     INT, --住院天数
  baseDiagnosis1  VARCHAR(50),
  baseDiagnosis2  VARCHAR(50),
  baseDiagnosis3  VARCHAR(50),
  baseDiagnosis4  VARCHAR(50),
  hospitalInfect1 VARCHAR(50),
  occurDay1       INT,
  hospitalInfect2 VARCHAR(50),
  occurDay2       INT,
  factor          VARCHAR(100), --易感因素
  surgeryName     VARCHAR(50), --手术名称
  emergency       INT, --急诊
  surgeryDate     VARCHAR(10),
  surgeryDoctor   VARCHAR(20), --术者
  lastTime1        varchar(10), --持续时间
  lastTime2        varchar(10), --持续时间
  anaesthesia     INT, --麻醉方式
  cut             INT, --伤口类型
  feature         INT,
  time1           VARCHAR(20),
  time2           VARCHAR(20),
  time3           VARCHAR(20),
  drainage        VARCHAR(50), --引流管部位
  hormone         VARCHAR(100), --激素
  time4           VARCHAR(20),
  time5           VARCHAR(20),
  microbe         VARCHAR(255), --微生物送检
  sample          VARCHAR(1023), --样本名称
  bAntiDrug       VARCHAR(1023), --发生感染前
  aAntiDrug       VARCHAR(1023), --发生感染后
  pAntiDrug       VARCHAR(1023), --局部抗菌药
  antiItem        INT,
  masterDoctor    VARCHAR(20),
  monitorDoctor   VARCHAR(20),
  doctorUserID    INT,
  workflow        INT,
  reportTime      SMALLDATETIME DEFAULT getdate()
)

alter table infectious add serialNo varchar(20);
alter table Contagion add serialNo varchar(20);
ALTER TABLE infectious DROP COLUMN OBJECTid;
ALTER TABLE Contagion DROP COLUMN OBJECTid;

alter table infectious add marital varchar(20);
alter table infectious add nation varchar(20);
alter table infectious add nationElse varchar(20);
alter table infectious add education varchar(20);
alter table infectious add venerismHis varchar(20);
alter table infectious add registerAddr varchar(255);
alter table infectious add touchHis int;
alter table infectious add touchElse varchar(100);
alter table infectious add infectRoute varchar(20);
alter table infectious add sampleSource varchar(100);
alter table infectious add conclusion varchar(100);
alter table infectious add checkConfirmDate varchar(10);
alter table infectious add hivConfirmDate varchar(10);
alter table infectious add checkUnit varchar(100);