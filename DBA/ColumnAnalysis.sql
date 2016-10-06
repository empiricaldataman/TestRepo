/*-----------------------------------------------------------------------------------------------
        NAME: ColumnAnalysis.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Displays column information from all tables where the column name pattern is found.
              Use this script to review data type for columns in new tables.
-------------------------------------------------------------------------------------------------
         DATE MODIFIED      DESCRIPTION    
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
			        killing your buzz or ANYTHING else that can be thought up.
-----------------------------------------------------------------------------------------------*/
:CONNECT <SQLInstance, sysname, SQLInstance>

SET NOCOUNT ON

DECLARE @ColumnName varchar(128)

SET @ColumnName = 'AccountID'

SELECT C.TABLE_CATALOG
     , C.TABLE_SCHEMA
     , C.TABLE_NAME
     , C.COLUMN_NAME
     , C.IS_NULLABLE
     , C.DATA_TYPE
     , C.CHARACTER_MAXIMUM_LENGTH
     , N'SELECT MAX(LEN('+ COLUMN_NAME +')) ['+ C.TABLE_NAME +'] FROM '+ C.TABLE_SCHEMA +'.'+ C.TABLE_NAME +' WITH (NOLOCK);'+ CHAR(10) +'GO'+ CHAR(10)
  FROM [INFORMATION_SCHEMA].[COLUMNS] C
 INNER JOIN sys.objects O ON C.TABLE_NAME = O.[name]
 INNER JOIN sys.schemas S ON O.[schema_id] = S.[schema_id]
   AND C.TABLE_SCHEMA = S.[name]
 WHERE COLUMN_NAME LIKE '%'+ @ColumnName +'%'
   AND O.[type] = 'U'
 ORDER BY C.DATA_TYPE, TABLE_NAME;
 GO
