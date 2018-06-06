set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 140;
SET COLSIZE 60;
select
            US.user_name
                , OBJECT_TYPE
                , CNT
from (
              select  user_id
                            , decode(table_type, 'T', 'TABLE'   
                                               , 'S', 'SEQUENCE'
                                               , 'V', 'VIEW'
                                               , 'Q', 'QUEUE'
                                               , 'S', 'SEQUENCE'
                                               , table_type ) AS object_type
                     , count(*) AS CNT
                from system_.sys_tables_
                where table_type not in ( 'W','M', 'A', 'G', 'D' ) 
                group by user_id, table_type
        union all
                select 
                        user_id
                      ,'INDEX' AS OBJECT_TYPE
                      , count(*) as CNT
                from  system_.sys_indices_ idx
                group by user_id
        union all
                select 
                       user_id
                       ,decode(object_type, 0, 'PROCEDURE' 
                                          , 1, 'FUNCTION'
                                          , 3, 'TYPE SET' ) AS object_type
                       ,count(*) AS CNT
                 from system_.sys_procedures_
                 group by user_id, object_type  
        union all
                select 
                          user_id
                        , 'DIRECTORY' AS OBJECT_TYPE
                        , count(*) AS CNT
                from system_.sys_directories_
                group by user_id 
        union all
                select
                        user_id
                       ,'TRIGGER' AS OBJECT_TYPE
                       ,count(*) AS CNT
                 from  system_.SYS_TRIGGERS_
                 group by user_id
        union all
                 select 
                         synonym_owner_id
                        ,'SYNONYM' AS OBJECT_TYPE
                        ,count(*) AS CNT
                 from system_.sys_synonyms_
                 where synonym_owner_id is not null
                 group by synonym_owner_id  
      ) T, system_.sys_users_ US
where T.user_id = US.user_id
and  US.user_name != 'SYSTEM_'
order by T.user_id
--sqlend
;
