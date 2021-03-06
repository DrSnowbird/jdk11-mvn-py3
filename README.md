# OpenJDK Java 11 + Maven 3.6 + Python 3.8  + pip 21 + node 15 + npm 7 + Gradle 6

[![](https://images.microbadger.com/badges/image/openkbs/jdk-mvn-py3.svg)](https://microbadger.com/images/openkbs/jdk-mvn-py3 "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/openkbs/jdk-mvn-py3.svg)](https://microbadger.com/images/openkbs/jdk-mvn-py3 "Get your own version badge on microbadger.com")

# ** This build is based upon Ubuntu 20.04 + OpenJDK Java 11 **

# NOTICE: ''Change to use Non-Root implementation''
This new release is designed to support the deployment for Non-Root child images implementations and deployments to platform such as OpenShift or RedHat host operating system which requiring special policy to deploy. And, for better security practice, we decided to migrate (eventaully) our Docker containers to use Non-Root implementation. 
Here are some of the things you can do if your images requiring "Root" acccess - you `really` want to do it:
1. For Docker build: Use "sudo" or "sudo -H" prefix to your Dockerfile's command which requiring "sudo" access to install packages.
2. For Docker container (access via shell): Use "sudo" command when you need to access root privilges to install packages or change configurations.
3. Or, you can use older version of this kind of base images which use "root" in Dockerfile.
4. Yet, you can also modify the Dockerfile at the very bottom to remove/comment out the "USER ${USER}" line so that your child images can have root as USER.
5. Finally, you can also, add a new line at the very top of your child Docker image's Dockerfile to include "USER root" so that your Docker images built will be using "root".

We like to promote the use of "Non-Root" images as better Docker security practice. And, whenever possible, you also want to further confine the use of "root" privilges in your Docker implementation so that it can prevent the "rooting hacking into your Host system". To lock down your docker images and/or this base image, you will add the following line at the very end to remove sudo: `(Notice that this might break some of your run-time code if you use sudo during run-time)`
```
sudo agt-get remove -y sudo
```
After that, combining with other Docker security practice (see below references), you just re-build your local images and re-deploy it as non-development quality of docker container. However, there are many other practices to secure your Docker containes. See below:

* [Docker security | Docker Documentation](https://docs.docker.com/engine/security/security/)
* [5 tips for securing your Docker containers - TechRepublic](https://www.techrepublic.com/article/5-tips-for-securing-your-docker-containers/)
* [Docker Security - 6 Ways to Secure Your Docker Containers](https://www.sumologic.com/blog/security/securing-docker-containers/)
* [Five Docker Security Best Practices - The New Stack](https://thenewstack.io/5-docker-security-best-practices/)

# Components
* Ubuntu 20.04 LTS now as LTS Docker base image.

* openjdk version "11.0.11" 2021-04-20
  OpenJDK Runtime Environment (build 11.0.11+9-Ubuntu-0ubuntu2.20.04)
  OpenJDK 64-Bit Server VM (build 11.0.11+9-Ubuntu-0ubuntu2.20.04, mixed mode, sharing)
* Apache Maven 3.6
* Python 3.8 + pip 21.1 + Python 3 virtual environments (venv, virtualenv, virtualenvwrapper, mkvirtualenv, ..., etc.)
* Node v15 + npm 7 (from NodeSource official Node Distribution)
* Gradle 6
* Other tools: git wget unzip vim python python-setuptools python-dev python-numpy, ..., etc.
* [See Releases Information](https://github.com/DrSnowbird/jdk-mvn-py3/blob/master/README.md#Releases-information)

# Quick commands
* build.sh - build local image
* logs.sh - see logs of container
* run.sh - run the container
* shell.sh - shell into the container
* stop.sh - stop the container
* tryJava.sh : test Java
* tryNodeJS.sh : test NodeJS
* tryPython.sh : test Python
* tryWebSocketServer.sh : test WebSockert NodeJS Server

# How to use and quick start running?
1. git clone https://github.com/DrSnowbird/jdk-mvn-py3.git
2. cd jdk-mvn-py3
3. ./run.sh

# Default Run (test) - Just entering Container
```
./run.sh
```

# Test Java, NodeJS, and Python3 Runs
```
./tryJava.sh
./tryNodeJS.sh
./tryPython.sh
./tryWebSockerServer.sh
```
# Default Build (locally)
```
./build.sh
```
# Pull the image from Docker Repository

```bash
docker pull openkbs/jdk-mvn-py3
```

# Base the image to build add-on components

```Dockerfile
FROM openkbs/jdk-mvn-py3
... (then your customization Dockerfile code here)
```

# Manually setup to Run the image

Then, you're ready to run:
- make sure you create your work directory, e.g., ./data

```bash
mkdir ./data
docker run -d --name my-jdk-mvn-py3 -v $PWD/data:/data -i -t openkbs/jdk-mvn-py3
```

# Build and Run your own image
Say, you will build the image "my/jdk-mvn-py3".

```bash
docker build -t my/jdk-mvn-py3 .
```

To run your own image, say, with some-jdk-mvn-py3:

```bash
mkdir ./data
docker run -d --name some-jdk-mvn-py3 -v $PWD/data:/data -i -t my/jdk-mvn-py3
```

# Shell into the Docker instance

```bash
docker exec -it some-jdk-mvn-py3 /bin/bash
```

# Run Python code

To run Python code 

```bash
docker run -it --rm openkbs/jdk-mvn-py3 python3 -c 'print("Hello World")'
```

or,

```bash
docker run -i --rm openkbs/jdk-mvn-py3 python3 < myPyScript.py 
```

or,

```bash
mkdir ./data
echo "print('Hello World')" > ./data/myPyScript.py
docker run -it --rm --name some-jdk-mvn-py3 -v "$PWD"/data:/data openkbs/jdk-mvn-py3 python3 myPyScript.py
```

or,

```bash
alias dpy3='docker run --rm openkbs/jdk-mvn-py3 python3'
dpy3 -c 'print("Hello World")'
```

# Compile or Run java -- while no local installation needed
Remember, the default working directory, /data, inside the docker container -- treat is as "/".
So, if you create subdirectory, "./data/workspace", in the host machine and 
the docker container will have it as "/data/workspace".

```
#!/bin/bash -x
mkdir ./data
cat >./data/HelloWorld.java <<-EOF
public class HelloWorld {
   public static void main(String[] args) {
      System.out.println("Hello, World");
   }
}
EOF
cat ./data/HelloWorld.java
alias djavac='docker run -it --rm --name some-jdk-mvn-py3 -v '$PWD'/data:/data openkbs/jdk-mvn-py3 javac'
alias djava='docker run -it --rm --name some-jdk-mvn-py3 -v '$PWD'/data:/data openkbs/jdk-mvn-py3 java'
djavac HelloWorld.java
djava HelloWorld
```
And, the output:
```
Hello, World
```
Hence, the alias above, "djavac" and "djava" is your docker-based "javac" and "java" commands and 
it will work the same way as your local installed Java's "javac" and "java" commands. 

# Run JavaScript -- while no local installation needed
Run the NodeJS mini-server script:
```
./tryNodeJS.sh
```
Then, open web browser to go to http://0.0.0.0:3000/ to NodeJS mini-web server test.

# Python Virtual Environments
There are various ways to run Python virtual envrionments, for example,

### Setup virtualenvwrapper in $HOME/.bashrc profile
Add the following code to the end of ~/.bashrc
```
#########################################################################
#### ---- Customization for multiple virtual python environment ---- ####
#########################################################################
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
export WORKON_HOME=~/Envs
if [ ! -d $WORKON_HOME ]; then
    mkdir -p $WORKON_HOME
fi
```

### To create & activate your default venv environment, say, "my-venv":
```
mkvirtualenv my-venv
workon my-venv
```

# To run specialty Java/Scala IDE alternatives
However, for larger complex projects, you might want to consider to use Docker-based IDE. 
For example, try the following Docker-based IDEs:
* [openkbs/docker-atom-editor](https://hub.docker.com/r/openkbs/docker-atom-editor/)
* [openkbs/eclipse-photon-docker](https://hub.docker.com/r/openkbs/eclipse-photon-docker/)
* [openkbs/eclipse-photon-vnc-docker](https://hub.docker.com/r/openkbs/eclipse-photon-vnc-docker/)
* [openkbs/eclipse-oxygen-docker](https://hub.docker.com/r/openkbs/eclipse-oxygen-docker/)
* [openkbs/intellj-docker](https://hub.docker.com/r/openkbs/intellij-docker/)
* [openkbs/intellj-vnc-docker](https://hub.docker.com/r/openkbs/intellij-vnc-docker/)
* [openkbs/knime-vnc-docker](https://hub.docker.com/r/openkbs/knime-vnc-docker/)
* [openkbs/netbeans9-docker](https://hub.docker.com/r/openkbs/netbeans9-docker/)
* [openkbs/netbeans](https://hub.docker.com/r/openkbs/netbeans/)
* [openkbs/papyrus-sysml-docker](https://hub.docker.com/r/openkbs/papyrus-sysml-docker/)
* [openkbs/pycharm-docker](https://hub.docker.com/r/openkbs/pycharm-docker/)
* [openkbs/scala-ide-docker](https://hub.docker.com/r/openkbs/scala-ide-docker/)
* [openkbs/sublime-docker](https://hub.docker.com/r/openkbs/sublime-docker/)
* [openkbs/webstorm-docker](https://hub.docker.com/r/openkbs/webstorm-docker/)
* [openkbs/webstorm-vnc-docker](https://hub.docker.com/r/openkbs/webstorm-vnc-docker/)

# See also
* [Java Development in Docker](https://blog.giantswarm.io/getting-started-with-java-development-on-docker/)
* [Alpine small image JDKs](https://github.com/frol/docker-alpine-oraclejdk8)
* [NPM Prefix for not using SUDO NPM](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally)

# Proxy & Certificate Setup
* [Setup System and Browsers Root Certificate](https://thomas-leister.de/en/how-to-import-ca-root-certificate/)

# Corporate Proxy Root and Intemediate Certificates setup for System and Web Browsers (FireFox, Chrome, etc)
1. Save your corporate's Certificates in the currnet GIT directory, `./certificates`
2. During Docker run command, 
```
   -v `pwd`/certificates:/certificates ... (the rest parameters)
```
If you want to map to different directory for certificates, e.g., /home/developer/certificates, then
```
   -v `pwd`/certificates:/home/developer/certificates -e SOURCE_CERTIFICATES_DIR=/home/developer/certificates ... (the rest parameters)
```
3. And, inside the Docker startup script to invoke the `~/scripts/setup_system_certificates.sh`. Note that the script assumes the certficates are in `/certificates` directory.
4. The script `~/scripts/setup_system_certificates.sh` will automatic copy to target directory and setup certificates for both System commands (wget, curl, etc) to use and Web Browsers'.

# Releases information
```
developer@6a5c3c02fb3a:~$ /usr/scripts/printVersions.sh 
+ echo JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
+ whereis java
java: /usr/bin/java /usr/share/java /usr/lib/jvm/java-11-openjdk-amd64/bin/java /usr/share/man/man1/java.1.gz
+ echo

+ java -version
openjdk version "11.0.11" 2021-04-20
OpenJDK Runtime Environment (build 11.0.11+9-Ubuntu-0ubuntu2.20.04)
OpenJDK 64-Bit Server VM (build 11.0.11+9-Ubuntu-0ubuntu2.20.04, mixed mode, sharing)
+ mvn --version
Apache Maven 3.6.3 (cecedd343002696d0abb50b32b541b8a6ba2883f)
Maven home: /usr/apache-maven-3.6.3
Java version: 11.0.11, vendor: Ubuntu, runtime: /usr/lib/jvm/java-11-openjdk-amd64
Default locale: en, platform encoding: UTF-8
OS name: "linux", version: "5.8.0-59-generic", arch: "amd64", family: "unix"
+ python -V
/usr/scripts/printVersions.sh: line 8: python: command not found
+ python3 -V
Python 3.8.10
+ pip --version
pip 21.1.3 from /usr/local/lib/python3.8/dist-packages/pip (python 3.8)
+ pip3 --version
pip 21.1.3 from /usr/local/lib/python3.8/dist-packages/pip (python 3.8)
+ gradle --version

Welcome to Gradle 6.7!

Here are the highlights of this release:
 - File system watching is ready for production use
 - Declare the version of Java your build requires
 - Java 15 support

For more details see https://docs.gradle.org/6.7/release-notes.html


------------------------------------------------------------
Gradle 6.7
------------------------------------------------------------

Build time:   2020-10-14 16:13:12 UTC
Revision:     312ba9e0f4f8a02d01854d1ed743b79ed996dfd3

Kotlin:       1.3.72
Groovy:       2.5.12
Ant:          Apache Ant(TM) version 1.10.8 compiled on May 10 2020
JVM:          11.0.11 (Ubuntu 11.0.11+9-Ubuntu-0ubuntu2.20.04)
OS:           Linux 5.8.0-59-generic amd64

+ npm -v
7.18.1
+ node -v
v16.4.1
+ cat /etc/lsb-release /etc/os-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.2 LTS"
NAME="Ubuntu"
VERSION="20.04.2 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.2 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
```

## Python3 PIP Modules
```
developer@6f369aab375e:~$ pip freeze
appdirs==1.4.4
argon2-cffi==20.1.0
async-generator==1.10
atomicwrites==1.1.5
attrs==20.3.0
backcall==0.2.0
beautifulsoup4==4.8.2
bleach==3.3.0
certifi==2020.12.5
cffi==1.14.4
chardet==4.0.0
cloudpickle==1.6.0
cycler==0.10.0
dbus-python==1.2.16
decorator==4.4.2
defusedxml==0.6.0
distlib==0.3.1
distro-info===0.23ubuntu1
entrypoints==0.3
et-xmlfile==1.0.1
filelock==3.0.12
funcy==1.15
future==0.18.2
html5lib==1.0.1
httpie==2.3.0
hyperopt==0.2.5
idna==2.10
importlib-metadata==1.5.0
iniconfig==1.1.1
ipaddress==1.0.23
ipykernel==5.4.3
ipython==7.20.0
ipython-genutils==0.2.0
ipywidgets==7.6.3
j2cli==0.3.10
jdcal==1.0
jedi==0.18.0
Jinja2==2.11.3
joblib==1.0.0
json-lines==0.5.0
jsonschema==3.2.0
jupyter==1.0.0
jupyter-client==6.1.11
jupyter-console==6.2.0
jupyter-core==4.7.1
jupyterlab-pygments==0.1.2
jupyterlab-widgets==1.0.0
kiwisolver==1.3.1
lxml==4.5.0
MarkupSafe==1.1.1
matplotlib==3.3.4
mistune==0.8.4
more-itertools==4.2.0
nbclient==0.5.1
nbconvert==6.0.7
nbformat==5.1.2
nest-asyncio==1.5.1
networkx==2.5
notebook==6.2.0
numexpr==2.7.2
numpy==1.20.0
olefile==0.46
openpyxl==3.0.3
packaging==20.9
panda==0.3.1
pandas==1.2.1
pandasql==0.7.3
pandocfilters==1.4.3
parso==0.8.1
pbr==5.5.1
pexpect==4.8.0
pickleshare==0.7.5
Pillow==8.1.0
pkgconfig==1.5.1
pluggy==0.13.1
prometheus-client==0.9.0
prompt-toolkit==3.0.14
ptyprocess==0.7.0
py==1.10.0
pycparser==2.20
Pygments==2.7.4
PyGObject==3.36.0
pyLDAvis==2.1.2
pyparsing==2.4.7
pyrsistent==0.17.3
PySocks==1.7.1
pytest==6.2.2
python-apt==2.0.0+ubuntu0.20.4.4
python-dateutil==2.8.1
python-git==2018.2.1
pytz==2021.1
PyYAML==3.11
pyzmq==22.0.2
qtconsole==5.0.2
QtPy==1.9.0
requests==2.25.1
requests-toolbelt==0.9.1
requests-unixsocket==0.2.0
scikit-learn==0.24.1
scipy==1.6.0
seaborn==0.11.1
Send2Trash==1.5.0
six==1.15.0
soupsieve==1.9.5
SQLAlchemy==1.3.23
stevedore==3.3.0
tables==3.6.1
terminado==0.9.2
testpath==0.4.4
threadpoolctl==2.1.0
toml==0.10.2
tornado==6.1
tqdm==4.56.0
traitlets==5.0.5
unattended-upgrades==0.1
urllib3==1.26.3
virtualenv==20.4.2
virtualenv-clone==0.5.4
virtualenvwrapper==4.8.4
wcwidth==0.2.5
webencodings==0.5.1
widgetsnbextension==3.5.1
xlrd==1.1.0
xlwt==1.3.0
yml2json==1.0.1
zipp==1.0.0
```
