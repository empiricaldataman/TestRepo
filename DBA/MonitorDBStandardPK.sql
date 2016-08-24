/*-----------------------------------------------------------------------------------------------
        NAME: MonitorDBStandardPK.sql
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

SELECT DISTINCT ServerName
     , DatabaseName
     , SchemaName
     , Objectname
     , TableName
     , ColumnName
     , [Types]
     , 'SP_RENAME ''' + Objectname + ''', ''pk_' + ltrim(rtrim(TableName)) + '_' + ltrim(rtrim(replace(ColumnName,', ','_'))) + ''''  as 'Script To Rename'
  FROM (SELECT @@Servername ServerName
             , DB_name() DatabaseName
             , schema_name(OBJ.schema_id) SchemaName
             , ind.name Objectname
             , object_name(obj.parent_object_id) TableName
             , SUBSTRING(( SELECT ', ' + AC.name
                             FROM sys.[tables] AS T
                            INNER JOIN sys.[indexes] I ON T.[object_id] = I.[object_id]
                            INNER JOIN sys.[index_columns] IC ON I.[object_id] = IC.[object_id]
                              AND I.[index_id] = IC.[index_id]
                            INNER JOIN sys.[all_columns] AC ON T.[object_id] = AC.[object_id]
                              AND IC.[column_id] = AC.[column_id]
                            WHERE Ind.[object_id] = I.[object_id]
                              AND Ind.index_id = I.index_id
                              AND IC.is_included_column = 0
                            ORDER BY IC.key_ordinal
                              FOR	XML PATH('')), 2, 8000) AS ColumnName
            , 'PrimaryKeys' Types	
          FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE 
         INNER JOIN	SYS.objects OBJ ON OBJECT_ID(constraint_name) = OBJ.object_id 
         INNER JOIN sys.Indexes Ind ON obj.parent_object_id = ind.object_id 
         WHERE OBJ.type_desc = 'PRIMARY_KEY_CONSTRAINT' 
           AND OBJ.TYPE = 'PK'
           AND obj.is_ms_shipped = 0
           AND Ind.type = 1
           AND Ind.is_disabled = 0) AS A
 WHERE LTRIM(RTRIM(Objectname)) <> 'pk_' + LTRIM(RTRIM(TableName)) + '_' + LTRIM(RTRIM(REPLACE(ColumnName,', ','_'))) COLLATE Latin1_General_CS_AS
 ORDER BY TableName ASC

