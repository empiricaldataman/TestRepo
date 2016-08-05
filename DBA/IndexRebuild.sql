/*-----------------------------------------------------------------------------------------------
        NAME: IndexRebuild.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Determine index fragementation for all tables in the current database
              External fragmentation is indicated when avg_fragmentation_in_percent exceeds 10
              Internal fragmentation is indicated when avg_page_space_used_in_percent falls below 75
-------------------------------------------------------------------------------------------------
         DATE MODIFIED      DESCRIPTION   
-------------------------------------------------------------------------------------------------
   07.05.2012 SYoung        Initial creation.
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
              killing your buzz or ANYTHING else that can be thought up.
-----------------------------------------------------------------------------------------------*/
SET NOCOUNT ON

IF OBJECT_ID('tempdb..#tblIndexDefrag','U') IS NOT NULL DROP TABLE #tblIndexDefrag
GO

SELECT dt.[schema]
     , OBJECT_NAME(dt.[object_id]) [TableName]
     , si.name [IndexName]
     , dt.avg_fragmentation_in_percent
     , dt.avg_page_space_used_in_percent
  INTO #tblIndexDefrag
  FROM (SELECT S.[name] [schema]
             , A.[object_id]
             , A.index_id
             , A.avg_fragmentation_in_percent
             , A.avg_page_space_used_in_percent
          FROM sys.dm_db_index_physical_stats(DB_ID(DB_NAME()), NULL, NULL, NULL, 'SAMPLED') A
         INNER JOIN sys.objects O ON A.object_id = O.object_id
         INNER JOIN sys.schemas S ON O.schema_id = S.schema_id
         WHERE index_id != 0) AS dt
  INNER JOIN sys.indexes si ON si.[object_id] = dt.[object_id]
    AND si.index_id = dt.index_id

DECLARE @schema varchar(128)
      , @vTableName varchar(128)
      , @vIndexName varchar(128)
      , @vSQL nvarchar(4000)
        
DECLARE C CURSOR FAST_FORWARD
    FOR SELECT [schema]
             , [TableName]
             , [IndexName]
          FROM #tblIndexDefrag
         WHERE avg_fragmentation_in_percent > 40 
         ORDER BY 2 DESC, 1 DESC

   OPEN C
  FETCH NEXT FROM C
   INTO @schema, @vTableName, @vIndexName

  WHILE @@FETCH_STATUS = 0
        BEGIN
        SELECT @vSQL = N'ALTER INDEX '+ @vIndexName + CHAR(10) +
                        '   ON ['+ @shema +'].['+ @vTableName +']'+ CHAR(10) +
                        '      REBUILD WITH (ONLINE = ON)'
                        
        EXEC(@vSQL)
        
        PRINT 'Index '+ @vIndexName +' on table '+ @schema +'.'+ @vTableName +' has been defragmented.'
        FETCH NEXT FROM C INTO @schema, @vTableName, @vIndexName                
  END
  CLOSE C
DEALLOCATE C
GO
