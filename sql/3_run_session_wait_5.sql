set feedback off;
set timing off;
set linesize 1024;
set colsize  20;
select 
         lpad(id              ,10, ' ')   AS "SessionID"
        ,lpad(DB_USERNAME     ,10, ' ')   AS "Username"
        ,lpad(TASK_STATE      ,10, ' ')   AS "Status"
        ,lpad(CLIENT_APP_INFO ,10, ' ')   AS "Program"
        ,lpad(CLIENT_TYPE     , 9, ' ')   AS "ClientType"
        ,lpad(CURRENT_STMT_ID , 9, ' ')   AS "CurrentStmt"
        ,rpad( trim(query)     ,20, ' ')  AS "Query" 
        ,rpad( trim(event)     ,20, ' ')  AS "WaitEvent"
        ,rpad( second_in_time  ,10, ' ')  AS "WaitTime(Sec)"
from
(
 SELECT  ss.id               
        ,ss.DB_USERNAME      
        ,ss.Active_Flag   
        ,ss.TASK_STATE 
        ,DECODE( INSTRB(ss.COMM_NAME,':'), 0, ss.COMM_NAME, replace( SUBSTRING(ss.COMM_NAME,1, INSTRB(ss.COMM_NAME,':')-1 ), 'TCP ','' ) )  as   IP
        ,decode( ss.LOGIN_TIME, 0, '0', to_char( to_date('1970010109','YYYYMMDDHH') +   ss.LOGIN_TIME/ (60*60*24), 'YYYY/MM/DD HH:MI:SS' ) )  as LOGIN_TIME
        ,ss.CLIENT_APP_INFO 
        ,ss.CLIENT_TYPE   
        ,ss.CURRENT_STMT_ID
        ,ss.CLIENT_PID 
        ,ss.AUTOCOMMIT_FLAG 
        ,sw.event 
        ,sw.second_in_time
        ,replace2( substring(st.query, 1, 10) ,chr(10),'')  as query
 FROM   v$session  ss left outer join v$session_wait sw on ss.id = sw.sid
      , v$statement st
 where  ss.TASK_STATE      = 'EXECUTING' 
 and    ss.CURRENT_STMT_ID = st.id
 and    ss.id              = st.session_id 
 )
--sqlend
;
