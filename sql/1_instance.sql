set feedback off;
set linesize 180;
set colsize 20;
set timing off;
select 
             d.db_name
            ,v.PRODUCT_VERSION 
            ,i.STARTUP_PHASE  
            ,n.NLS_CHARACTERSET
            ,decode(a.ARCHIVE_MODE,1,'Archive log', 'No archive log') as "Log Mode"
            ,decode(i.STARTUP_TIME_SEC, 0, '0', to_char( to_date('1970010109','YYYYMMDDHH') +   STARTUP_TIME_SEC/ (60*60*24), 'YYYY/MM/DD HH:MI:SS' ) ) as "DB Up time" 
from  v$database d
     ,v$version  v
     ,v$instance i
     ,( select NLS_CHARACTERSET
        from  v$nls_parameters 
        limit 1
      ) n
     , v$archive a
--sqlend
;
