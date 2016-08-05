/*-------------------------------------------------------------------------------------------------
        NAME: BackupDuration.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Displays database backup duration and device location.
    REQUIRES: fn_CreatTimeString() user defined function.
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
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @dbName sysname

SELECT @dbName = NULL

SELECT @@SERVERNAME [ServerName]
     , A.database_name [DatabaseName]
     , DATEDIFF(s,A.backup_start_date, A.backup_finish_date) [BackupDuration (secs)]
     , msdb.dbo.fn_CreateTimeString(DATEDIFF(s,A.backup_start_date, A.backup_finish_date)) [BackupDuration]
     , STR(CAST(backup_size AS DECIMAL(20,2)) / 1048576 ,10,2) + ' MB' [BackupSize]
     , C.physical_device_name [DeviceLocation]
     , CONVERT(varchar(50), A.backup_finish_date, 120) [BackupFinishDate]
  FROM msdb.dbo.backupset A
 INNER JOIN msdb.dbo.backupMediaFamily C ON A.media_set_id = C.media_set_id
 WHERE 1 = 1
   AND A.database_name = COALESCE(@dbName, A.database_name)
 ORDER BY A.database_name, A.backup_finish_date DESC;
GO
