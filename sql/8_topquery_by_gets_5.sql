set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 1024;
SET COLSIZE 25;
!echo " ========  Top 10 SQL Ordered by gets ========="
select 
            rpad( ss.DB_USERNAME, 12, ' ') as USERNAME
          , lpad( round(st.GET_PAGE/(st.EXECUTE_SUCCESS + st.EXECUTE_FAILURE ),3), 15, ' ' )  "Gets/Exec"
          , lpad( round(st.total_time/1000000, 3), 15, ' ')  as "Elapsed_Tim(s)"
          , lpad( (st.EXECUTE_SUCCESS + st.EXECUTE_FAILURE ), 10, ' ') as "EXECUTIONS"
          , lpad( round(st.total_time /(st.EXECUTE_SUCCESS + st.EXECUTE_FAILURE )/1000000,3), 15, ' ')  as "Elap/Exec(s)"
          , substr( decode(ss.CLIENT_APP_INFO,'', CLIENT_TYPE , ss.CLIENT_APP_INFO ), 1, 10)  as "Client"
          , st.id AS STMT_ID
          , lpad( replace2( substring(ltrim(query), 1, 30), chr(10), '')  , 25, ' ')  as query 
from  
         V$STATEMENT st         
      ,  V$SESSION   ss
where 
      st.SESSION_ID  =  ss.ID
  and st.total_time >= 0
  and (st.EXECUTE_SUCCESS + st.EXECUTE_FAILURE ) > 0
order by 2 desc
limit 10
--sqlend
;
