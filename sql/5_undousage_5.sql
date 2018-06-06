set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 1024;
SET COLSIZE 30;
SELECT 
            NAME TBS_NAME                                                           -- TBS_NAME : 디스크 테이블스페이스 이름
          , TO_CHAR(D.MAX * PAGE_SIZE / 1024 /1024, '999,999,999') 'MAX(M)'         -- MAX(M) : 테이블스페이스 최대 크기
          , TO_CHAR(TOTAL_PAGE_COUNT*PAGE_SIZE/1024/1024, '999,999,999') 'TOTAL(M)' -- TOTAL(M) : 현재까지 할당된 총 페이지 크기
          , DECODE(TYPE, 7, TO_CHAR(  ( UD.USED+TSS.USED ) * T.PAGE_SIZE/1024/1024 , '999,999,999' ) /* UNDO */
                       , TO_CHAR((ALLOCATED_PAGE_COUNT*PAGE_SIZE)/1024/1024, '999,999,999')) 'ALLOC(M)' -- ALLOC(M) 
         , DECODE(TYPE, 3, TO_CHAR(NVL(DS.USED, 0)/1024/1024, '999,999,999'), 4, TO_CHAR(NVL(DS.USED, 0)/1024/1024, '999,999,999') /* SYS_TEMP */
                  , LPAD('-', 12)) 'USED(M)'   -- USED(M) : 사용 중인 페이지 중에서 데이터가 적재된 크기. TEMP와 UNDO 는 USED 를 구할 수없음.
         , DECODE(TYPE, 7, TO_CHAR( trunc(  ( NVL(UD.USED, 0) + NVL(TSS.USED,0) ) / D.MAX * 100 , 2) , '99.99') , /* UNDO */
                        3, TO_CHAR( trunc( NVL(DS.USED, 0)/(D.MAX *PAGE_SIZE) * 100, 2) , '99.99') , 
                        4, TO_CHAR( trunc( NVL(DS.USED, 0)/(D.MAX*PAGE_SIZE)* 100, 2), '99.99') , /* TEMP */
                         TO_CHAR( trunc( ALLOCATED_PAGE_COUNT / D.MAX * 100, 2) , '99.99') ) 'USAGE(%)'   -- USAGE(%) : MAX대비 USED. TEMP, UNDO 의 경우 MAX대비 ALLOC
         , DECODE(STATE, 1, 'OFFLINE', 2, 'ONLINE', 5, 'OFFLINE BACKUP', 6, 'ONLINE BACKUP', 128, 'DROPPED', 'DISCARDED') STATE -- STATE : 테이블스페이스 상태
         , D.AUTOEXTEND
FROM 
        V$TABLESPACES T LEFT OUTER JOIN (SELECT 
                                                   SPACE_ID , SUM(TOTAL_USED_SIZE)  USED
                                        FROM X$SEGMENT
                                        GROUP BY SPACE_ID ) DS ON DS.SPACE_ID = T.ID
                        LEFT OUTER JOIN ( SELECT
                                                   SPACE_ID , SUM(TOTAL_EXTENT_COUNT*PAGE_COUNT_IN_EXTENT) USED
                                          FROM  V$UDSEGS
                                          GROUP BY  SPACE_ID
                                         ) UD  ON T.ID = UD.SPACE_ID
                        LEFT OUTER JOIN ( SELECT
                                                   SPACE_ID, SUM(TOTAL_EXTENT_COUNT*PAGE_COUNT_IN_EXTENT) USED
                                          FROM  V$TSSEGS
                                          GROUP BY SPACE_ID
                                        ) TSS ON T.ID= TSS.SPACE_ID   
                                                             
       ,(SELECT SPACEID
              , SUM(DECODE(MAXSIZE, 0, CURRSIZE, MAXSIZE)) AS MAX
              , DECODE(MAX(AUTOEXTEND), 1, 'ON', 'OFF') 'AUTOEXTEND'
         FROM V$DATAFILES
         GROUP BY SPACEID
          ) D
WHERE T.ID = D.SPACEID
AND  T.TYPE = 7  -- UNDO
--sqlend
;
