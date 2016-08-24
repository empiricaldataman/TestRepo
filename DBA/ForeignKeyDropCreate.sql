/*-----------------------------------------------------------------------------------------------
        NAME: ForeignKeyDropCreate.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: This will generate DDL code for the DROP (left column) and CREATE (right column)
              of existing FK constraints in a database.
-------------------------------------------------------------------------------------------------
         DATE MODIFIED      DESCRIPTION   
-------------------------------------------------------------------------------------------------
   03.17.2015 SYoung        Initial creation.
   07.28.2015 SYoung        Add UDF to handle multi column FK constraints
   11.12.2015 SYoung        Add parameters to allow for single table or all tables FKs
   04.05.2015 SYoung        Add DROP FUNCTION
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
              killing your buzz or ANYTHING else that can be thought up.
-----------------------------------------------------------------------------------------------*/
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF OBJECT_ID(N'dbo.fn_RowsToCSV','fn') IS NOT NULL
   BEGIN
   DROP FUNCTION fn_RowsToCSV
END
GO

CREATE FUNCTION [dbo].[fn_RowsToCSV] (@FKName varchar(128), @PC char(1))

RETURNS varchar(max)

AS

BEGIN
  DECLARE @value varchar(max)
  ;
IF @PC = 'F'  
   WITH FKey
     AS (SELECT i2.TABLE_CATALOG
              , i2.TABLE_SCHEMA
              , i2.TABLE_NAME
              , i2.COLUMN_NAME
              , i2.ORDINAL_POSITION
              , i1.CONSTRAINT_NAME
           FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1
          INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
          WHERE i1.CONSTRAINT_TYPE = 'FOREIGN KEY'
            AND i1.CONSTRAINT_NAME = @FKName)
      , FKColumns
     AS (SELECT ORDINAL_POSITION
              , STUFF((SELECT '], [' + COLUMN_NAME 
                          FROM FKey
                         ORDER BY ORDINAL_POSITION
                           FOR XML PATH(''), TYPE).value('.','varchar(max)'),1,2,'') +']'  [COLUMN_LIST]
           FROM FKey)
  
  SELECT @value = LTRIM(COLUMN_LIST)
    FROM FKey
    INNER JOIN FKColumns ON FKey.ORDINAL_POSITION = FKColumns.ORDINAL_POSITION
    WHERE Fkey.ORDINAL_POSITION = 1

IF @PC = 'P'
   WITH FKey
     AS (SELECT i2.TABLE_CATALOG
              , i2.TABLE_SCHEMA
              , i2.TABLE_NAME
              , i2.COLUMN_NAME
              , i2.ORDINAL_POSITION
              , i1.CONSTRAINT_NAME
          FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1
        INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
        WHERE i1.CONSTRAINT_TYPE IN ('PRIMARY KEY','UNIQUE')
          AND i1.CONSTRAINT_NAME = @FKName)
      , FKColumns
      AS (SELECT ORDINAL_POSITION
               , STUFF((SELECT '], [' + COLUMN_NAME 
                          FROM FKey
                        ORDER BY ORDINAL_POSITION
                          FOR XML PATH(''), TYPE).value('.','varchar(max)'),1,2,'') +']'  [COLUMN_LIST]
            FROM FKey)
  
  SELECT @value = LTRIM(COLUMN_LIST)
    FROM FKey
   INNER JOIN FKColumns ON FKey.ORDINAL_POSITION = FKColumns.ORDINAL_POSITION
   WHERE Fkey.ORDINAL_POSITION = 1

  RETURN (@value)
END
GO

DECLARE @pkschema varchar(128)
      , @pktable varchar(128)
      , @fkschema varchar(128)
      , @fktable varchar(128)
      , @check varchar(7)  -- 1 = CHECK; 0 = NOCHECK

SELECT @pkschema = NULL --'dbo'
     , @pktable  = NULL --'EXP_EDAListingCaption'
     , @fkschema = NULL --'dbo'
     , @fktable  = NULL --'EXP_EDAListingCaption'
     , @check    = NULL --0

SELECT @check = CASE WHEN @check = 1 THEN 'CHECK' ELSE 'NOCHECK' END

SELECT N'IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''['+ FK.CONSTRAINT_SCHEMA +'].['+ FK.CONSTRAINT_NAME +']'') AND parent_object_id = OBJECT_ID(N''['+ FK.TABLE_SCHEMA +'].['+ FK.TABLE_NAME +']''))'+ CHAR(10) +
        'ALTER TABLE ['+ FK.TABLE_SCHEMA +'].['+ FK.TABLE_NAME +'] DROP CONSTRAINT ['+ C.CONSTRAINT_NAME +']'+ CHAR(10) +
        'GO'+ CHAR(10) [DROP_CONSTRAINT]
     , N'IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N''['+ FK.CONSTRAINT_SCHEMA +'].['+ FK.CONSTRAINT_NAME +']'') AND parent_object_id = OBJECT_ID(N''['+ FK.TABLE_SCHEMA +'].['+ FK.TABLE_NAME +']''))'+ CHAR(10) +
        'ALTER TABLE ['+ FK.TABLE_SCHEMA +'].['+ FK.TABLE_NAME +'] WITH '+ @check +' ADD CONSTRAINT ['+ FK.CONSTRAINT_NAME +'] FOREIGN KEY('+ dbo.fn_RowsToCSV(C.CONSTRAINT_NAME, 'F') +')'+ CHAR(10) +
        'REFERENCES ['+ PK.TABLE_SCHEMA +'].['+ PK.TABLE_NAME +'] ('+ dbo.fn_RowsToCSV(PK.CONSTRAINT_NAME,'P') +')'+ CHAR(10) +
        'GO'+ CHAR(10) [CREATE_CONSTRAINT]
   FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
   LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
   LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
  WHERE PK.TABLE_SCHEMA = ISNULL(@pkschema, PK.TABLE_SCHEMA)
    AND PK.TABLE_NAME = ISNULL(@pktable, PK.TABLE_NAME)
    AND FK.TABLE_SCHEMA = ISNULL(@fkschema, FK.TABLE_SCHEMA)
    AND FK.TABLE_NAME = ISNULL(@fktable, FK.TABLE_NAME)
  ORDER BY PK.TABLE_NAME
GO

IF OBJECT_ID(N'dbo.fn_RowsToCSV','fn') IS NOT NULL
   BEGIN
   DROP FUNCTION fn_RowsToCSV
END
GO
