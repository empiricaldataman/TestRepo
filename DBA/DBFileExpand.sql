/*-----------------------------------------------------------------------------------------------
        NAME: DBFileExpand.sql
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
USE [master]
GO
ALTER DATABASE [Archive_EDW] MODIFY FILE ( NAME = N'Archive_EDW_Data_07', SIZE = 102400000KB )
GO
ALTER DATABASE [Archive_EDW] MODIFY FILE ( NAME = N'Archive_EDW_Data_08', SIZE = 35840000KB )
GO
