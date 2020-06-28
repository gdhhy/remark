-- 不良反应报告
CREATE TABLE Untoward (
  untowardID        INT PRIMARY KEY IDENTITY,
  objectID          INT UNIQUE, --执行clinicID或inPatientID
  objectType        TINYINT, --1门诊，2：住院
  untowardNo        VARCHAR(50),
  untowardType      INT, --头部选项（首次报告、报告类型等）
  department        VARCHAR(20), --报告科室
  departPhone       VARCHAR(20), --报告科室电话
  patientName       VARCHAR(50),
  boy               INT,
  nation            VARCHAR(10), --民族
  weight            VARCHAR(10), --体重
  patientLink       VARCHAR(100),
  disease           VARCHAR(511), --疾病
  historyUntoward   INT, --既往、家族：有、无、不详
  historyEvent      VARCHAR(50),
  familyEvent       VARCHAR(50),
  important         INT,
  allergicHistory   VARCHAR(50),
  otherInfo         VARCHAR(50),
  eventName         VARCHAR(50),
  eventTime         VARCHAR(20),
  eventHour         VARCHAR(10),
  eventDesc         VARCHAR(1023),
  eventResult       INT,
  sequela           VARCHAR(50), --后遗症
  deadCause         VARCHAR(50),
  deadTime          VARCHAR(10),
  deadHour          VARCHAR(10),
  stopRetry         INT, --停药或减量、再次使用
  diseaseEffect     INT, --对原患疾病的影响
  relevance         INT,
  relevanceSign1    VARCHAR(20),
  relevanceSign2    VARCHAR(20),
  declarerPhone     VARCHAR(20), --报告人电话
  declarerType      TINYINT,
  declarerDepart    VARCHAR(20),
  declarerTitle     VARCHAR(20),
  declarerEmail     VARCHAR(50),
  declarerSign      VARCHAR(50),
  declarerUserID    INT,
  declarerLink      VARCHAR(50), --联系人
  declarerLinkPhone VARCHAR(50), --联系人电话
  declareDate       SMALLDATETIME   DEFAULT getdate(),
  doubtDrugJson     VARCHAR(2047),
  parallelDrugJson  VARCHAR(2047),
  course1           VARCHAR(10),
  course2           VARCHAR(10),
  course3           VARCHAR(20),
  course4           VARCHAR(255),
  course5           VARCHAR(255),
  course6           VARCHAR(255),
  course7           VARCHAR(100),
  course8           VARCHAR(255),
  course9           VARCHAR(255),
  course10          VARCHAR(255),
  courseInt         INT,
  memo              VARCHAR(255)
);
ALTER TABLE untoward ADD department VARCHAR(20);
ALTER TABLE untoward ADD eventHour VARCHAR(10);
--废掉 it ！todo
CREATE TABLE UntowardDrug (
  untowardDrugID INT PRIMARY KEY IDENTITY,
  untowardID     INT REFERENCES untoward,
  objectID       INT,
  permitNo       VARCHAR(50),
  medicineNo     VARCHAR(50),
  doubtParallel  TINYINT, --怀疑药品0，并行药品1
  goodsName      VARCHAR(50), --商品名
  generalName    VARCHAR(50), --通用名
  producer       VARCHAR(100),
  produceBatch   VARCHAR(50),
  usage          VARCHAR(100), --用法用量
  startStopTime  VARCHAR(50), --起止时间
  purpose        VARCHAR(20), --用药目的
);

ALTER TABLE clinic ADD appealState INT DEFAULT 0;
ALTER TABLE InPatient ADD appealState INT DEFAULT 0;


alter table Untoward add workflow int;
alter table Untoward add workflowNote varchar(255);