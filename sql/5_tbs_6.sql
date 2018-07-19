set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 1024;
SET COLSIZE 30;
SELECT DECODE(TYPE, 3, 'SYSTEM TABLESPACE', 4, 'USER DATA TABLESPACE', 5, 'SYSTEM TABLESPACE', 6, 'USER TEMP TABLESPACE', 7, 'SYSTEM TABLESPACE') TBS_TYPE
     , NAME TBS_NAME                  -- TBS_NAME : 테이블스페이스 이름
     , TO_CHAR((D.MAX * PAGE_SIZE / 1024 /1024), '999,999,999') 'MAX(M)'    -- MAX(M)   : 테이블스페이스 최대 크기
     , TO_CHAR((TOTAL_PAGE_COUNT * PAGE_SIZE)/1024/1024, '999,999,999') 'TOTAL(M)'      -- TOTAL(M) : 현재까지 할당 받은 페이지의 합계.
     , DECODE(TYPE, 7, TO_CHAR((U.TOTAL_EXT_CNT*PROP.EXTENT_SIZE)/1024/1024, '999,999,999')
                     , TO_CHAR((ALLOCATED_PAGE_COUNT * PAGE_SIZE)/1024/1024, '999,999,999')) 'ALLOC(M)'--ALLOC(M):현재까지할당받은 페이지중'빈페이지'를제외한'사용중인페이지'만의 합계.
     , DECODE(TYPE, 3, TO_CHAR(NVL(DS.USED, 0)/1024/1024, '999,999,999'), 
                    4, TO_CHAR(NVL(DS.USED, 0)/1024/1024, '999,999,999'),
                    7, TO_CHAR(((U.TX_EXT_CNT+U.USED_EXT_CNT+U.UNSTEALABLE_EXT_CNT) * PROP.EXTENT_SIZE)/1024/1024, '999,999,999')
                     , LPAD('-', 12))'USED(M)'                                              -- USED(M)  : 사용 중인 페이지 중에서 데이터가 적재된 크기
     , DECODE(TYPE, 7, TO_CHAR((((U.TX_EXT_CNT+U.USED_EXT_CNT+U.UNSTEALABLE_EXT_CNT) * PROP.EXTENT_SIZE)/(D.MAX*PAGE_SIZE))*100, '99.99'),
                    3, TO_CHAR(NVL(DS.USED, 0)/(D.MAX*PAGE_SIZE)* 100, '99.99'),
                    4, TO_CHAR(NVL(DS.USED, 0)/(D.MAX*PAGE_SIZE)* 100, '99.99')
                     , TO_CHAR((ALLOCATED_PAGE_COUNT/D.MAX) * 100, '99.99')) 'USAGE(%)'     -- USAGE(%) : 사용량(MAX 대비 USED)
     , DECODE(STATE, 1, 'OFFLINE', 2, 'ONLINE', 5, 'OFFLINE BACKUP', 6, 'ONLINE BACKUP', 128, 'DROPPED', 'DISCARDED') STATE  -- STATE    : 테이블스페이스 상태
     , D.AUTOEXTEND
  FROM V$TABLESPACES T LEFT OUTER JOIN(SELECT SPACE_ID , SUM(TOTAL_USED_SIZE) USED
                                         FROM X$SEGMENT
                                        GROUP BY SPACE_ID) DS ON DS.SPACE_ID = T.ID
     , (SELECT SPACEID
             , SUM(DECODE(MAXSIZE, 0, CURRSIZE, MAXSIZE)) AS MAX
             , DECODE(MAX(AUTOEXTEND), 1, 'ON', 'OFF') 'AUTOEXTEND'
          FROM V$DATAFILES
         GROUP BY SPACEID ) D
     , V$DISK_UNDO_USAGE U
     , (SELECT VALUE1 EXTENT_SIZE
          FROM V$PROPERTY
         WHERE NAME = 'SYS_UNDO_TBS_EXTENT_SIZE') PROP
 WHERE T.ID = D.SPACEID 
--sqlend
;
