/*-------------------------------------------------------------------------------------------------
        NAME: Read_Default_Trace.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: 
-------------------------------------------------------------------------------------------------
--  CHANGE HISTORY:
-- TR/PROJ#    DATE        MODIFIED      DESCRIPTION   
-------------------------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
              killing your buzz or ANYTHING else that can be thought up.
-------------------------------------------------------------------------------------------------*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @path varchar(256)

SELECT @path = [path]
  FROM sys.traces
 WHERE is_default = 1

SELECT SPID,
       HostName,
       ServerName,
       DatabaseName,
       EventClass,
       EventSubClass,
       TextData,
       ObjectName,
       LoginName,
       SessionLoginName,
       StartTime       
  FROm fn_trace_gettable(@path,NULL)
 WHERE LoginName <> 'BROWER\SQLServiceManagement'
 ORDER BY StartTime
GO