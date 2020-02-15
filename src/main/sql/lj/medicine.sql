-- drop table Medicine;
CREATE TABLE [dbo].[Medicine]
(
  [medicineID]       int IDENTITY (1,1)                                        NOT NULL,
  [medicineNo]       varchar(11) COLLATE Chinese_PRC_CI_AS                     NULL,
  [pinyin]           varchar(100) COLLATE Chinese_PRC_CI_AS                    NULL,
  [healthNo]         varchar(20) COLLATE Chinese_PRC_CI_AS                     NULL,
  [chnName]          varchar(100) COLLATE Chinese_PRC_CI_AS                    NULL,
  [engName]          varchar(100) COLLATE Chinese_PRC_CI_AS                    NULL,
  [dose]             varchar(20) COLLATE Chinese_PRC_CI_AS                     NULL,
  [spec]             varchar(100) COLLATE Chinese_PRC_CI_AS                    NULL,
  [price]            decimal(18, 4)                                            NULL,
  [contents]         decimal(18, 4)                                            NULL,
  [producer]         varchar(50) COLLATE Chinese_PRC_CI_AS                     NULL,
  [insurance]        tinyint                                                   NULL,
  [packUnit]         varchar(10) COLLATE Chinese_PRC_CI_AS                     NULL,
  [minUnit]          varchar(10) COLLATE Chinese_PRC_CI_AS                     NULL,
  [measureUnit]      varchar(10) COLLATE Chinese_PRC_CI_AS                     NULL,
  [minOfpack]        int                                                       NULL,
  [matchDrugNo]      varchar(10) COLLATE Chinese_PRC_CI_AS DEFAULT ''          NULL,
  [matchInstrNo]     varchar(10) COLLATE Chinese_PRC_CI_AS DEFAULT ''          NULL,
  [memo]             varchar(255) COLLATE Chinese_PRC_CI_AS                    NULL,
  [injection]        tinyint                                                   NULL,
  [orally]           tinyint                                                   NULL,
  [antiClass]        smallint                              DEFAULT ((-1))      NULL,
  [ddd]              decimal(18, 4)                                            NULL,
  [usageCounter]     int                                                       NULL,
  [western]          tinyint                               DEFAULT ((1))       NULL,
  [base]             tinyint                                                   NULL,
  [updateTime]       smalldatetime                         DEFAULT (getdate()) NULL,
  [updateUser]       varchar(20) COLLATE Chinese_PRC_CI_AS                     NULL,
  [no]               varchar(20) COLLATE Chinese_PRC_CI_AS                     NULL,
  [matchDrugID]      int                                                       NULL,
  [matchInstrID]     int                                                       NULL,
  [maxDay]           int                                                       NULL,
  [menstruum]        int                                                       NULL,
  [mental]           tinyint                                                   NULL,
  [lastPurchaseTime] smalldatetime                                             NULL,
  [dealer]           varchar(30) COLLATE Chinese_PRC_CI_AS                     NULL,
  [route]            int                                                       NULL,
  [injectRoute]      int                                                       NULL,
  [isStat]           tinyint                               DEFAULT ((1))       NULL,
  [isDelete]         smallint                              DEFAULT ((0))       NOT NULL,
  [goodsID]          varchar(20)                                               NULL,
  [refID]            int                                   DEFAULT ((0))       NULL,
  json varchar(2000)
)
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[Medicine]
  SET (LOCK_ESCALATION = TABLE)
GO

CREATE NONCLUSTERED INDEX [IX_Medicine_MatchDrugID]
  ON [dbo].[Medicine] (
                       [matchDrugID] ASC
    )
  WITH (
    FILLFACTOR = 90
    )
GO

CREATE NONCLUSTERED INDEX [IDX_Medicine_goodsID]
  ON [dbo].[Medicine] (
                       [goodsID] ASC
    )