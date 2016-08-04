/*-------------------------------------------------------------------------------------------------
        NAME: BCPCommandGen.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Use this script to generate BCP OUT/IN commands to be used in a multi threaded/session
              bulk insert.  The OUT must be executed under a SQLCMD session.
-------------------------------------------------------------------------------------------------
         DATE MODIFIED      DESCRIPTION   
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
              killing your buzz or ANYTHING else that can be thought up.
-------------------------------------------------------------------------------------------------*/
SET NOCOUNT ON

DECLARE @database_name varchar(128)
      , @schema_name varchar(128)
      , @table_name varchar(128)
      , @threads tinyint
      , @path varchar(128)

SELECT @database_name = 'Securities'
     , @schema_name = 'budget'
     , @table_name = 'Account'
     , @threads = 40
     , @path = 'C:\temp\BCPtest\Account_'

SELECT N':!!BCP "SELECT top 10 * FROM ['+ @database_name +'].['+ @schema_name +'].['+ @table_name +']" QUERYOUT '+ @path + FORMAT(GETDATE(), 'yyyyMMdd') +'.bcp -S '+ @@SERVERNAME +' -T -c -t$*^!^*$ -r!#@$@#!' [OUT]
     , N'BULK INSERT ['+ @database_name +'].['+ @schema_name +'].['+ @table_name +'] FROM '''+ @path + FORMAT(GETDATE(), 'yyyyMMdd') +'.bcp'' WITH (FIELDTERMINATOR = ''$*^!^*$'', ROWTERMINATOR = ''!#@$@#!'', TABLOCK)' [IN]


