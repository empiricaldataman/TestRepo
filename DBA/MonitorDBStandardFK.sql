/*-----------------------------------------------------------------------------------------------
        NAME: MonitorDBStandardFK.sql
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

SELECT DISTINCT * 
  FROM (SELECT FK_Table = FK.TABLE_NAME
             , FK_Column = CU.COLUMN_NAME
             , PK_Table = PK.TABLE_NAME
             , PK_Column = PT.COLUMN_NAME
             , Constraint_Name = C.CONSTRAINT_NAME
             , Cons = 'fk_'+ FK.TABLE_NAME +'_'+CU.COLUMN_NAME+'__'+PK.TABLE_NAME+'_'+PT.COLUMN_NAME
             , 'ForeignKeys' Types
             , Rename = 'SP_RENAME '''+ C.CONSTRAINT_NAME +''', '''+'fk_'+ FK.TABLE_NAME +'_'+CU.COLUMN_NAME+'__'+PK.TABLE_NAME+'_'+PT.COLUMN_NAME+''''
          FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
         INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
         INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
         INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
         INNER JOIN (SELECT i1.TABLE_NAME
                          , i2.COLUMN_NAME
			                 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1
			                INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
                      WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY') PT ON PT.TABLE_NAME = PK.TABLE_NAME
       ) A 
 WHERE Constraint_Name <> 'fk_'+ FK_Table +'_'+ FK_Column +'__'+ PK_Table +'_'+ PK_Column COLLATE Latin1_General_CS_AS
 ORDER BY a.Constraint_Name ASC
GO


