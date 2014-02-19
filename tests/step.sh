#!/bin/bash


## variable ########################################
BASE_DIR=/opt/madeira/env/lib/python2.7/site-packages/opsagent/state
PY_BIN=/opt/madeira/env/bin/python
EXE_BIN=${BASE_DIR}/adaptor.py

JSON[1]=basic
JSON[2]=complex
JSON[3]=combo
JSON_TYPE=""


## function ########################################
function show_usage(){
  echo "========================================================="
  echo "usage: ./step.sh [type]"
  echo "---------------------------------------------------------"
  echo "[ type ] : "
  echo -e " 1 basic	( single module with required parameter test )"
  echo -e " 2 complex	( single module complex test )"
  echo -e " 3 combo	( multiple module complex test )"
  echo "========================================================="
  exit 1
}

function check_type(){
  TYPE_=$1
  if [ ${TYPE_} -lt 1 -o ${TYPE_} -gt 3 ]
  then
    echo ""
    echo "type must be 1,2 or 3"
    echo ""
    show_usage
  fi  
}

function show_module_list(){
  echo "========================================================="
  echo "usage: ./step.sh ${TYPE_} n #n>=1"
  echo "---------------------------------------------------------"
  echo "[ n ] : "
  cat json/module_${JSON_TYPE}.lst | grep -Ev "^#|^$" | grep -n ""
  echo "========================================================="
  exit
}

function do_module_test(){
  i=1
  for line in `cat json/module_${JSON_TYPE}.lst | grep -Ev "^#|^$" | awk '{print $1}'`
  do
    if [ "${i}" == "${NO_}" ]
    then
      echo `date '+%Y-%m-%d %H:%M:%S' `" - start test '${line}'"
      if [ -f json/${JSON_TYPE}/${line}.json ]
      then
        echo "- test json ---------------------------------------"
        cp json/${JSON_TYPE}/${line}.json ./state.json
        cat json/${JSON_TYPE}/${line}.json
        echo "- result ---------------------------------------"
        ${PY_BIN} ${EXE_BIN}
      else
        echo "!!! can not found json/${JSON_TYPE}/${line}.json !!!"
      fi
      break
    fi
    i=`expr $i + 1`
  done
}


#### main ###########################################
## check parameter count
if [ $# -ne 1 -a $# -ne 2 ]
then
  show_usage
fi

## check type
check_type $1
case ${TYPE_} in
  1)  JSON_TYPE=${JSON[1]}
      ;;
  2)  JSON_TYPE=${JSON[2]}
      ;;
  3)  JSON_TYPE=${JSON[3]}
      ;;
esac

##show module list for type
if [ $# -eq 1 ]
then
  show_module_list ${TYPE_}
fi

## module number
NO_=$2

## start test module
echo `date '+%Y-%m-%d %H:%M:%S' `
echo "==========================================="
do_module_test
echo "==========================================="
echo `date '+%Y-%m-%d %H:%M:%S' `" - done"
echo ""

