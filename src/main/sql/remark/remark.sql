create table remark (
    remarkID   int IDENTITY PRIMARY KEY,
    objectID   int,
    objectType varchar(20),
    remarkType varchar(20),
    remark     varchar(8000),
    remarkTime timestamp
);