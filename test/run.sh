#!/bin/bash

BASE_DIR=/opt/madeira/env/lib/python2.7/site-packages/opsagent/state
PY_BIN=/opt/madeira/env/bin/python
EXE_BIN=${BASE_DIR}/adaptor.py
DATA_FILE=${BASE_DIR}/api.json

if [ ! -d "./log" ]
then
 echo "create log dir"
 mkdir -p ./log
fi

echo "---------------------------------------------------------------"
for line in `cat module.lst | grep -Ev "^#|^$" | awk '{print $1}'`
do	
  echo -e -n `date '+%Y-%m-%d %H:%M:%S' `" - start test '${line}'\t- "
  START_TIME=`date '+%s'`
  cp json/${line}.json ${DATA_FILE}
  if [ ! -f ${DATA_FILE} ]
  then
    echo "[error] can not found ${DATA_FILE}, cancel"
    break
  fi
  ${PY_BIN} ${EXE_BIN} 1>./log/${line}.out 2>./log/${line}.err
  END_TIME=`date '+%s'`
  #check result
  OUT_=`cat ./log/${line}.out|wc -l`
  ERR_=`cat ./log/${line}.err|wc -l`
  echo -e `expr ${END_TIME} - ${START_TIME}`"s\tout: ${OUT_}\t  err: ${ERR_}"
  cd ${BASE_DIR}/test
done

echo "---------------------------------------------------------------"
echo `date '+%Y-%m-%d %H:%M:%S' `" - all done"
echo "see detail log in log dir"
echo ""

