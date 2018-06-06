set timing off;
set feedback off
set linesize 180;
set pagesize 40
set colsize 25 
select
         rpad(trim(id)          ,9,  ' ')  AS "SessionID"
        ,rpad(trim(DB_USERNAME) ,15, ' ')  AS "Username"
        ,rpad( trim(event)      ,25, ' ')  AS "WaitEvent"
        ,rpad(CLIENT_APP_INFO   ,20, ' ')  AS "Program"
        ,rpad( trim(IP)         ,15, ' ')  AS "IP"
        ,rpad( WAIT_TIME        ,10, ' ')  AS "WaitTime(ms)"
from
(
   select
           vs.id 
         , vs.DB_USERNAME
         , vsw.event
         , vsw.WAIT_TIME
         , vs.CLIENT_APP_INFO
         , DECODE( INSTRB(vs.COMM_NAME,':'), 0, vs.COMM_NAME, replace( SUBSTRING(vs.COMM_NAME,1, INSTRB(vs.COMM_NAME,':')-1 ), 'TCP ','' ) ) as IP
    from v$session vs, v$session_wait vsw
    where vs.id = vsw.sid
    and   vsw.wait_time >=0
    order by vsw.wait_time
)    
--sqlend
;


