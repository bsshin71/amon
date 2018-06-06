set feedback off;
set timing off;
set linesize 1024;
set colsize  15;
select 
         lpad(id              ,10, ' ')   AS "SessionID"
        ,lpad(DB_USERNAME     ,10, ' ')   AS "Username"
        ,lpad(Active_Flag     ,10, ' ')   AS "ActiveFlag"
        --,lpad(IP              ,16, ' ')   AS "IPaddr"
        ,IP                               AS "IPaddr"
        ,lpad(LOGIN_TIME      ,15, ' ')   AS "LogonTime"
        ,lpad(CLIENT          ,10, ' ')   AS "Program"
        ,lpad(CURRENT_STMT_ID , 9, ' ')   AS "CurrentStmt"
        ,lpad( CLIENT_PID     , 9, ' ')   AS "ClientPid"
        ,lpad(AUTOCOMMIT_FLAG ,10, ' ')   AS "AutoCommit"
        ,TASK_STATE   
from
(
 SELECT  id               
        ,DB_USERNAME      
        ,Active_Flag   
        ,TASK_STATE 
        ,DECODE( INSTRB(COMM_NAME,':'), 0, COMM_NAME, replace( SUBSTRING(COMM_NAME,1, INSTRB(COMM_NAME,':')-1 ), 'TCP ','' ) )  as   IP
        ,decode( LOGIN_TIME, 0, '0', to_char( to_date('1970010109','YYYYMMDDHH') +   LOGIN_TIME/ (60*60*24), 'MM/DD HH:MI:SS' ) )  as LOGIN_TIME
	,substr( decode( CLIENT_APP_INFO,'', CLIENT_TYPE , CLIENT_APP_INFO ), 1, 10)  as CLIENT
        ,CLIENT_APP_INFO 
        ,CLIENT_TYPE   
        ,CURRENT_STMT_ID
        ,CLIENT_PID 
        ,AUTOCOMMIT_FLAG 
 FROM   v$session
 where  ACTIVE_FLAG = 1
 order by 1, 4
 )
--sqlend
;
