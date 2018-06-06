!echo
!echo Select Session ID : 

set timing off;
set feedback off
set linesize 1024;
set pagesize 40
set colsize 30
select 
       sid
      ,wait_class
      ,event
      ,time_waited
      ,total_waits
      ,total_timeouts
      ,average_wait
      ,max_wait
from v$session_event
where sid in (  )
and   time_waited >= 0
order by time_waited desc
        ,total_waits desc
        ,wait_class
        ,event
--sqlend
;


