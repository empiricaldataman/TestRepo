--/*-----------------------------------------------------------------------------------------------
--        NAME: ExtendedProperties.sql
-- MODIFIED BY: Sal Young
--       EMAIL: saleyoun@yahoo.com
-- DESCRIPTION: CONNECT TO SQL INSTANCE AND DATABASE TO SCRIPT OUT ALL EXTENDED PROPERTIES SELECT THE 
---------------------------------------------------------------------------------------------------
--  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
--              personal property, creating singularities, making deep fried chicken, causing your 
--              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
--			        killing your buzz or ANYTHING else that can be thought up.
---------------------------------------------------------------------------------------------------*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SET NOCOUNT ON

-- use this to find the distinct types of extended properties on a database
--SELECT DISTINCT [name] FROM sys.extended_properties

WITH CTE1 
  AS (SELECT B.[name]
           , CAST(B.value AS varchar(8000)) [Value]
           , 'SCHEMA' [level0type]
           , 'dbo' [level0name]
           , CASE WHEN A.type = 'U' THEN 'TABLE'
                  WHEN A.type = 'P' THEN 'PROCEDURE'
                  WHEN A.type = 'FN' THEN 'FUNCTION'
                  WHEN A.type = 'V' THEN 'VIEW'
                  ELSE A.type END [level1type]
           , A.[name] collate SQL_Latin1_General_CP1_CI_AS [level1name]
           , DB_NAME() [dbname]
           , B.major_id
        FROM sys.all_objects A
       INNER JOIN sys.extended_properties B ON A.object_ID = major_ID AND
             B.minor_ID = 0
       WHERE A.is_ms_shipped = 0
         AND B.[name] = 'MS_Description'),
      CTE2
   AS (SELECT B.[name]
           , CAST(B.value AS varchar(8000)) [Value]
           , 'SCHEMA' [level0type]
           , 'dbo' [level0name]
           , CASE WHEN A.type = 'U' THEN 'TABLE'
                  WHEN A.type = 'P' THEN 'PROCEDURE'
                  WHEN A.type = 'FN' THEN 'FUNCTION'
                  WHEN A.type = 'V' THEN 'VIEW'
                  ELSE A.type END [level1type]
           , A.[name] collate SQL_Latin1_General_CP1_CI_AS [level1name]
           , DB_NAME() [dbname]
           , B.major_id
        FROM sys.all_objects A
       INNER JOIN sys.extended_properties B ON A.object_ID = major_ID AND
             B.minor_ID = 0
       WHERE A.is_ms_shipped = 0
         AND B.[name] = 'SVNRevisionNumber')

SELECT * 
  FROM CTE1
