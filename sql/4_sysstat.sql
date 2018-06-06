set timing off;
set feedback off
set linesize 180;
set pagesize 30
set colsize  50;
select
        seqnum
       ,name
       ,lpad(trim(value), 20, ' ') as value
from v$sysstat
where value > 0
--sqlend
;


