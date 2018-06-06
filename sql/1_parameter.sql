set feedback off;
set linesize 140;
set colsize 40;
set timing off;
select
        name
      , MEMORY_VALUE1  AS "Current Value"
      , DEFAULT_VALUE1 AS "Default Value" 
 from 
        x$property 
 where 
        MEMORY_VALUE1 <>  DEFAULT_VALUE1
--sqlend
;
