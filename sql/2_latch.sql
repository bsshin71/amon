set feedback off;
set linesize 140;
set colsize 20;
set timing off;
select
        b.name as tablespace_name
      , a.try_read_latch
      , a.read_miss
      , a.try_write_latch
      , a.write_miss
      , a.sleeps_cnt
from (
    select 
           a.space_id
          ,sum(a.try_read_latch)  try_read_latch
          ,sum(a.read_miss)       read_miss
          ,sum(a.try_write_latch) try_write_latch
          ,sum(a.write_miss)      write_miss
          ,sum(a.sleeps_cnt)      sleeps_cnt 
    from v$latch a  
    group by 
          a.space_id
   ) a,  v$tablespaces b    
where a.space_id = b.id
order by a.sleeps_cnt desc
--sqlend
;
