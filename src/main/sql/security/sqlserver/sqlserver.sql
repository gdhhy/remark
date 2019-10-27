CREATE TABLE sys_user
(
    userID           int                                    NOT NULL identity,
    loginName        varchar(20) COLLATE Chinese_PRC_CI_AS  NOT NULL,
    password         varchar(40) COLLATE Chinese_PRC_CI_AS  NOT NULL,
    accountNonLocked tinyint                                NULL DEFAULT 1,
    name             varchar(100) COLLATE Chinese_PRC_CI_AS NULL,
    link             varchar(1000)                          NULL,
    createDate       datetime                               NULL DEFAULT CURRENT_TIMESTAMP,
    note             varchar(255) COLLATE Chinese_PRC_CI_AS NULL,
    groupID          int                                    NULL,
    orderID          int                                    NULL DEFAULT 1,
    expiredDate      datetime                               NULL,
    lockedIP         varchar(40) COLLATE Chinese_PRC_CI_AS  NULL,
    lockedLoginIP    tinyint                                NULL DEFAULT 0,
    lastLoginTime    datetime                               NULL,
    lastLoginIP      varchar(40) COLLATE Chinese_PRC_CI_AS  NULL,
    allowSynLogin    tinyint                                NULL DEFAULT 1,
    failureLogin     int                                    NULL DEFAULT 0,
    succeedLogin     int                                    NULL DEFAULT 0,
    updateTime       datetime                               NULL,
    roles            varchar(255) COLLATE Chinese_PRC_CI_AS NULL DEFAULT '',
    PRIMARY KEY (userID)
);
-- ----------------------------
-- Records of sys_user
-- ----------------------------


set IDENTITY_INSERT sys_user on;
insert into sys_user (userID,loginName,password,accountNonLocked,name,
                      createDate,note,expiredDate,lockedIP,lockedLoginIP,lastLoginTime,
                      lastLoginIP,allowSynLogin,failureLogin,succeedLogin )
select   A.userID,A.userName,'a7bd3162f5a68d6fdab8a279fb1865c07d539f30',1,A.name,
         A.createDate,roleName=STUFF((SELECT ','+C.name FROM rbac..Sys_UserRole B  left join rbac..Sys_Role C on B.roleID=C.roleID WHERE B.userID=A.userID FOR XML PATH('')), 1, 1, ''),
         A.dimissionDate,A.loginIP,A.isLimitIP,A.lastLoginTime,
         A.lastLoginIP,1,A.failureLogin,A.succeedLogin
from rbac..Sys_User A  ;
set IDENTITY_INSERT sys_user off;
update  "dbo"."sys_user" set roles='REVIEW' where note like '%药剂%';
update  "dbo"."sys_user" set roles='ADMIN' where  userid in(102);
update  "dbo"."sys_user" set roles='DEVELOP' where  userid in(1);
update  "dbo"."sys_user" set roles='DOCTOR' where note ='医生';

INSERT INTO "dbo"."sys_user" (loginName, password, accountNonLocked, name, link, createDate, note, groupID, orderID, expiredDate, lockedIP, lockedLoginIP, lastLoginTime,
                              lastLoginIP,
                              allowSynLogin, failureLogin, succeedLogin, updateTime, roles)
VALUES ('dongtian', '96967f32873e975683971e19a7f5ddd81f8e239d', 1, 'admin', NULL, '2019-04-16 10:50:02', NULL, NULL, 1, NULL, NULL, 0, '2019-10-10 10:42:48',
        '192.168.1.234', 1, 0, 529, '2019-10-10 10:42:46', 'ADMIN');
INSERT INTO "dbo"."sys_user" (loginName, password, accountNonLocked, name, link, createDate, note, groupID, orderID, expiredDate, lockedIP, lockedLoginIP, lastLoginTime,
                              lastLoginIP,
                              allowSynLogin, failureLogin, succeedLogin, updateTime, roles)
VALUES ('abc', '42542bb7b09689489cafa59bc30b51a91dd4472d', 1, '张三', NULL, '2019-04-16 11:40:01', NULL, 1, NULL, NULL, NULL, 0, '2019-10-06 21:55:30', '0:0:0:0:0:0:0:1',
        1, 0, 19, '2019-10-06 21:55:28', 'DEVELOP');
INSERT INTO "dbo"."sys_user" (loginName, password, accountNonLocked, name, link, createDate, note, groupID, orderID, expiredDate, lockedIP, lockedLoginIP, lastLoginTime,
                              lastLoginIP,
                              allowSynLogin, failureLogin, succeedLogin, updateTime, roles)
VALUES ('456', '22ec1032a5f6abf3a39fca34439b4bb9e9f94302', 1, '科学的', NULL, '2019-04-16 14:21:31', NULL, 2, NULL, NULL, NULL, 0, '2019-07-25 17:52:33', '0:0:0:0:0:0:0:1',
        1, 0, 1, '2019-10-06 14:46:20', 'USER');

CREATE TABLE persistent_logins
(
    username  varchar(64) COLLATE Chinese_PRC_CI_AS NOT NULL,
    series    varchar(64) COLLATE Chinese_PRC_CI_AS NOT NULL,
    token     varchar(64) COLLATE Chinese_PRC_CI_AS NOT NULL,
    last_used datetime                              NOT NULL,
    PRIMARY KEY (series)
);