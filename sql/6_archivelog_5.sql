set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 1024;
SET COLSIZE 60;

select 
           lpad( decode(ARCHIVE_MODE , 0, 'No Archive', 1, 'Archived')    , 10, ' ' ) AS "ArchiveMode"
          , lpad( decode(ARCHIVE_THR_RUNNING, 0, 'Stopped', 1, 'Running' ) , 10, ' ' ) AS "ArchiveThreadStatus"
          , rpad(ARCHIVE_DEST, 45, ' ' ) AS "ArchiveLogPath"
          , lpad(NEXTLOGFILE_TO_ARCH   ,10, ' ')  "NextLogFiletoArchive"
          , lpad(OLDEST_ACTIVE_LOGFILE ,10, ' ' )"OldestActiveLogFile"
          , CURRENT_LOGFILE       "CurrentOnlineLogFile"
from V$ARCHIVE;
select
       'The current version does not support this view yet(시간대별로 생성된 archivelog 갯수 표시 )!!!' as Message
from dual 

--sqlend
;
