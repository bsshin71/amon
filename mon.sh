#!/bin/bash

#-------------------------------------------------------------------------------
# 2018.05.07 created by omegaman                       (Ver1.0)
#-------------------------------------------------------------------------------


# Message Function -----------------------------
pr_done(){
  echo "Press Enter Key to continue..."
}


pr_version()
{
  echo "============================="
  echo " Altibase Monitoring Script "
  echo "============================="
}

# Get sys user password from prompt
get_syspass(){
  stty -echo
  echo
  if [ $OS = "Linux" ] ; then
    echo -e "Enter SYS Password : \c"
  elif [ $OS = "SunOS" ] ; then
    if [ $OSVER = "5.10" ] ; then
      echo "Enter SYS Password : \c"
    else
      echo -n "Enter SYS Password : "
    fi
  else
    echo 'Enter SYS Password : \c'
  fi
  read PASS
  stty echo
}

# Check Altibase Version -----------------------
altibase_version_chk(){
    ALTI_VER_CHK=`$ISQL <<EOF
              set heading off;
              set feedback off;
              set timing off;
              select substring(PRODUCT_VERSION,1, 1) from v\\$VERSION; 
              exit;
EOF`


  MAJOR_ALTI_VER=`echo $ALTI_VER_CHK | cut -c 1-1`

  if [ $MAJOR_ALTI_VER -lt 5  ] ; then
     echo 'The lower version Than Aitbase 5 do not support yet'
     exit
  elif [  $MAJOR_ALTI_VER -lt 6  ] ; then
     echo 'Altibase 5'
     echo 'set colsize 10' > $MONITOR/sql/sqlid_format.sql
  elif [  $MAJOR_ALTI_VER -eq 7  ] ; then
     echo 'Altibase 7'
   #  echo 'column sql_id format 999999999999999' > $MONITOR/sql/sqlid_format.sql
  fi
 
}


# SQL Run Function ----------------------------
run_sql(){
  $ISQL -f $MONITOR/sql/$1 | grep -v ";" | awk 'BEGIN { prflag=0;} {
    checkhead=tolower($1);
    if(checkhead  ~ /sqlend/ ) {
        prflag=1;
        next;
    }

    if( prflag == 1 ) {
        print $0;
    }
}'

  echo
}

# SQL Run Function(Version) -------------------
run_sql_version(){

  dyn_sql_file=`echo $1"."$ALTI_VER_CHK | sed 's/ //g'|awk -F. '{printf "%s_%s.%s", $1,$3,$2}'`

  #echo $dyn_sql_file
  #read tm

if [ $OS = "SunOS" ] ; then
    if [ -n -e $MONITOR/sql/$dyn_sql_file  ] ; then
      echo
    else
      #echo "file not exist"
      dyn_sql_file=$1
    fi
else
  # file exist check
  if [ -e $MONITOR/sql/$dyn_sql_file  ] ; then
    echo
  else
    #echo "file not exist"
    dyn_sql_file=$1
  fi
fi

 echo "SQL File : " $dyn_sql_file

 $ISQL -f $MONITOR/sql/$dyn_sql_file | grep -v ";" | awk 'BEGIN { prflag=0;} {
    checkhead=tolower($1);
    if(checkhead  ~ /sqlend/ ) {
        prflag=1;
        next;
    }
    if(checkhead ~ /==/ ) {
        print $0; 
    } 
    if( prflag == 1 ) {
        print $0;
    }
}'

  echo

}



# Start monitor shell --------------------------
# Shell Check ----------------------------------
if [ $# -ne 0 ] ;  then
  echo
  echo " Altibase Monitoring Shell"
  echo " ---------------------"
  echo " Usage : $0 "
  echo " "
  echo
  exit
fi

# Configuration --------------------------------
MONITOR=./; export MONITOR
USER=sys; export USER
PASS=manager; export PASS
OS=`uname -s`; export OS
OSVER=`uname -r`; export OSVER
ALTI_VER_CHK=5 ; export ALTI_VER_CHK
ALTIBASE_PORT_NO=20300; export ALTIBASE_PORT_NO


# Message Printing -----------------------------
clear
pr_version

# Get sys user password  -----------------------
#get_syspass
ISQL="$ALTIBASE_HOME/bin/isql -s 127.0.0.1 -u $USER -P manager -silent"; export ISQL


# Altibase version check -----------------------
altibase_version_chk


#-----------------------------------------------

while true
do
clear
pr_version
echo "  Altibase Version :"$ALTI_VER_CHK "(column FORMAT: "`cat $MONITOR/sql/sqlid_format.sql`")"
echo " -----------------------------------------------------------------------------------"
echo "  1.GENERAL                               |  2.Cache & Latch                        "
echo " ---------------------------------------- + ----------------------------------------"
echo "  11 - Instance/Database Info             |  21 - Database Buffer Hit Ratio         "
echo "  12 - Parameter Info                     |  22 - Shared Cache    Hit Ratio         "
echo "  13 - Altibase Memory Info               |  23 - Latch Status by Each Tablespace   "
echo "  14 - Memory Usage by each module        |                                         "
echo " -----------------------------------------------------------------------------------"
echo "  3.SESSION                               |  4.WAIT EVENT/LOCK                      "
echo " ---------------------------------------- + ----------------------------------------"
echo "  31 - Current Session Info               |  41 - Current Lock Info                 "
echo "  32 - Current Running Session Info       |  42 - Hierarchical Lock Info            "
echo "  33 - Current Running Session Wait Info  |  43 - System Event                      "
echo "  34 - Running Session SQL Info           |  44 - Session Event                     "
echo "  35 - Current Transaction                |  45 - Session Wait                      "
echo "  36 - Open Cursor                        |  46 - Sysstat                           "
echo "                                          |  47 - Prepared Logfile Info             "
echo "                                          |                                         "
echo " -----------------------------------------------------------------------------------"
echo "  5.SPACE                                 |  6.I/O                                  "
echo " ---------------------------------------- + ----------------------------------------"
echo "  51 - Database File Info                 |  61 - File I/O Info                     "
echo "  52 - Tablespace Usage                   |  62 - Session I/O Info                  "
echo "  53 - Undo Space Total Usage             |  63 - Archivelog info                   "
echo "  54 - Undo Usage By Segment              |                                         "
echo "  55 - Undo Activity                      |                                         "
echo "  56 - Temp Space Total Usage             |                                         "
echo " -----------------------------------------------------------------------------------"
echo "  7.OBJECT                                |  8.SQL                                  "
echo " ---------------------------------------- + ----------------------------------------"
echo "  71 - Schema Object Count                |  81 - SQL Plan(Input SQL_ID)            "
echo "  72 - Object Invalid Count               |  82 - Top SQL                           "
echo "  73 - Invalid Object List                |  83 - Check Static Query Pattern        "
echo "  74 - Segment Size(Top 50)               |                                         "
echo "                                          |                                         "
echo " -----------------------------------------------------------------------------------"
echo "  9.Replication                           |  0.OTHER                                "
echo " ---------------------------------------- + ----------------------------------------"
echo "  91 - Replication Thread Status(Not yet) |  M - Auto Refresh Monitoring(Not yet)   "
echo "  92 - Replication Info(Not yet)          |  S - Save To File(Not yet)              "
echo "  93 - Replication Gap Info(Not yet)      |                                         "
echo "  94 - Replication TX Info(Not yet)       |  X - EXIT                               "
echo " -----------------------------------------------------------------------------------"
echo ""


if [ "$OS" = "Linux" ] ; then
   echo -e " Choose the Number or Command : \c "
elif [ $OS = "SunOS" ] ; then
  if [ $OSVER = "5.10" ] ; then
    echo ' Choose the Number or Command : \c '
  else
    echo -n " Choose the Number or Command : "
  fi
else
  echo ' Choose the Number or Command : \c '
fi
read i_number
case $i_number in

# 1.GENERAL ---------------------------------------

11)
clear
echo "============================"
echo " Altibase Instance Infomation "
echo "============================"
run_sql 1_instance.sql
pr_done
read tm
;;

12)
clear
echo "======================"
echo " Parameter Infomation "
echo "======================"
run_sql 1_parameter.sql
pr_done
read tm
;;

13)
clear
echo "====================="
echo " Memory Data Size Infomation "
echo "====================="
run_sql 1_memdata.sql


echo "====================="
echo " Disk Buffer Pool Infomation "
echo "====================="
run_sql 1_buffinfo.sql


echo "==============================="
echo " Plan Cache Infomation "
echo "==============================="
run_sql 1_plancache.sql
pr_done
read tm
;;

14)
clear
echo "======================"
echo " Memory Usage By Each Module Infomation "
echo "======================"
run_sql 1_memstat.sql
pr_done
read tm
;;


# 2.SHARED_MEMORY ---------------------------------

21)
clear
echo "==========================="
echo " Database Buffer Hit Ratio "
echo "==========================="
run_sql 2_bchr.sql
pr_done
read tm
;;

22)
clear
echo "========================"
echo " Shared Cache Hit Ratio "
echo "========================"
run_sql 2_sharedcache.sql
pr_done
read tm
;;

23)
clear
echo "========================"
echo " Latch Status by Each Tablespace "
echo "========================"
run_sql 2_latch.sql
pr_done
read tm
;;

31)
clear
echo "========================"
echo " Current Session Info   "
echo "========================"
run_sql_version 3_current_session.sql
pr_done
read tm
;;

32)
clear
echo "========================"
echo " Current Running Session Info   "
echo "========================"
run_sql_version 3_run_session.sql
pr_done
read tm
;;

33)
clear
echo "========================"
echo " Current Running Session Wait Info   "
echo "========================"
run_sql_version 3_run_session_wait.sql 
pr_done
read tm
;;

34)
clear
echo "========================"
echo "  Running Session SQL Info ( Limit 100 )  "
echo "========================"
run_sql_version 3_running_sql.sql 
pr_done
read tm
;;

35)
clear
echo "========================"
echo "  Current Transaction ( Limit 100 )  "
echo "========================"
run_sql_version 3_current_transaction.sql 
pr_done
read tm
;;

36)
clear
echo "========================"
echo "  Current Open Cursor ( Limit 100 )  "
echo "========================"
run_sql_version 3_open_cursor.sql 
pr_done
read tm
;;

41)
clear
echo "========================"
echo "   Current Lock Info ( Limit 100 )  "
echo "========================"
run_sql_version 4_lockobj.sql
pr_done
read tm
;;

42)
clear
echo "========================"
echo "   Hierarchical Lock Info ( Limit 100 )   "
echo "========================"
run_sql_version 4_hierarchical_lock.sql
pr_done
read tm
;;

43)
clear
echo "========================"
echo "   System Event          "
echo "========================"
run_sql_version 4_system_event.sql 
pr_done
read tm
;;

44)
clear
sh $MONITOR/sql/4_session_event.sh
clear
echo "==============="
echo " Session Event "
echo "==============="
run_sql 4_session_event.sql
pr_done
read tm
;;

45)
clear
echo "========================"
echo "   Session Wait         "
echo "========================"
run_sql_version 4_session_wait.sql 
pr_done
read tm
;;

46)
clear
echo "========================"
echo "   Sysstat              "
echo "========================"
run_sql_version 4_sysstat.sql 
pr_done
read tm
;;

47)
clear
echo "========================"
echo "   Prepared Logfile Info"
echo "========================"
run_sql_version 4_preparedlogfile.sql
pr_done
read tm
;;

51)
clear
echo "========================"
echo "  LogAnchor File Info"
echo "========================"
run_sql_version 5_loganchor.sql

echo "========================"
echo "  LogFile Info"
echo "========================"
run_sql_version 5_logfile.sql

echo "========================"
echo "  DataFile Info"
echo "========================"
run_sql_version 5_datafile.sql

pr_done
read tm
;;

52)
clear
echo "========================"
echo "   Tablespace Usage     "
echo "========================"
run_sql_version 5_tbs.sql
pr_done
read tm
;;

53)
clear
echo "========================"
echo "   Undo Space Total Usage   "
echo "========================"
run_sql_version 5_undousage.sql
pr_done
read tm
;;


54)
echo "========================"
echo "   Undo Usage By Segement "
echo "========================"
run_sql_version 5_undosegment.sql
pr_done
read tm
;;

55)
clear
echo "========================"
echo "   Undo Activity "
echo "========================"
run_sql_version 5_undoactivity.sql
pr_done
read tm
;;

56)
clear
echo "========================"
echo "   Temp Space Total Usage"
echo "========================"
run_sql_version 5_temp_tbs.sql
pr_done
read tm
;;

61)
clear
echo "========================"
echo "   File I/O Info        "
echo "========================"
run_sql_version 6_fileio.sql 
pr_done
read tm
;;

62)
clear
echo "========================"
echo "   Session I/O Info     "
echo "========================"
run_sql_version 6_session_io.sql  
pr_done
read tm
;;

63)
clear
echo "========================"
echo "   Archivelog info      "
echo "========================"
run_sql_version  6_archivelog.sql
pr_done
read tm
;;

71)
clear
echo "========================"
echo "   Schema Object Count  "
echo "========================"
run_sql_version 7_object_count.sql
pr_done
read tm
;;

72)
clear
echo "========================"
echo "   Object Invalid Count "
echo "========================"
run_sql_version 7_invalid_count.sql 
pr_done
read tm
;;

73)
clear
echo "========================"
echo "   Invalid Object List (MAX 100) "
echo "========================"
run_sql_version 7_invalid_object.sql 
pr_done
read tm
;;

74)
clear
echo "========================"
echo "   Segment Size(Top 50) "
echo "========================"
run_sql_version 7_segment_size.sql 
pr_done
read tm
;;

81)
clear
echo "========================"
echo "   SQL Plan(Input SQL_ID) "
echo "========================"
#run_sql_version 
echo " Not Prepared yet"
pr_done
read tm
;;

82)
clear
echo "========================"
echo "    Top SQL             "
echo "========================"
run_sql_version 8_topquery_by_elaptime.sql 
run_sql_version 8_topquery_by_gets.sql 
run_sql_version 8_topquery_by_elapexec.sql 
pr_done
read tm
;;


83)
clear
echo "========================"
echo "   Check Static Query Pattern (Top 50) "
echo "========================"
run_sql_version 8_check_static_query.sql 
pr_done
read tm
;;

x|X)
clear
echo "Good bye..."
echo
exit
;;


*)
echo
echo
echo
echo "You choose wrong number."
echo "Try Again.."
sleep 1
;;

esac

done
