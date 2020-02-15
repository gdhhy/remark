EXEC sp_addlinkedserver
     'YBHis',        --要创建的链接服务器名称
     'SqlServer 2017',     --产品名称
     'SQLOLEDB', --OLE DB 字符
     'DESKTOP-64SP54G' --数据源
--创建链接服务器上远程登录之间的映射

EXEC sp_addlinkedsrvlogin
     'YBHis',
     'false',
     NULL,
     'sa', --远程服务器的登陆用户名
     'cjdlx' --远程服务器的登陆密码