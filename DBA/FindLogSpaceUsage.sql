/*-------------------------------------------------------------------------------------------------
        NAME: FindLogSpaceUsage.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Provides statistics about how the transaction-log space is used in all databases.
              http://msdn.microsoft.com/en-us/library/ms189768.aspx
-------------------------------------------------------------------------------------------------
     HISTORY:
         DATE MODIFIED      DESCRIPTION   
-------------------------------------------------------------------------------------------------
   02.12.2012 SYoung        Initial creation.
   03.25.2015 SYoung        Add table variable to enable filtering
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
              killing your buzz or ANYTHING else that can be thought up.
-------------------------------------------------------------------------------------------------*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON

DECLARE @Param varchar(128)

SET @Param = 'DW_ShawStore'

DECLARE @RESULT AS TABLE (
        database_name varchar(128)
      , [log_size(MB)] varchar(128)
      , [log_space(%)] varchar(128)
      , [status] bit)
INSERT INTO @RESULT
EXEC('DBCC SQLPERF(LOGSPACE)')

SELECT * 
  FROM @RESULT
 WHERE database_name LIKE '%'+ @Param +'%'
GO
