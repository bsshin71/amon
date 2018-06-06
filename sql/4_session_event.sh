#!/bin/sh
#####  Create Session Event Select Query  #####
#echo $SHELL
#echo $OS
if [ $OS = "Linux" ] ; then
  echo -e "Enter Session ID (ex: 9,10,12) : \c "
elif [ $OS = "SunOS" ] ; then
  #echo -n "Enter Session ID (ex: 9,10,12) :  "
  echo "Enter Session ID (ex: 9,10,12) : \c "
else
  echo 'Enter Session ID (ex: 9,10,12) : \c '
fi

read SESSION_ID

echo "!echo
!echo Select Session ID : ${SESSION_ID}

set timing off;
set feedback off
set linesize 1024;
set pagesize 40
set colsize 30
select 
       sid
      ,wait_class
      ,event
      ,time_waited
      ,total_waits
      ,total_timeouts
      ,average_wait
      ,max_wait
from v\$session_event
where sid in ( ${SESSION_ID} )
and   time_waited >= 0
order by time_waited desc
        ,total_waits desc
        ,wait_class
        ,event
--sqlend
;

" > $MONITOR/sql/4_session_event.sql

exit 0
