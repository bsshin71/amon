set timing off;
set feedback off
set linesize 140;
set pagesize 30
set colsize  40;
select 
       lpad(lf_open_count         ,20,  ' ' )   "Opened LogFile Count"
      ,lpad(lf_prepare_count      ,20,  ' ' )   "Pre-created LogFile Count"
      ,lpad(lf_prepare_wait_count ,20,  ' ' )   "Wait count for creating Log File"
from V$LFG
--sqlend
;
