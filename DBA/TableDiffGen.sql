/*-----------------------------------------------------------------------------------------------
        NAME: TableDiff_Gen.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: Generate a tablediff.exe command. The query window must be running in SQLCMD mode.
-------------------------------------------------------------------------------------------------
         DATE MODIFIED      DESCRIPTION    
-------------------------------------------------------------------------------------------------
   06.22.2015 SYoung        Initial creation.
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
              killing your buzz or ANYTHING else that can be thought up.
-------------------------------------------------------------------------------------------------*/
:setvar sourceserver "<source_server>"
:setvar destinationserver "<target_server>"

:setvar database "<db_name>"
:setvar schema "<schema_name>"
:setvar table "<table_name>"
:!!tablediff.exe -sourceserver $(sourceserver) -sourcedatabase $(database) -sourceschema $(schema) -sourcetable $(table) -destinationserver $(destinationserver) -destinationdatabase $(database) -destinationschema $(schema) -destinationtable $(table) -c -f C:\temp\$(table).sql

