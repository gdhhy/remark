-- select top 0 * Into Doctor from wy_review_160222.dbo.Doctor;
CREATE PROCEDURE [dbo].[ljDoctor](@logID INT)
AS
DECLARE
  @lastID         INT,
  @insertRowCount INT,
  @deleteRowCount INT,
  @updateRowCount INT,
  @startTime      DATETIME,
  @timeSpent      INT
begin
  SELECT @startTime = getdate();
  CREATE TABLE #Doctor
  (
    doctorID   int PRIMARY KEY,
    doctorNo   varchar(100),
    name       varchar(50),
    title      varchar(50),
    department varchar(100)
  );
  insert into #Doctor (doctorID, doctorNo, name, title, department)
  select distinct A.ID, A.code, A.name, B.name title, C.name department
  from YBHis.LJHis.dbo.BsDoctor A
         left join YBHis.LJHis.dbo.BsDocLevel B ON A.docLevID = B.ID
         left join YBHis.LJHis.dbo.BsLocation C ON A.LocationId = C.ID;

  insert into Doctor (doctorID, doctorNo, name, title, department)
  select doctorID, doctorNo, name, title, department
  from #Doctor
  where doctorID not in (select doctorID from Doctor);

  SELECT @insertRowCount = @@rowcount;
  select 'insert:' + convert(varchar(2), @insertRowCount);

  UPDATE A
  SET A.name=B.name,
      A.title=B.title,
      A.department=B.department,
      A.UpdateTime = GetDate()
  FROM Doctor A,
       #Doctor B
  WHERE A.doctorNo = B.doctorNo
    AND ((A.name != B.name) or (A.title != B.title) or (A.department != B.department));
  SELECT @updateRowCount = @@rowcount;
  SELECT 'update:' + convert(varchar(2), @updateRowCount);

  -- 删除
  UPDATE Doctor SET IsDelete = 1, UpdateTime = GetDate() WHERE doctorNo NOT IN (SELECT doctorNo FROM #Doctor);
  SELECT @deleteRowCount = @@rowcount;

  DROP TABLE #Doctor;

  --delete Dict  where parentID=108  and dictNo is null;
  INSERT INTO Dict (dictNo, name, value, parentID, layer, haschild, orderNum)
  select code, name, case LsInOut when 1 then '住院科室' when 2 then '门诊科室' else '' end, 108, 2, 0, orderby
  from YBHis.LJHis.dbo.BsLocation
  where LsInOut in (1, 2)
    and code not in (select dictNo from Dict where parentID = 108);
  SELECT @insertRowCount = @insertRowCount + @@rowcount;

  IF (@logID > 0)
    BEGIN
      SELECT @lastID = CASE WHEN max(doctorID) IS NULL THEN 0 ELSE max(doctorID) END FROM Doctor;
      --SELECT @timeSpent = datediff(MS, @startTime, getdate());
      EXEC monitorUpdateTaskLog @logID, 'ljDoctor', 'Doctor', @lastID, @deleteRowCount, @insertRowCount, @updateRowCount, @startTime;
    END;

end;
go

