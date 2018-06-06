set feedback off;
set timing off;
set linesize 1024;
set colsize 30;
select
         lpad(SESSION_ID               ,10, ' ')       AS "SessionID"
        ,lpad(DB_USERNAME              ,10, ' ')       AS "Username"
        ,lpad(TX_ID                    ,10, ' ')       AS "TXID"
        ,lpad(TX_STATUS                ,10, ' ')       AS "TX Status"
        ,lpad(lock_table               ,10, ' ')       AS "Lock Table"
        ,lpad(first_update_time        ,18, ' ')       AS "TX start"
        ,lpad(trunc(total)             ,10, ' ')       AS "Total(sec)"
        ,rpad(replace2(query, chr(10)  ,''), 30, ' ')  AS "SQL"
from
(
         SELECT 
                 tx.SESSION_ID
                ,vs.DB_USERNAME
                ,tx.ID TX_ID
                    ,decode(tx.STATUS,0,'BEGIN', 3, 'COMMIT', 4, 'ROLLBACK', 5, 'BLOCKED', 6, 'END' ) AS TX_STATUS
                    , ( select tb.table_name 
                        from   system_.sys_tables_ tb
                              ,v$lock              vlock 
                         where vlock.trans_id  = st.tx_id 
                           and vlock.TABLE_OID = tb.TABLE_OID
                        limit 1
                      ) lock_table
                    ,decode(tx.first_update_time, 0, '0', to_char(to_date('1970010109', 'YYYYMMDDHH') + tx.first_update_time /
                 (60*60*24), 'MM/DD HH:MI:SS')) first_update_time
                ,st.total_time/1000000 total
                ,substr(query, 1, 100) query
        FROM  v$TRANSACTION tx
            , v$STATEMENT   st left outer join v$session vs on st.session_id =  vs.id
            , v$lock        vlock
        WHERE tx.id = st.tx_id
        AND tx.session_id <> session_id()
        order by first_update_time asc, session_id
 )
 LIMIT 100
--sqlend
;
