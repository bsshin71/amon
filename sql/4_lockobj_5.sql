set feedback off;
set timing off;
set linesize 1024;
set colsize 30;
select
         lpad(LOCK_ITEM_TYPE      ,10, ' ')   AS "LockObJType"
        ,lpad(SID                 ,8, ' ')   AS "SID"
        ,lpad(DB_USERNAME         ,10, ' ')   AS "User"
        ,lpad(TBS_NAME            ,15, ' ')   AS "TableSpace"
        ,lpad(TABLE_NAME          ,10, ' ')   AS "Lock Table"
        ,lpad(LOCK_DESC           ,8, ' ')   AS "LockDesc"
        ,lpad(DATA_FILE           ,30, ' ')   AS "DataFile"
from
(
 select decode(LOCK_ITEM_TYPE, NULL, 'Abnormal', 'TBS', 'TableSpace', 'TBL', 'Table', 'DBF', 'DataFile', 'UNKNOWN' ) AS LOCK_ITEM_TYPE
       , vss.id            AS SID
       , vss.DB_USERNAME   AS DB_USERNAME
       , vts.name          AS TBS_NAME
       , tbl.table_name    AS TABLE_NAME
       , vlock.LOCK_DESC   AS LOCK_DESC
       , vdbf.name         AS DATA_FILE
 from  
       v$lock vlock 
       left   outer join system_.sys_tables_ tbl
              on vlock.table_oid  = tbl.table_oid
       left outer join v$tablespaces vts 
              on vlock.tbs_id     = vts.id
       left outer join v$statement  vst  
              on vlock.TRANS_ID = vst.TX_ID
       left outer join v$session   vss
              on vst.SESSION_ID = vss.id
       left outer join v$datafiles vdbf
              on vlock.dbf_id  = vdbf.id
 )
 LIMIT 100
--sqlend
;
