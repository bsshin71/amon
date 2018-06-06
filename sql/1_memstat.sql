set feedback off;
set linesize 140;
set colsize 40;
set timing off;
  select 
            name
          , lpad(trunc(ALLOC_SIZE/1024/1024)     ,13 ,' ') as "Alloc(MB)"
          , lpad(trunc(MAX_TOTAL_SIZE/1024/1024) ,13 ,' ') as "MAX Total(MB)"
   from v$memstat
   order by 3 desc
--sqlend
;
