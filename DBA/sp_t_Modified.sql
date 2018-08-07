/*-------------------------------------------------------------------------------------------------
        NAME: sp_t_Modified.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Displays row count, index size and total table size for a specific file(s). This
              script requires that sp_t procedure already exist on the server.
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
              killing your buzz or ANYTHING else that can be thought up.
-------------------------------------------------------------------------------------------------*/
SET NOCOUNT ON

DECLARE @sp_t TABLE (
        instance_name VARCHAR(40)
      , database_name VARCHAR(40)
      , [type] CHAR(1)
      , [schema_name] VARCHAR(40)
      , table_name VARCHAR(200)
      , create_date DATE
      , row_count BIGINT
      , data_size INT
      , index_size INT
      , total_size INT)

INSERT INTO @sp_t
EXEC sp_t

SELECT instance_name
     , database_name
     , [type]
     , [schema_name]
     , table_name
     , create_date
     , row_count
     , data_size
     , index_size
     , total_size
  FROM @sp_t
 WHERE table_name IN ('[TableName]','[TableName]','[TableName]');

GO

