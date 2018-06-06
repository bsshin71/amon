set timing off;
set pagesize 30;
set linesize 1024;
set colsize 50;
select
                 rpad(tablespacename   ,20, ' ')  "Tablespace Name"
                 ,rpad(datafilename    ,50, ' ')   "FileName"
                 ,lpad(initsize        ,10, ' ')   "InitSize(M)"
                 ,lpad(maxsize         ,10, ' ')   "MaxSize(M)"
                 ,lpad(currsize        ,10, ' ')   "CurrentSize(M)"
                 ,lpad(autoextend      ,10, ' ')   "AutoExtendMode"
                 ,lpad(state           ,10, ' ')   "State"
from (
                select 
                         vts.name  as tablespacename
                        ,vdf.name  as datafilename
                        ,trunc(vdf.initsize*8192/1024/1024,1)  as initsize
                        ,trunc(vdf.maxsize*8192/1024/1024 , 1) as maxsize
                        ,trunc(vdf.currsize*8192/1024/1024, 1) as currsize
                        ,decode(vdf.autoextend , 0, 'NO-AUTO', 'AUTO' ) as autoextend
                        ,decode(vdf.state, 1, 'Offline', 2, 'Online', 3, 'Backuping', 128, 'Dropped', 'N/A' ) as state
                from v$tablespaces vts, v$datafiles vdf
                where vts.id = vdf.spaceid
        order by tablespacename, currsize       
)
--sqlend
;
