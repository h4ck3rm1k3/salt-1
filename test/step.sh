#!/bin/bash

no=$1

BASE_DIR=/opt/madeira/env/lib/python2.7/site-packages/opsagent/state
PY_BIN=/opt/madeira/env/bin/python
EXE_BIN=${BASE_DIR}/adaptor.py

if [ $# -ne 1 ]
then
  echo "usage: ./step.sh n # n>=1"
  echo ""
  i=0
  cat module.lst | grep -Ev "^#|^$" | grep -n ""
  echo ""
  exit
fi

echo ""

i=1
for line in `cat module.lst | grep -Ev "^#|^$" | awk '{print $1}'`
do
  if [ "${i}" == "${no}" ]
  then
    echo `date '+%Y-%m-%d %H:%M:%S' `" - start test '${line}'"
    echo "- test json ---------------------------------------"
    cp json/${line}.json ${BASE_DIR}/api.json
    cat json/${line}.json
    echo "- result ---------------------------------------"
    ${PY_BIN} ${EXE_BIN}
    break
  fi
  i=`expr $i + 1`
done

echo "-------------------------------------------"
echo `date '+%Y-%m-%d %H:%M:%S' `" - done"
echo ""

