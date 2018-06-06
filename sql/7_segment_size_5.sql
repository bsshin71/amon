set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 180;
SET COLSIZE 35;
 select 
         vts.name        as "TableSpace Name"
       , tbl.table_name  as "Table Name"
       , lpad(vseg.segment_type,15, ' ') AS "Segment Type"
       , lpad(xseg.TOTAL_EXTENT_COUNT,15 , ' ') AS TOTAL_EXTENT_COUNT
       , lpad(trunc(xseg.TOTAL_USED_SIZE/1024/1024,2), 15, ' ') AS "Used(MB)"
 from   v$segment            vseg
      , x$segment            xseg
      , v$tablespaces        vts
      , system_.sys_tables_  tbl
 where  vseg.space_id  = vts.id
   and vseg.table_oid   = tbl.table_oid
   and vseg.SEGMENT_PID = xseg.SEGMENT_PID
   and vseg.space_id    = xseg.space_id
   and vseg.table_oid   = xseg.table_oid
order by xseg.TOTAL_EXTENT_COUNT desc
limit 50
--sqlend
;
