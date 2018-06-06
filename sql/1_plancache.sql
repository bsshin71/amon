set feedback off;
set linesize 140;
set colsize 40;
set timing off;
  select   lpad(trunc(MAX_CACHE_SIZE/1024/1024)     , 20,' ') as "Max Plan Cache(MB)"
          ,lpad(trunc(CURRENT_CACHE_SIZE/1024/1024) , 20,' ') as "Used Plan Cache(MB)"
  from   V$SQL_PLAN_CACHE
--sqlend
;
