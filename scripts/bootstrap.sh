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
S_OA_PACKAGE_PATH=$(cat "$1" | grep "^package_path=" | cut -d '=' -f 2)
S_OA_BOOT_DIR=$(cat "$1" | grep "^root=" | cut -d '=' -f 2)
S_OA_SALT=$(cat "$1" | grep "^name=" | cut -d '=' -f 2)

# copy deps
chmod 755 ${S_OA_BOOT_DIR}/${S_OA_SALT}/libs/*
cp -rf ${S_OA_BOOT_DIR}/${S_OA_SALT}/libs/* ${S_OA_PACKAGE_PATH}/
