#!/bin/bash
##
## @author: Thibault BRONCHAIN
## (c) 2014 MadeiraCloud LTD.
##

if [ ! -f "$1" ]; then
    echo "Config file '$1' unavailable" 1>&2
    exit 1
fi

DOCKER_DEB_VERSION="1.3.1-0"
DOCKER_RPM_VERSION="1.3.1-1"

# get variables
S_OA_PACKAGE_PATH=$(cat "$1" | grep "^package_path=" | cut -d '=' -f 2)
S_OA_BOOT_DIR=$(cat "$1" | grep "^root=" | cut -d '=' -f 2)
S_OA_SALT=$(cat "$1" | grep "^name=" | cut -d '=' -f 2)
S_OA_CONF_DIR=$(cat "$1" | grep "^conf_path=" | cut -d '=' -f 2)
S_OA_GPG_KEY_URI=$(cat "$1" | grep "^gpg_key_uri=" | cut -d '=' -f 2)
S_OA_BASE_REMOTE_DEFAULT="https://s3.amazonaws.com/opsagent"
S_OA_BASE_REMOTE=$(cat "$1" | grep "^base_remote=" | cut -d '=' -f 2)
if [ "$BASE_REMOTE" = "" ]; then
    S_OA_BASE_REMOTE=$S_OA_BASE_REMOTE_DEFAULT
fi
S_OA_GPG_KEY="${S_OA_CONF_DIR}/madeira.gpg.public.key"

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
    wget -nv ${S_OA_BASE_REMOTE}/docker/docker_${DOCKER_DEB_VERSION}_all.deb -O ${S_OA_CONF_DIR}/docker.deb
    wget -nv ${S_OA_BASE_REMOTE}/docker/docker_${DOCKER_DEB_VERSION}_all.deb.cksum -O ${S_OA_CONF_DIR}/docker.deb.cksum
    DOCKER_NAME="docker.deb"
#    cp -f ${S_OA_BOOT_DIR}/${S_OA_SALT}/libs/docker-pkg/docker_${DOCKER_DEB_VERSION}_all.deb ${S_OA_CONF_DIR}/docker.deb
elif [ "$S_PLATFORM" = "YUM" ]; then
    wget -nv ${S_OA_BASE_REMOTE}/docker/docker-${DOCKER_RPM_VERSION}.x86_64.rpm -O ${S_OA_CONF_DIR}/docker.rpm
    wget -nv ${S_OA_BASE_REMOTE}/docker/docker-${DOCKER_RPM_VERSION}.x86_64.rpm.cksum -O ${S_OA_CONF_DIR}/docker.rpm.cksum
    DOCKER_NAME="docker.rpm"
#    cp -f ${S_OA_BOOT_DIR}/${S_OA_SALT}/libs/docker-pkg/docker-${DOCKER_RPM_VERSION}.x86_64.rpm ${S_OA_CONF_DIR}/docker.rpm
fi

# get docker package
if [ "$DOCKER_NAME" != "" ]; then
    cd ${S_OA_CONF_DIR}
    REF_CKSUM="$(cat ${S_OA_CONF_DIR}/${DOCKER_NAME}.cksum | cut -d ' ' -f 1,2)"
    CUR_CKSUM="$(cksum ${DOCKER_NAME} | cut -d ' ' -f 1,2)"
    cd -
    if [ "$REF_CKSUM" != "$CUR_CKSUM" ]; then
        echo "FATAL: Checksum failed on ${DOCKER_NAME}" >&2
        exit 2
    fi

    chmod 640 ${S_OA_CONF_DIR}/${DOCKER_NAME}

#    gpg --no-tty --import ${OA_GPG_KEY}
#    rm -f ${S_OA_CONF_DIR}/${DOCKER_NAME}
#    gpg --no-tty --verify ${S_OA_CONF_DIR}/${DOCKER_NAME}.gpg
#    if [ $? -eq 0 ]; then
#        gpg --no-tty --output ${S_OA_CONF_DIR}/${DOCKER_NAME} --decrypt ${S_OA_CONF_DIR}/${DOCKER_NAME}.gpg
#        chmod 640 ${S_OA_CONF_DIR}/${DOCKER_NAME}
#    else
#        echo "FATAL: couldn't verify ${DOCKER_NAME}.gpg" >&2
#        exit 1
#    fi
fi
