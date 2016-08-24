/*-----------------------------------------------------------------------------------------------
        NAME: MonitorDBStandardDF.sql
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
     , schema_name(b.schema_id) SchemaName
     , c.name ObjectName
     , b.name TableName
     , a.name ColumnName
     , 'Defaults'
     ,'SP_RENAME ''' + c.name + ''', ''df_' + b.name + '_' + a.name + ''''  as 'Script To Rename'
  FROM sys.all_columns a 
 INNER JOIN	sys.objects b ON a.object_id = b.object_id
 INNER JOIN	sys.default_constraints c ON a.default_object_id = c.object_id
 WHERE c.is_ms_shipped = 0
	 AND c.parent_object_id  <> 0 
	 AND c.name <> 'df_' + b.name + '_' + a.name COLLATE Latin1_General_CS_AS
 ORDER BY c.name asc
GO

