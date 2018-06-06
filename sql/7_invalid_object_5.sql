set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 180;
SET COLSIZE 50;
select
            US.user_name
          , OBJECT_TYPE
          , OBJECT_NAME
          , 'INVALID' AS STATUS
          , T.LAST_DDL_TIME
from
(
        select
                 user_id
               , decode(object_type, 0, 'PROCEDURE'
                                   , 1, 'FUNCTION'
                                   , 3, 'TYPE SET' ) AS object_type
                ,PROC_NAME AS OBJECT_NAME
                ,to_char(LAST_DDL_TIME, 'YYYY/MM/DD HH:MI:SS') AS LAST_DDL_TIME
        from system_.sys_procedures_
        where status=1
  union all
       select  T.user_id
              , decode(T.table_type, 'T', 'TABLE'
                                   , 'S', 'SEQUENCE'
                                   , 'V', 'VIEW'
                                   , 'Q', 'QUEUE'
                                   , 'S', 'SEQUENCE'
                                   , T.table_type ) AS object_type
              , TABLE_NAME  AS OBJECT_NAME
              , to_char(LAST_DDL_TIME, 'YYYY/MM/DD HH:MI:SS') AS LAST_DDL_TIME
        from system_.sys_tables_  T, system_.SYS_VIEWS_  V
        where T.table_id = V.view_id and T.user_id = V.user_id
        and   V.status = 1
    ) T, system_.sys_users_ US
where T.user_id = US.user_id
order by T.user_id, object_type
LIMIT 100
--sqlend
;
