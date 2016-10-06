/*-----------------------------------------------------------------------------------------------
        NAME: DBFileExpand.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Use this template to manually expand a database data file.
-------------------------------------------------------------------------------------------------
         DATE MODIFIED      DESCRIPTION   
-------------------------------------------------------------------------------------------------
   06.17.2010 SYoung        Initial creation.
   10.06.2016 SYoung        Replaced hard coded values with template parameters.
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
			        killing your buzz or ANYTHING else that can be thought up.
-----------------------------------------------------------------------------------------------*/
USE [master]
GO
ALTER DATABASE [<DatabaseName, sysname, DatabaseName>] MODIFY FILE ( NAME = N'<LogicalDataFileName, sysname, DataBaseName_01>', SIZE = <SizeInMB, sysname, 100>MB )
GO
