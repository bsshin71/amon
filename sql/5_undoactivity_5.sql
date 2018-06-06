set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 1024;
SET COLSIZE 30;
    select  'Online Undo Segment Count' AS CountType,  count(*) AS COUNT
    from  v$udsegs UD, v$tablespaces TS
    where UD.space_id = TS.ID
    and  TS.Type=7  
union all
    select  'Active Undo Segment Count' AS CountType,  count(*) AS COUNT
    from  v$udsegs UD, v$tablespaces TS
    where UD.space_id = TS.ID
    and  TS.Type=7   -- UNDO
    and  CUR_ALLOC_PAGE_ID  > 1
    and  TOTAL_EXTENT_COUNT > 0
--sqlend
;
