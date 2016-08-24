/*-----------------------------------------------------------------------------------------------
        NAME: MonitorDBStandardCK.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: 
-------------------------------------------------------------------------------------------------
         DATE MODIFIED      DESCRIPTION   
-------------------------------------------------------------------------------------------------
   06.17.2010 SYoung        Initial creation.
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
              killing your buzz or ANYTHING else that can be thought up.
-----------------------------------------------------------------------------------------------*/
SET NOCOUNT ON

SELECT @@Servername ServerName
     , DB_name() DatabaseName
     , cc.CONSTRAINT_SCHEMA SchemaName
     , cc.CONSTRAINT_NAME ObjeName
     , TABLE_NAME TableName
     , COLUMN_NAME ColumnName
     , 'Check' Types
     , 'SP_RENAME ''' + cc.CONSTRAINT_NAME + ''', ''ck_' + TABLE_NAME + '_' + COLUMN_NAME + ''''  as 'Script To Rename'
  FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc
 INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE c ON cc.CONSTRAINT_NAME = c.CONSTRAINT_NAME
 WHERE cc.CONSTRAINT_NAME <> 'ck_' + TABLE_NAME + '_' + COLUMN_NAME COLLATE Latin1_General_CS_AS
