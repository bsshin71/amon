set feedback off;
set linesize 140;
set colsize 40;
set timing off;

  select
          round((GET_PAGES + FIX_PAGES - READ_PAGES) / ( GET_PAGES + FIX_PAGES), 2) * 100 || '%' as "Hit Ratio"
  from   V$BUFFPOOL_STAT
--sqlend
;
