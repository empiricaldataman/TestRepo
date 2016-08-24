/*-------------------------------------------------------------------------------------------------
        NAME: LastBackup.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Display information about the last backup for each database. Use the @type variable 
              to filter by backup type. 
              D = Full, I = Diff, L = Log

              Comment out the JOIN to @tbl0 if you need all backups.

              This script will only run in production because the function fn_CreateTimeString was
              created in production servers only.  Feel free to script out the UDF and deploy
              to any servers you need to gather backup info.
-------------------------------------------------------------------------------------------------
         DATE MODIFIED      DESCRIPTION    
-------------------------------------------------------------------------------------------------
   10.20.2013 SYoung        Initial creation.
   09.15.2015 SYoung        Added parameter for backup type
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
              killing your buzz or ANYTHING else that can be thought up.
-------------------------------------------------------------------------------------------------*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON

BEGIN
DECLARE @tbl0 TABLE (
        database_name varchar(128) PRIMARY KEY,
        backup_finish_date smalldatetime)

DECLARE @type char(1)
SET @type = 'D'        

--[ GATHERS THE DB NAME AND DATE OF LAST SUCCESSFUL BACKUP ] 
INSERT @tbl0 (database_name, backup_finish_date)
SELECT database_name,
       MAX(CAST(CONVERT(char(10),backup_finish_date,112) AS SMALLDATETIME)) [backup_finish_date] 
  FROM msdb.dbo.backupset
 WHERE [type] = 'D'
 GROUP BY database_name
       

--[ DISPLAY GENERAL INFORMATION FOR LAST SUCCESSFUL BACKUP FOR EACH DATABASE ]
SELECT @@SERVERNAME [ServerName]
     , A.database_name
     , msdb.dbo.fn_CreateTimeString(DATEDIFF(s,A.backup_start_date, A.backup_finish_date)) [BackupDuration]
     , STR(CAST(backup_size AS DECIMAL(20,2)) / 1048576 ,10,2) + ' MB' [backup_size]
     , C.physical_device_name
     , A.backup_finish_date
  FROM msdb.dbo.backupset A
 INNER JOIN @tbl0 B ON A.database_name = B.database_name
   AND A.backup_finish_date >= B.backup_finish_date
 INNER JOIN msdb.dbo.backupMediaFamily C ON A.media_set_id = C.media_set_id
 WHERE [type] = @type
 ORDER BY A.backup_finish_date
END
GO
