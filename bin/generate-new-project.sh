#!/bin/bash -x

#### ------------------------------------- ####
#### ---- Docker:Generate:New Porject ---- ####
#### ---- App:Specification:          ---- ####
#### 1.) Collect new Project Info   
####   NEW_PROJECT_DIR
#### ------------------------------------- ####

function usage() {
    if [ $# -lt 1 ]; then
        echo "-- Usage: $(basename $0) <New-Docker-Project-Directory> "
        echo "e.g."
        echo "    $(basename $0) ~/Docker-Projects/My-New-Docker"
        echo "(Note) New Docker project name can only be ALL-lower-cased"
        echo "       This is due to the constaints from Docker Engine!"
        exit 1
    fi
}
usage $*

env
whoami
pwd

## ----------------------- ##
## -- Prepare variables -- ##
## ----------------------- ##
DEST_PROJ_DIR=${1:-$HOME/docker-generated/$(date +%F)}
function setupDestDir() {
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    SRC_PROJ_DIR=$(dirname $DIR)
    DEST_PROJ_DIR=${1:-$HOME/docker-generated}
    if [ "$(dirname ${DEST_PROJ_DIR})" == "" ]; then
        DEST_PROJ_DIR=`pwd`/${DEST_PROJ_DIR}
    else
        DEST_PROJ_DIR=$(realpath ${DEST_PROJ_DIR})
    fi
    echo "... DEST_PROJ_DIR=${DEST_PROJ_DIR}"
    if [ ! -d ${DEST_PROJ_DIR} ]; then
        echo -e "... NEW: destination Project directory: ${DEST_PROJ_DIR}"
        mkdir -p ${DEST_PROJ_DIR}
    else
        echo "... EXISTING: destination Project directory: ${DEST_PROJ_DIR}"
    fi
}
setupDestDir ${DEST_PROJ_DIR}

CHILD_CONTAINER=`echo "$(basename ${DEST_PROJ_DIR})" | tr '[:upper:]' '[:lower:]' `
PARENT_CONTAINER=$(basename ${SRC_PROJ_DIR})

echo "--- Auto convert the project name to 'Lower-cased' to due Docker Container naming convention enforce by Docker Engine"

echo "--- Converted (all lower-cased) new Project Dir: ${DEST_PROJ_DIR}"
echo
echo "--- CONTINUE this Auto Generated Docker Project? ..."
echo
wait_seconds=10
read -t $wait_seconds -p "Hit ENTER (in $wait_seconds seconds) to continue or CTRL-C to abort this operaiton..."

## ----------------------- ##
## -- Mac / Linux fix:  -- ##
## ----------------------- ##
SED_MAC_FIX="''"
CP_OPTION="--backup=numbered"
## ------------------------------------------
## -- To find the HOST IP for Docker       --
## --  Container to pass into Container    --
## -- This will handle both Unix and MacOS --
## ------------------------------------------
HOST_IP=127.0.0.1
function find_host_ip() {
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # ...
        HOST_IP=`ip route get 1|grep via | awk '{print $7}'`
        SED_MAC_FIX=
        echo ${HOST_IP}
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        HOST_IP=`ifconfig | grep "inet " | grep -Fv 127.0.0.1 | grep -Fv 192.168 | awk '{print $2}'`
        CP_OPTION=
        echo ${HOST_IP}
    fi
}
find_host_ip

## ----------------------- ##
## -- 1.) Clone Project -- ##
## ----------------------- ##
function cloneProject() {
    #if [ ! -d $(dirname ${DEST_PROJ_DIR}) ]; then
    #    mkdir -p $(dirname ${DEST_PROJ_DIR})
    #fi
    cp -r ${SRC_PROJ_DIR}/* ${DEST_PROJ_DIR}/
    cp ${SRC_PROJ_DIR}/.env ${DEST_PROJ_DIR}/
    cp ${SRC_PROJ_DIR}/.env.template ${DEST_PROJ_DIR}/
    cp ${SRC_PROJ_DIR}/.gitignore ${DEST_PROJ_DIR}/
    
    #if [ ! -d ${DEST_PROJ_DIR} ]; then
    #    echo "*** ERROR ****: cloneProject(): FAIL: Abort!" ; exit 1
    #else
    #    echo "--- CLONE Docker Project: cloneProject(): "
    #    ls -al ${DEST_PROJ_DIR}
    #fi
    ls -al ${DEST_PROJ_DIR}

    # -- Generate .env --
    if [ ! -s ${DEST_PROJ_DIR}/.env.template ] || [ ! -s ${DEST_PROJ_DIR}/bin/auto-config-env.sh ]; then
        echo "*** ERROR ***: Missing ${DEST_PROJ_DIR}/.env.template or bin/auto-config-env.sh file! Abort!" ; exit 1
    else
        cd ${DEST_PROJ_DIR}; bin/auto-config-env.sh
    fi

    # -- Generate docker-compose.yml --
    if [ ! -s ${DEST_PROJ_DIR}/docker-compose.yml.template ] || [ ! -s ${DEST_PROJ_DIR}/bin/auto-config-docker-compose.sh ]; then
        echo "*** ERROR ***: Missing ${DEST_PROJ_DIR}/docker-compose.yml.template or bin/auto-config-docker-compose.sh file! Abort!"; exit 1
    else
        #cd ${DEST_PROJ_DIR}; bin/auto-config-docker-compose.sh
	cd ${DEST_PROJ_DIR}; bin/auto-config-all.sh
    fi

    ## ----------------------------------------------------------
    ## -- Overwrite Dockefile using Dockerfile.child.template: --
    ## ----------------------------------------------------------
    if [ -s ${DEST_PROJ_DIR}/Dockerfile.child.template ]; then
        mv ${DEST_PROJ_DIR}/Dockerfile.child.template ${DEST_PROJ_DIR}/Dockerfile
        sed -i ${SED_MAC_FIX} "s#{{PARENT_CONTAINER}}#$PARENT_CONTAINER#g" ${DEST_PROJ_DIR}/Dockerfile
    else
        echo -e "--- INFO: Can't find template child Dockerfile: ${DEST_PROJ_DIR}/Dockerfile.child.template!"
        echo -e "--- INFO: Instead, use the parent Dockerfile as source."
    fi
    ## ----------------------------------------------------------
    ## -- Remove .git: --
    ## ----------------------------------------------------------
    rm -rf ${DEST_PROJ_DIR}/.git *BACKUP *SAVE *tmp .env*BACKUP
}
cloneProject

function testBuildAndRun() {
    cd ${DEST_PROJ_DIR}; make build
    if [ $? -eq 0 ]; then
        ./run.sh
    else
        echo "*** ERROR ***: Docker build failure for the newly Clone/Genereated project: ${DEST_PROJ_DIR}"
    fi
}
testBuildAndRun

echo "-------------------------------- SUCCESS --------------------------------"
echo "  Generate a new Docker Project: "
echo "     - ${DEST_PROJ_DIR}"
echo "  Status:  "
echo "     - Tested BUILD and RUN: OK"
echo "-------------------------------------------------------------------------"
