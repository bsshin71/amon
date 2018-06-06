set feedback off;
set timing off;
set linesize 180;
set colsize 30;
select 
        wait_class
       ,event
       ,time_waited
       ,total_waits
       ,total_timeouts
       ,average_wait
from v$system_event
order by time_waited desc
        ,total_waits desc
        ,wait_class
        ,event
--sqlend
;
