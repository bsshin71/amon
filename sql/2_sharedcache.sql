set feedback off;
set linesize 140;
set colsize 40;
set timing off;
select
       lpad(trunc(max_cache_size/1024/1024),12, ' '    ) as "MAX CACHE (MB)"
      ,lpad(trunc(CURRENT_CACHE_SIZE/1024/1024),15, ' ') as  "CURRENT CACHE (MB)"
      ,lpad(CACHE_MISS_COUNT ,15, ' ')                   as "Cache Miss count"
      ,lpad( trunc(CACHE_MISS_COUNT/(CACHE_HIT_COUNT+CACHE_MISS_COUNT) * 100) || '%',15, ' ') as "Cache Miss Ratio"
from V$SQL_PLAN_CACHE
--sqlend
;
