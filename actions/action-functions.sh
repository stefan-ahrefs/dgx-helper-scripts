#!/bin/bash


export LOCAL_DGX_DIR=~/DGX
export LOCAL_ACTION_DIR=~/DGX/actions
export DUMP_DIR=/cm/shared/dumps
export WD=/cm/shared/stats

mkdir -p $DUMP_DIR $WD

logfilename(){
  LOGFILE="${DUMP_DIR}/$(date +%Y%m%d)-$1.txt"
  while [ -f "${LOGFILE}" ] ; do
    LOGFILE=${LOGFILE//.txt/_.txt}
  done
  echo "${LOGFILE}"
}

wait-for-file(){
  echo -n "Waiting for file $1 "
  while [ ! -f "$1" ] ; do sleep 5 ; echo -n . ; done
  echo " done"
}

scrin(){
  LOGFILENAME=$(logfilename "${1}")
  screen -dmS "${1}" bash -c "(echo $(date) Starting ${1} ; ${2} ; RESULT=\$? ; echo \$(date) Completed ${1} with exit code \$RESULT) > $LOGFILENAME.wip ; mv ${LOGFILENAME}.wip ${LOGFILENAME}"
}

