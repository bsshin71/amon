set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 1024;
SET COLSIZE 62;
select
         'Pattern #' || rownum  AS pattern_no
         , STMT_ID
         , replace2( replace2(SQL_PATTERN, chr(10), '' ), chr(9), ' ')  AS SQL_PATTERN
         , lpad(CNT, 14, ' ') AS CNT
from
(
    select  
            substr(query, 1, 61) as SQL_PATTERN
          , min(id) AS STMT_ID
          , count(*) AS CNT
    from v$statement
    group by substr(query, 1, 61)
    having count(*) > 3
    order by 3 desc
) 
limit 50
--sqlend
;
