set feedback off;
set linesize 140;
set colsize 40;
set timing off;
 select
           lpad(trunc(MEM_MAX_DB_SIZE/1024/1024),20,' ') as "Max Memory Data Size(MB)" 
          ,lpad(trunc(MEM_ALLOC_PAGE_COUNT * 32 * 1024 /1024/1024), 20, ' ') as "Current Alloc Data Size(MB)"
 from
          v$database    
--sqlend
;
