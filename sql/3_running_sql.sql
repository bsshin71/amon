set feedback off;
set timing off;
set linesize 1024;
set colsize 64;
select
         lpad(id               ,10, ' ')   AS "SessionID"
        ,lpad(DB_USERNAME      ,10, ' ')   AS "Username"
        ,lpad(CLIENT_APP_INFO  ,10, ' ')   AS "Program"
        ,lpad(piece            ,10, ' ')   AS "Piece"
        ,rpad(replace2(text, chr(10), ''), 64, ' ')     AS "SQL"
from
(
 SELECT  vs.id
        ,vs.DB_USERNAME
        ,vst.piece
        ,vs.CLIENT_APP_INFO
        ,vst.text   
 FROM   v$session  vs 
      , v$sqltext  vst
 where  vs.TASK_STATE      = 'EXECUTING'
 and    vs.CURRENT_STMT_ID = vst.STMT_ID
 and    vs.id              = vst.SID
 order by vs.id, vst.piece
 LIMIT 100 
 )
--sqlend
;
