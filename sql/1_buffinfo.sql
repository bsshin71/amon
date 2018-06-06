set feedback off;
set linesize 140;
set colsize 40;
set timing off;
  select  
          trunc( POOL_SIZE * PAGE_SIZE /1024/1024 ) as "DB Buffer (MB)" 
  from V$BUFFPOOL_STAT
--sqlend
;
