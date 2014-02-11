#!/bin/bash
##
## @author: Thibault BRONCHAIN
## (c) 2014 MadeiraCloud LTD.
##

# link salt files
rm -rf ${OA_ENV_DIR}/lib/${PYTHON}/site-packages/salt
ln -s ${OA_BOOT_DIR}/${OA_SALT}/${SRC_SOURCES_DIR}/salt ${OA_ENV_DIR}/lib/${PYTHON}/site-packages/salt
rm -f ${OA_ENV_DIR}/lib/${PYTHON}/site-packages/opsagent/state/adaptor.py
ln -s ${OA_BOOT_DIR}/${OA_SALT}/${SRC_SOURCES_DIR}/adaptor.py ${OA_ENV_DIR}/lib/${PYTHON}/site-packages/opsagent/state/adaptor.py
# EOF
