exec sp_copy_table 'AdviceItem', 'AdviceItem_2017';
exec sp_copy_index 'AdviceItem', 'AdviceItem_2017';
exec sp_copy_table 'AdviceItem', 'AdviceItem_2018';
exec sp_copy_index 'AdviceItem', 'AdviceItem_2018';

insert into AdviceItem_2017 (adviceItemID, hospID, longAdvice, adviceDate, inPatient, medicineNo, doctorName, nurseName, endDate, endDoctorName,
                             endNurseName, quantity, unit, adviceType, orderID, groupID, problemCode, problemDesc)
SELECT *
FROM AdviceItem
where hospID in (select hospID from InPatient where outdate > '2017-01-01' and outDate < '2018-01-01');
insert into AdviceItem_2018 (adviceItemID, hospID, longAdvice, adviceDate, inPatient, medicineNo, doctorName, nurseName, endDate, endDoctorName,
                             endNurseName, quantity, unit, adviceType, orderID, groupID, problemCode, problemDesc)
SELECT *
FROM AdviceItem
where hospID in (select hospID from InPatient where outdate > '2018-01-01' and outDate < '2019-01-01');

truncate  table  AdviceItem_2019;
insert into AdviceItem_2019 (adviceItemID, hospID, longAdvice, adviceDate, inPatient, medicineNo, doctorName, nurseName, endDate, endDoctorName,
                             endNurseName, quantity, unit, adviceType, orderID, groupID, problemCode, problemDesc)
SELECT *
FROM AdviceItem
where hospID in (select hospID from InPatient where outdate > '2019-01-01' or outdate is null);


exec sp_copy_table 'RxDetail', 'RxDetail_2018';
exec sp_copy_index 'RxDetail', 'RxDetail_2018';
insert into RxDetail_2018
SELECT *
FROM RxDetail
where prescribeDate > '2018-01-01'
  and prescribeDate < '2019-01-01';
truncate  table  RxDetail_2019;
insert into RxDetail_2019
SELECT *
FROM RxDetail
where prescribeDate > '2019-01-01';

exec sp_copy_table 'DrugRecord_2015', 'DrugRecord_2018';
exec sp_copy_index 'DrugRecord_2015', 'DrugRecord_2018';
----------
INSERT INTO  DrugRecords_2018 (drID,recordID,drugstore,dispensingDate,patientName,dispensingNo,invoiceNo,department,age,
                               clinicType,goodsID,goodsNo,unit,spec,quantity,price,amount,doctorName,adviceType,valid)
select   A.lydmx_id,A.lydno,B.yf,B.fyrq,B.brxm,B.fyid,B.fph,B.ks,B.dAge,B.clinicType,A.fyypid,A.ypbm,A.dw,A.gg,A.fysl,A.ypdj,
         A.fyje,A.ys,A.yztype,B.valid
from his_lydmx_2018 A   join his_lyd_2018 B on A.lydno=B.lydno;

truncate  table DrugRecord_2019;
INSERT INTO  DrugRecords_2019 (drID,recordID,drugstore,dispensingDate,patientName,dispensingNo,invoiceNo,department,age,
                               clinicType,goodsID,goodsNo,unit,spec,quantity,price,amount,doctorName,adviceType,valid)
select   A.lydmx_id,A.lydno,B.yf,B.fyrq,B.brxm,B.fyid,B.fph,B.ks,B.dAge,B.clinicType,A.fyypid,A.ypbm,A.dw,A.gg,A.fysl,A.ypdj,
         A.fyje,A.ys,A.yztype,B.valid
from his_lydmx A   join his_lyd B on A.lydno=B.lydno;
