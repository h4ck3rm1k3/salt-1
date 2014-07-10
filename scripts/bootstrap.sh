#!/bin/bash
##
## @author: Thibault BRONCHAIN
## (c) 2014 MadeiraCloud LTD.
##

if [ ! -f "$1" ]; then
    echo "Config file '$1' unavailable" 1>&2
    exit 1
fi

# get variables
OA_PACKAGE_PATH=$(cat "$1" | grep "package_path=" | cut -d '=' -f 2)
OA_BOOT_DIR=$(cat "$1" | grep "root=" | cut -d '=' -f 2)
OA_SALT=$(cat "$1" | grep "salt=" | cut -d '=' -f 2)
OA_LIB=${OA_BOOT_DIR}/${OA_SALT}/libs

# copy deps
chmod 755 ${OA_BOOT_DIR}/${OA_SALT}/libs/*
cp -rf ${OA_BOOT_DIR}/${OA_SALT}/libs/* ${OA_PACKAGE_PATH}/
