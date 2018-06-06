set feedback off;
set timing off;
set linesize 1024;
set colsize 64;
 select  vst.session_id
        , vss.DB_USERNAME
        , DECODE( INSTRB(COMM_NAME,':'), 0, COMM_NAME, replace( SUBSTRING(COMM_NAME,1, INSTRB(COMM_NAME,':')-1 ), 'TCP ','' ) ) as IP
        , count(*) "COUNT"
 from   v$statement vst
      , v$session   vss
 where  vss.id = vst.session_id
 group by  vst.session_id,  vss.DB_USERNAME, vss.COMM_NAME
 order by count(*) desc, vst.session_id
--sqlend
;
