/*-------------------------------------------------------------------------------------------------
        NAME: FindTextInProcedure.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Returns the name of stored procedures with the search patern.
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
			        killing your buzz or ANYTHING else that can be thought up.
-------------------------------------------------------------------------------------------------*/
:CONNECT <SQLInstance, sysname, SQLInstance>
USE <DBName, sysname, DBName>
GO

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @pattern nvarchar(4000)
SET @pattern = ''

SELECT DISTINCT A.[name] [ProcName] 
  FROM sys.sysobjects A 
 INNER JOIN sys.syscomments B ON A.id = B.id 
 WHERE A.xtype = 'P' 
   AND B.[text] LIKE '%'+ @pattern +'%';
GO
