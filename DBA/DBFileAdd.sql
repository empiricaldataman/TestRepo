/*-----------------------------------------------------------------------------------------------
        NAME: DBFileAdd.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Template to add file to database
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
USE [master]
GO
ALTER DATABASE [database_name] 
  ADD FILE ( NAME = N'database_name_data_02'
           , FILENAME = N'R:\SQLData\database_name_data_02.ndf'
           , SIZE = 15360000KB
           , MAXSIZE = 102401024KB
           , FILEGROWTH = 1024000KB )
   TO FILEGROUP [PRIMARY]
GO

