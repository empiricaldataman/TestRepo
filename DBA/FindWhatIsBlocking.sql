/*-----------------------------------------------------------------------------------------------
        NAME: FindWhatIsBlocking.sql
 MODIFIED BY: Sal Young
       EMAIL: saleyoun@yahoo.com
 DESCRIPTION: 
-------------------------------------------------------------------------------------------------
         DATE MODIFIED      DESCRIPTION    
-------------------------------------------------------------------------------------------------
   02.12.2012 SYoung        Initial creation.
-------------------------------------------------------------------------------------------------
  DISCLAIMER: The AUTHOR  ASSUMES NO RESPONSIBILITY  FOR ANYTHING, including  the destruction of 
              personal property, creating singularities, making deep fried chicken, causing your 
              toilet to  explode, making  your animals spin  around like mad, causing hair loss, 
			        killing your buzz or ANYTHING else that can be thought up.
-----------------------------------------------------------------------------------------------*/
:CONNECT <server_name, sysname, SQL_Server_Instance>

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT B.session_id [BlockingSessionID]
     , S.login_name [BlockingUser]
     , BSQL.[text] [BlockingSQL]
     , W.wait_type [WhyBlocked]
     , BL.session_id [BlockedSessionID]
     , USER_NAME(BL.[user_id]) [BlockedUSer]
     , BLSQL.[text] [BlockedSQL]
     , DB_NAME(BL.database_id) [DatabaseName]
  FROM sys.dm_exec_connections B
 INNER JOIN sys.dm_exec_requests BL ON B.session_id = BL.blocking_session_ID
 INNER JOIN sys.dm_os_waiting_tasks W ON BL.session_id = W.session_ID
 RIGHT JOIN sys.dm_exec_sessions S ON BL.session_ID = S.session_ID
 CROSS APPLY sys.dm_exec_sql_text(B.most_recent_sql_handle) BSQL
 CROSS APPLY sys.dm_exec_sql_text(BL.sql_handle) BLSQL
 ORDER BY BlockingSessionID, BlockedSessionID;
GO
