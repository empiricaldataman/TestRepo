/*-----------------------------------------------------------------------------------------------
        NAME: MonitorDBStandardIX.sql
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
     , 'SP_RENAME ''' + Objectname + ''', ''ix_' + ltrim(rtrim(TableName)) + '_' + ltrim(rtrim(replace(ColumnName,', ','_'))) + ''''  as 'Script To Rename' 
  FROM (SELECT @@Servername ServerName
             , DB_name() DatabaseName
             , s.name SchemaName
             , t.name TableName
             , Ind.name Objectname
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
                              FOR XML PATH('')), 2, 8000) AS ColumnName
             , 'Index' [Types]
          FROM sys.tables t
         INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
         INNER JOIN sys.indexes Ind ON Ind.object_id = t.object_id 
         INNER JOIN sys.objects OBJ ON t.object_id = OBJ.object_id 
         WHERE Ind.index_id > 0    
           AND Ind.type in (1, 2) -- clustered & nonclustered only
           AND Ind.is_primary_key = 0 -- do not include PK indexes
           AND Ind.is_unique_constraint = 0 -- do not include UQ
           AND Ind.is_disabled = 0
           AND Ind.is_hypothetical = 0
           AND OBJ.TYPE = 'U' 
           AND obj.is_ms_shipped = 0) AS A
  WHERE ltrim(rtrim(Objectname)) <> 'ix_' + ltrim(rtrim(TableName)) + '_' + ltrim(rtrim(replace(ColumnName,', ','_'))) COLLATE Latin1_General_CS_AS

