/*-------------------------------------------------------------------------------------------------
        NAME: SERVERPROPERTY.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: RETURNS PROPERTY INFORMATION ABOUT THE SQL SERVER INSTANCE
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

SELECT SERVERPROPERTY('BuildClrVersion')             [BuildClrVersion]             -- Version of the Microsoft .NET Framework CLR nvarchar(128) 
     , SERVERPROPERTY('Collation')                   [Collation]                   -- Name of the default collation for the server nvarchar(128)
     , SERVERPROPERTY('CollationID')                 [CollationID]                 -- ID of the SQL Server collation. int
     , SERVERPROPERTY('ComparisonStyle')             [ComparisonStyle]             -- Windows comparison style of the collation int
     , SERVERPROPERTY('ComputerNamePhysicalNetBIOS') [ComputerNamePhysicalNetBIOS] -- NetBIOS name nvarchar(128)
     , SERVERPROPERTY('Edition')                     [Edition]                     -- Installed product edition of the instance of SQL Server nvarchar(128)
     , SERVERPROPERTY('EditionID')                   [EditionID]                   -- The installed product edition of the instance of SQL Server. bigint
     , SERVERPROPERTY('EngineEdition')               [EngineEdition]               -- Database Engine edition of the instance of SQL Server installed on the server. int
     , SERVERPROPERTY('HadrManagerStatus')           [HadrManagerStatus]           -- Indicates whether the AlwaysOn Availability Groups manager has started.
     , SERVERPROPERTY('InstanceName')                [InstanceName]                -- Name of the instance to which the user is connected. nvarchar(128)
     , SERVERPROPERTY('IsClustered')                 [IsClustered]                 -- Server instance is configured in a failover cluster. int
     , SERVERPROPERTY('IsFullTextInstalled')         [IsFullTextInstalled]         -- The full-text and semantic indexing components are installed on the current instance of SQL Server. int
     , SERVERPROPERTY('IsHadrEnabled')               [IsHadrEnabled]               -- AlwaysOn Availability Groups is enabled on this server instance. int
     , SERVERPROPERTY('IsIntegratedSecurityOnly')    [IsIntegratedSecurityOnly]    -- Server is in integrated security mode. int
     , SERVERPROPERTY('IsLocalDB')                   [IsLocalDB]                   -- Server is an instance of SQL Server Express LocalDB.
     , SERVERPROPERTY('IsSingleUser')                [IsSingleUser]                -- Server is in single-user mode. int
     , SERVERPROPERTY('LCID')                        [LCID]                        -- Windows locale identifier (LCID) of the collation. int
     , SERVERPROPERTY('MachineName')                 [MachineName]                 -- Windows computer name on which the server instance is running. nvarchar(128)
     , SERVERPROPERTY('ProcessID')                   [ProcessID]                   -- Process ID of the SQL Server service. ProcessID is useful in identifying which Sqlservr.exe belongs to this instance. int
     , SERVERPROPERTY('ProductVersion')              [ProductVersion]              -- Version of the instance of SQL Server, in the form of 'major.minor.build.revision'. nvarchar(128)
     , SERVERPROPERTY('ProductLevel')                [ProductLevel]                -- Level of the version of the instance of SQL Server. nvarchar(128)
     , SERVERPROPERTY('ResourceLastUpdateDateTime')  [ResourceLastUpdateDateTime]  -- Date and time that the Resource database was last updated. datetime
     , SERVERPROPERTY('ResourceVersion')             [ResourceVersion]             -- Returns the version Resource database. nvarchar(128)
     , SERVERPROPERTY('ServerName')                  [ServerName]                  -- Both the Windows server and instance information associated with a specified instance of SQL Server. nvarchar(128)
     , SERVERPROPERTY('SqlCharSet')                  [SqlCharSet]                  -- The SQL character set ID from the collation ID. tinyint
     , SERVERPROPERTY('SqlCharSetName')              [SqlCharSetName]              -- The SQL character set name from the collation. nvarchar(128)
     , SERVERPROPERTY('SqlSortOrder')                [SqlSortOrder]                -- The SQL sort order ID from the collation tinyint
     , SERVERPROPERTY('SqlSortOrderName')            [SqlSortOrderName]            -- The SQL sort order name from the collation. nvarchar(128)
     , SERVERPROPERTY('FilestreamShareName')         [FilestreamShareName]         -- The name of the share used by FILESTREAM.
GO