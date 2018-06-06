set timing off;
set linesize 180;
set colsize 50;
select
      name    "Online Redo Dir"
    , value1  "Path"
from v$property 
where name = 'LOG_DIR'
--sqlend
;
