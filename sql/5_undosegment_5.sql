set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 1024;
SET COLSIZE 30;
select 
       TS.name, 
       seg_pid, 
       to_char( trunc( (TOTAL_EXTENT_COUNT * PAGE_COUNT_IN_EXTENT ) * TS.PAGE_SIZE/1024/1024 ,1), '9999999999.9' ) "Alloc(M)" 
from  v$udsegs UD, v$tablespaces TS
where UD.space_id = TS.ID
and  TS.Type=7   -- UNDO
and  TOTAL_EXTENT_COUNT > 0
order by TOTAL_EXTENT_COUNT desc
--sqlend
;
