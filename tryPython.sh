#!/bin/bash -x

###################################################
#### ---- Change this only if want to use your own
###################################################
ORGANIZATION=openkbs

###################################################
#### ---- Container package information ----
###################################################
DOCKER_IMAGE_REPO=`echo $(basename $PWD)|tr '[:upper:]' '[:lower:]'|tr "/: " "_" `
imageTag=${1:-"${ORGANIZATION}/${DOCKER_IMAGE_REPO}"}

docker run -it --rm ${imageTag} /usr/bin/python3 -c 'print("Hello World")'

docker run --rm ${imageTag} /usr/bin/python3 -c 'print("Hello World")'

mkdir -p ./data
echo "print('Hello World')" > ./data/myPyScript.py

docker run -it --rm --name some-jdk11-mvn-py3 -v "$PWD"/data:/data ${imageTag} /usr/bin/python3 myPyScript.py

docker run -i --rm ${imageTag} /usr/bin/python3 < ./data/myPyScript.py


