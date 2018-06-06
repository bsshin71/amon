set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 140;
SET COLSIZE 60;
select
            US.user_name
          , OBJECT_TYPE
          , 'INVALID' AS STATUS
          , lpad(CNT, 15, ' ') AS "COUNT"
from
(
        select 
                 user_id
               , decode(object_type, 0, 'PROCEDURE' 
                                   , 1, 'FUNCTION'
                                   , 3, 'TYPE SET' ) AS object_type
              ,count(*) AS CNT
        from system_.sys_procedures_
        where status=1
       group by user_id, object_type  
  union all
       select  T.user_id
              , decode(T.table_type, 'T', 'TABLE'   
                                   , 'S', 'SEQUENCE'
                                   , 'V', 'VIEW'
                                   , 'Q', 'QUEUE'
                                   , 'S', 'SEQUENCE'
                                   , T.table_type ) AS object_type
              , count(*) AS CNT
        from system_.sys_tables_  T, system_.SYS_VIEWS_  V
        where T.table_id = V.view_id and T.user_id = V.user_id
        and   V.status = 1
       group by T.user_id, T.table_type
    ) T, system_.sys_users_ US
where T.user_id = US.user_id
order by T.user_id, object_type
--sqlend
;
