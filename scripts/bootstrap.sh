#!/bin/bash
##
## @author: Thibault BRONCHAIN
## (c) 2014 MadeiraCloud LTD.
##

if [ ! -f "$1" ]; then
    echo "Config file '$1' unavailable" 1>&2
    exit 1
fi

DOCKER_DEB_VERSION="1.2.0-0"
DOCKER_RPM_VERSION="1.2.0-1"

# get variables
S_OA_PACKAGE_PATH=$(cat "$1" | grep "^package_path=" | cut -d '=' -f 2)
S_OA_BOOT_DIR=$(cat "$1" | grep "^root=" | cut -d '=' -f 2)
S_OA_SALT=$(cat "$1" | grep "^name=" | cut -d '=' -f 2)
S_OA_CONF_DIR=$(cat "$1" | grep "^conf_path=" | cut -d '=' -f 2)

# get platform
S_PLATFORM=$(cat "$1" | grep "^platform=" | cut -d '=' -f 2)
if [ "$S_PLATFORM" = "" ]; then
    if [ $(which apt-get 2>/dev/null) ]; then
        S_PLATFORM="APT"
    elif [ $(which yum 2>/dev/null) ]; then
        S_PLATFORM="YUM"
    fi
fi

# copy deps
chmod 755 ${S_OA_BOOT_DIR}/${S_OA_SALT}/libs/*
cp -rf ${S_OA_BOOT_DIR}/${S_OA_SALT}/libs/{docker,mock.py,requests,six.py,websocket.py} ${S_OA_PACKAGE_PATH}/
if [ "$S_PLATFORM" = "APT" ]; then
    cp -f ${S_OA_BOOT_DIR}/${S_OA_SALT}/libs/docker-pkg/docker_${DOCKER_DEB_VERSION}_all.deb ${S_OA_CONF_DIR}/docker.deb
elif [ "$S_PLATFORM" = "YUM" ]; then
    cp -f ${S_OA_BOOT_DIR}/${S_OA_SALT}/libs/docker-pkg/docker-${DOCKER_RPM_VERSION}.x86_64.rpm ${S_OA_CONF_DIR}/docker.rpm
fi
