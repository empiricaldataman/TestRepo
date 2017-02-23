/*-----------------------------------------------------------------------------------------------
       NAME: SearchProcedures.sql
MODIFIED BY: Sal Young
      EMAIL: saleyoun@yahoo.com
DESCRIPTION: Use this template to search for a string pattern on the definition of all stored
             procedures and functions.
-------------------------------------------------------------------------------------------------
 DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of
             personal property, creating singularities, making deep fried chicken, causing your
             toilet to  explode, making  your animals spin  around like mad, causing hair loss,
             killing your buzz or ANYTHING else that can be thought up.
-----------------------------------------------------------------------------------------------*/
:CONNECT <SQLInstance, sysname, SQLInstance>
USE <DBName, sysname, DBName>
GO

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
DECLARE @search_pattern nvarchar(256)
SET @search_pattern = '<SearchPattern, sysname, StringToLookFor>'
 
SELECT S.[name] [schema_name]
     , O.[name] [object_name]
     , O.[type]
     , O.create_date
     , O.modify_date
     , M.[definition]
  FROM [sys].[objects] O
 INNER JOIN [sys].[schemas] S ON O.schema_id = S.schema_id
 INNER JOIN [sys].[all_sql_modules] M ON O.object_id = M.object_id
 WHERE M.[definition] LIKE '%'+ @search_pattern +'%';
GO
