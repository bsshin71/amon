| 카테고리          | 메뉴명                                  | 기능                                                | sql파일명                    | 테스트된  Altibase버전 |
| ----------------- | --------------------------------------- | --------------------------------------------------- | ---------------------------- | ---------------------- |
| 1.General         | 11 - Instance/Database Info             | 인스턴스 및 DB 기본 정보                            | 1_instance.sql               | 5.3.5                  |
|                   | 12 - Parameter Info                     | default값에서 변경된 파라미터 조회                  | 1_parameter.sql              | 5.3.5                  |
|                   | 13 - Altibase Memory Info               | 메모리 사용량                                       | 1_memdata.sql                | 5.3.5                  |
|                   |                                         | 버퍼풀 사용량                                       | 1_buffinfo.sql               | 5.3.5                  |
|                   |                                         | 플랜캐쉬 사용량                                     | 1_plancache.sql              | 5.3.5                  |
|                   | 14 - Memory Usage by each module        | memstat 사용량                                      | 1_memstat.sql                | 5.3.5                  |
| 2.Cache & Latch   | 21 - Database Buffer Hit Ratio          | 버퍼캐쉬 히트율                                     | 2_bchr.sql                   | 5.3.5                  |
|                   | 22 - Shared Cache    Hit Ratio          | 플랜캐쉬 히트율                                     | 2_sharedcache.sql            | 5.3.5                  |
|                   | 23 - Latch Status by Each Tablespace    | 테이블스페이스별 latch 사용정보                     | 2_latch.sql                  | 5.3.5                  |
| 3.SESSION         | 31 - Current Session Info               | 세션 정보                                           | 3_current_session.sql        | 5.3.5                  |
|                   | 32 - Current Running Session Info       | Active 세션 정보                                    | 3_run_session.sql            | 5.3.5                  |
|                   | 33 - Current Running Session Wait Info  | Running 중인 세션의 wait 이벤트                     | 3_run_session_wait_5.sql     | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 34 - Running Session SQL Info           | Running 중인 세션의 SQL 구문 전체 조회              | 3_running_sql.sql            | 5.3.5                  |
|                   | 35 - Current Transaction                | 세션별로 실행중인 TX 및 TX 상태                     | 3_current_transaction_5.sql  | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 36 - Open Cursor                        | 세션별 statement  갯수                              | 3_open_cursor.sql            | 5.3.5                  |
| 4.WAIT EVENT/LOCK | 41 - Current Lock Info                  | Lock 이 잡힌 객체 조회                              | 4_lockobj_5.sql              | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 42 - Hierarchical Lock Inf              | Lock 대기상태를 계층구조로 표시                     | 4_hierarchical_lock_5.sql    | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 43 - System Event                       | 시스템 이벤트 Wait 정보                             | 4_system_event.sql           | 5.3.5                  |
|                   | 44 - Session Event                      | 세션별 이벤트 Wait 정보                             | 4_session_event.sh           | 5.3.5                  |
|                   |                                         |                                                     | 4_session_event.sql          | 5.3.5                  |
|                   | 45 - Session Wait                       | 세션별 Wait 이베벤트 및 대기시간                    | 4_session_wait_5.sql         | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 46 - Sysstat                            | sysstat                                             | 4_sysstat.sql                | 5.3.5                  |
|                   | 47 - Prepared Logfile Info              | Prepared Log 파일                                   | 4_preparedlogfile.sql        | 5.3.5                  |
| 5.SPACE           | 51 - Database File Info                 | 로그 앵커 경로                                      | 5_loganchor.sql              | 5.3.5                  |
|                   |                                         | 온라인로그 경로                                     | 5_logfile.sql                | 5.3.5                  |
|                   |                                         | 데이타파일별 경로 및 사용량                         | 5_datafile_5.sql             | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 52 - Tablespace Usage                   | 테이블스페이별 사용량                               | 5_tbs_5.sql                  | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 53 - Undo Space Total Usage             | Undo 테이블스페이스 사용량                          | 5_undousage_5.sq             |                        |
|                   |                                         |                                                     |                              |                        |
|                   | 54 - Undo Usage By Segment              | Undo세그먼트별 사용량                               | 5_undosegment_5.sql          | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 55 - Undo Activity                      | Undo 세그먼트 count                                 | 5_undoactivity_5.sql         | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 56 - Temp Space Total Usage             | Temp 테이블스페이스 사용량                          | 5_temp_tbs_5.sql             | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
| 6.I/O             | 61 - File I/O Info                      | 데이타파일명 I/O 상태                               | 6_fileio_5.sql               | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 62 - Session I/O Info                   | 미지원                                              | 6_session_io_5.sql           | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 63 - Archivelog info                    | 아카이브 로그 상태 / 시간대별 아카이빙 갯수(미지원) | 6_archivelog_5.sql           | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
| 7.OBJECT          | 71 - Schema Object Count                | 오브젝트별 갯수                                     | 7_object_count_5.sql         | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 72 - Object Invalid Count               | Invalid Object 갯수                                 | 7_invalid_count_5.sql        | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 73 - Invalid Object List                | Invalid Object 리스트                               | 7_invalid_object_5.sql       | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 74 - Segment Size(Top 50)               | 세그먼트 사용량 top 50                              | 7_segment_size_5.sql         | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
| 8.SQL             | 81 - SQL Plan(Input SQL_ID)             | Not Prepared yet                                    |                              |                        |
|                   | 82 - Top SQL                            | 실행시간 상위쿼리                                   | 8_topquery_by_elaptime_5.sql | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   |                                         | I/O 상위 쿼리                                       | 8_topquery_by_gets_5.sql     | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   |                                         | 실행횟수당 i/O 상위 쿼리                            | 8_topquery_by_elapexec_5.sql | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
|                   | 83 - Check Static Query Pattern         | 동일 유형별 쿼리 갯수                               | 8_check_static_query_5.sql   | 5.3.5                  |
|                   |                                         |                                                     |                              |                        |
| 9.Replication     | 91 - Replication Thread Status(Not yet) |                                                     |                              |                        |
|                   | 92 - Replication Info(Not yet)          |                                                     |                              |                        |
|                   | 93 - Replication Gap Info(Not yet)      |                                                     |                              |                        |
|                   | 94 - Replication TX Info(Not yet)       |                                                     |                              |                        |
| 0.OTHER           | M - Auto Refresh Monitoring(Not yet)    |                                                     |                              |                        |
|                   | S - Save To File(Not yet)               |                                                     |                              |                        |
