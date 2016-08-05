/*-------------------------------------------------------------------------------------------------
        NAME: BrowsereplcmdsFiltered.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Returns a result set in a readable version of the replicated commands stored in the
              distribution database.
-------------------------------------------------------------------------------------------------
         DATE MODIFIED      DESCRIPTION   
-------------------------------------------------------------------------------------------------
   06.21.2012 SYoung        Initial creation.
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
              killing your buzz or ANYTHING else that can be thought up.
-------------------------------------------------------------------------------------------------*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON

IF OBJECT_ID(N'tempdb..#PendingTrans','U') IS NOT NULL
   DROP TABLE #PendingTrans

CREATE TABLE #PendingTrans (
       xact_seqno varbinary(16) NULL
     , originator_srvname sysname NULL
     , originator_db sysname NULL
     , article_id int NULL
     , type int NULL
     , partial_command bit NULL
     , hashkey int NULL
     , originator_publication_id int NULL
     , originator_db_version int NULL
     , originator_lsn varbinary(16) NULL
     , command nvarchar(1024) NULL
     , command_ID int NULL)

INSERT #PendingTrans
  EXEC sp_browsereplcmds

SELECT * 
  FROM #PendingTrans 
 WHERE 1 = 1
   AND [command] LIKE '%SearchPattern%'
GO