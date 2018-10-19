# use the latest LTS Ubuntu
FROM ubuntu:xenial

MAINTAINER DrSnowbird@openkbs.org

ENV DEBIAN_FRONTEND noninteractive

##### update ubuntu and Install Python 3
RUN apt-get update \
  && apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev \
  && apt-get install -y curl net-tools build-essential libsqlite3-dev sqlite3 bzip2 libbz2-dev git wget unzip vim python3-pip python3-setuptools python3-dev python3-numpy python3-scipy python3-pandas python3-matplotlib \
  && ln -s /usr/bin/python3 /usr/bin/python \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

###################################
#### Install Java 11
###################################

#### ---------------------------------------------------------------
#### ---- Change below when upgrading version ----
#### ---------------------------------------------------------------
# http://download.oracle.com/otn-pub/java/jdk/11.0.1+13/90cf5d8f270a4347a95050320eef3fb7/jdk-11.0.1_linux-x64_bin.tar.gz

ARG JAVA_MAJOR_VERSION=${JAVA_MAJOR_VERSION:-11}
ARG JAVA_UPDATE_VERSION=${JAVA_UPDATE_VERSION:-0.1}
ARG JAVA_BUILD_NUMBER=${JAVA_BUILD_NUMBER:-13}
ARG JAVA_TOKEN=${JAVA_TOKEN:-90cf5d8f270a4347a95050320eef3fb7}

#### ---------------------------------------------------------------
#### ---- Don't change below unless you know what you are doing ----
#### ---------------------------------------------------------------
ARG UPDATE_VERSION="${JAVA_MAJOR_VERSION}.${JAVA_UPDATE_VERSION}"
ARG BUILD_VERSION=${JAVA_BUILD_NUMBER}

ENV JAVA_HOME /usr/jdk-${JAVA_MAJOR_VERSION}.${JAVA_UPDATE_VERSION}
ENV PATH $PATH:$JAVA_HOME/bin
ENV INSTALL_DIR /usr

## http://download.oracle.com/otn-pub/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jdk-10.0.2_linux-x64_bin.tar.gz

WORKDIR $INSTALL_DIR

#RUN curl -sL --retry 3 --insecure \
#  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
#  "http://download.oracle.com/otn-pub/java/jdk/${UPDATE_VERSION}+${BUILD_VERSION}/${JAVA_TOKEN}/jdk-${UPDATE_VERSION}_linux_x64_bin.tar.gz" \
#  | gunzip \
#  | tar x -C /usr/ \
#  && ln -s $JAVA_HOME $INSTALL_DIR/java \
#  && rm -rf $JAVA_HOME/man

RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/${UPDATE_VERSION}+${BUILD_VERSION}/${JAVA_TOKEN}/jdk-${UPDATE_VERSION}_linux-x64_bin.tar.gz" --output $INSTALL_DIR/jdk-${UPDATE_VERSION}_linux-x64_bin.tar.gz \
  && tar xvf jdk-${UPDATE_VERSION}_linux-x64_bin.tar.gz \
  && ln -s $JAVA_HOME $INSTALL_DIR/java \
  && rm -rf $JAVA_HOME/man jdk-${UPDATE_VERSION}_linux-x64_bin.tar.gz

###################################
#### Install Maven 3
###################################
ENV MAVEN_VERSION 3.5.4
ENV MAVEN_HOME /usr/apache-maven-$MAVEN_VERSION
ENV PATH $PATH:$MAVEN_HOME/bin
## http://mirrors.sorengard.com/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
RUN curl -sL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s $MAVEN_HOME /usr/maven

###################################
#### ---- Pip install packages ----
###################################
COPY requirements.txt ./

## ---------------------------------------------------
## Don't upgrade pip to 10.0.x version -- it's broken! 
## Staying with version 8 to avoid the problem
## ---------------------------------------------------

RUN pip3 install -r ./requirements.txt && pip3 install --upgrade pip  

###################################
#### ---- Install Gradle       ----
###################################
ARG GRADLE_INSTALL_BASE=${GRADLE_INSTALL_BASE:-/opt/gradle}
ARG GRADLE_VERSION=${GRADLE_VERSION:-4.9}

ARG GRADLE_HOME=${GRADLE_INSTALL_BASE}/gradle-${GRADLE_VERSION}
ENV GRADLE_HOME=${GRADLE_HOME}
ARG GRADLE_PACKAGE=gradle-${GRADLE_VERSION}-bin.zip
ARG GRADLE_PACKAGE_URL=https://services.gradle.org/distributions/${GRADLE_PACKAGE}
# https://services.gradle.org/distributions/gradle-4.9-bin.zip
RUN \
    mkdir -p ${GRADLE_INSTALL_BASE} && \
    cd ${GRADLE_INSTALL_BASE} && \
    wget -c ${GRADLE_PACKAGE_URL} && \
    unzip -d ${GRADLE_INSTALL_BASE} ${GRADLE_PACKAGE} && \
    ls -al ${GRADLE_HOME} && \
    ln -s ${GRADLE_HOME}/bin/gradle /usr/bin/gradle && \
    ${GRADLE_HOME}/bin/gradle -v

###################################
#### ---- Working directory.   ----
###################################
RUN mkdir -p /data
COPY . /data

VOLUME "/data"

WORKDIR /data

#### Define default command.

