/*-----------------------------------------------------------------------------------------------
        NAME: FindObjectReference.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Use this script to find all references to and from a database object.  This script
              is based on a blog entry by Tamarick L. Hill

              Use sp_s if you are looking for a way to find column level reference.
-------------------------------------------------------------------------------------------------
         DATE MODIFIED      DESCRIPTION    
-------------------------------------------------------------------------------------------------
   05.17.2013 SYoung        Initial creation.
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
			        killing your buzz or ANYTHING else that can be thought up.
-----------------------------------------------------------------------------------------------*/
:CONNECT <SQLInstance, sysname, SQLInstance>
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT A.referencing_schema_name [ReferencingSchema]
     , A.referencing_entity_name [ReferencingDBObject]
     , B.type_desc [ReferencingType]
  FROM sys.dm_sql_referencing_entities('<DBObjectName, sysname, schema.object_name>','OBJECT') A
  LEFT JOIN sys.objects B ON A.referencing_id = B.[object_id];


SELECT DISTINCT B.type_desc [ReferencedType]
     , A.referenced_server_name
     , A.referenced_database_name
     , A.referenced_entity_name [ReferencedDBObject]
  FROM sys.dm_sql_referenced_entities('<DBObjectName, sysname, schema.object_name>','OBJECT') A
  LEFT JOIN sys.objects B ON A.referenced_id = B.[object_id];


SELECT B.type_desc [ReferencedType]
     , A.*
  FROM sys.dm_sql_referenced_entities('<DBObjectName, sysname, schema.object_name>','OBJECT') A
  LEFT JOIN sys.objects B ON A.referenced_id = B.[object_id];
GO
