
set identity_insert et_drug on;
insert into Drug
select *   from reviewDb.review.dbo.drug;

set identity_insert Et_DrugDose on;
insert into DrugDose ( drugDoseID,drugID,route,dose,InstructionID,InstructionName)
select  drugDoseID,drugID,route,dose,InstructionID,InstructionName  from reviewDb.review.dbo.DrugDose;


set identity_insert et_Dict off;
insert into Dict
select * from reviewDb.rbac.dbo.Dict;

set identity_insert et_instruction on;
insert into  instruction
select *   from reviewDb.review.dbo. Instruction ;

truncate table Et_DrugDose;
delete et_Drug;
truncate table et_Dict;
truncate table et_instruction;