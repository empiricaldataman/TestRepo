/*-----------------------------------------------------------------------------------------------
        NAME: IndexFragmentation.sql
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

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT OBJECT_NAME(dt.object_id) [object_name]
     , si.name
     , dt.avg_fragmentation_in_percent
     , dt.avg_page_space_used_in_percent
  FROM (SELECT object_id
             , index_id
             , avg_fragmentation_in_percent
             , avg_page_space_used_in_percent
          FROM sys.dm_db_index_physical_stats(DB_ID(DB_NAME()), NULL, NULL, NULL, 'SAMPLED')
         WHERE index_id != 0) AS dt
  INNER JOIN sys.indexes si ON si.object_id = dt.object_id AND
        si.index_id = dt.index_id
GO
