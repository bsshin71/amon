set timing off;
set pagesize 30
set linesize 180;
set colsize 50;

select
      rpad(name   , 50, ' ') "LogAnchor Dir"
    , rpad(value1 , 50, ' ') "Path"
from v$property 
where name = 'LOGANCHOR_DIR' 
--sqlend
;
