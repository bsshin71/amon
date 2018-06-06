set feedback off;
set timing off;
set pagesize 30
SET LINESIZE 1024;
SET COLSIZE 30;
select
        tbs_name
      , file_name
      , lpad( PHYRDS   , 15, ' ' ) "PhysicalReads"
      , lpad( PHYWRTS  , 15, ' ' ) "PhysicalWrite"
      , lpad( readper  ,  5, ' ' ) "Read(%)"
      , lpad( writeper ,  5, ' ' ) "Write(%)"
      , lpad( tot_io   ,  5, ' ' ) "Total_IO(%)"
      , lpad( avgtime  , 15, ' ' ) "AvgTim(s)" 
from 
(
    select
           ts.name  as tbs_name
          ,df.NAME  as file_name
          ,fs.PHYRDS
          ,fs.PHYWRTS
          ,round((fs.PHYRDS/tot.rds)*100, 1) readper
          ,round((fs.PHYWRTS/decode(tot.wrts, 0, 1, tot.wrts))*100, 1) writeper
          ,round((fs.phyrds + fs.phywrts)/(tot.rds+tot.wrts)*100, 1) tot_io
          ,round(fs.avgiotim/1000,3) avgtime
    from v$datafiles   df
       , v$filestat    fs
       , v$tablespaces ts
       , ( select sum(PHYRDS) rds, sum(PHYWRTS) wrts from V$FILESTAT ) tot
    where df.id     = fs.FILEID
    and  df.SPACEID = fs.SPACEID
    and  df.SPACEID = ts.id   
)
order by 3
--sqlend
;
