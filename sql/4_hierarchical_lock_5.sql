set feedback off;
set timing off;
set linesize 1024;
set colsize 60;
select
          WL.TLEVEL            AS "LEVEL"
         ,VS.ID                AS "Session"
         ,WL.level_transid     AS "TX_ID"
         ,WL.wait_for_trans_id AS "WAIT TX_ID"
from
  V$session VS
 ,
    (   select session_id
              ,id  as TX_ID
        from  v$transaction
        group by session_id, id
     ) VXT
,
    (
        select
                level as TLEVEL
              , lpad( ' ', 5 * (level-1) )  || X.trans_id  AS level_transid
              , X.trans_id
              , X.wait_for_trans_id
        from X$lock_wait X
        start with X.trans_id = ( 
                                     select trans_id
                                     from v$lock_wait 
                                     where wait_for_trans_id not in ( select trans_id from v$lock_wait )
                                )
        connect by
                prior X.trans_id = X.WAIT_FOR_TRANS_ID
                IGNORE LOOP
        order by level
    ) WL
where WL.trans_id = VXT.TX_ID
 and  VXT.session_Id = VS.ID
 LIMIT 100
--sqlend
;
