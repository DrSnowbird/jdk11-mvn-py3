# Java JDK 11 +  + Maven 3.5 + Python 3.5

##Components:
Components:
* Oracle Java "11.0.1" JDK environment
  java 11.0.1 2018-10-16 LTS
  Java(TM) SE Runtime Environment 18.9 (build 11.0.1+13-LTS)
  Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.1+13-LTS, mixed mode)

* Apache Maven 3.5.4
* Python 3.5.3
* Other tools: git wget unzip vim python python-setuptools python-dev python-numpy 

## Pull the image from Docker Repository

```bash
docker pull openkbs/jdk11-mvn-py3
```

## Base the image to build add-on components

```Dockerfile
FROM openkbs/jdk11-mvn-py3
```

## Run the image

Then, you're ready to run:
- make sure you create your work directory, e.g., ./data

```bash
mkdir ./data
docker run -d --name my-jdk11-mvn-py3 -v $PWD/data:/data -i -t openkbs/jdk11-mvn-py3
```

## Build and Run your own image
Say, you will build the image "my/jdk11-mvn-py3".

```bash
docker build -t my/jdk11-mvn-py3 .
```

To run your own image, say, with some-jdk11-mvn-py3:

```bash
mkdir ./data
docker run -d --name some-jdk11-mvn-py3 -v $PWD/data:/data -i -t my/jdk11-mvn-py3
```

## Shell into the Docker instance

```bash
docker exec -it some-jdk11-mvn-py3 /bin/bash
```

## Run Python code

To run Python code 

```bash
docker run -it --rm openkbs/jdk11-mvn-py3 python3 -c 'print("Hello World")'
```

or,

```bash
docker run -i --rm openkbs/jdk11-mvn-py3 python3 < myPyScript.py 
```

or,

```bash
mkdir ./data
echo "print('Hello World')" > ./data/myPyScript.py
docker run -it --rm --name some-jdk11-mvn-py3 -v "$PWD"/data:/data openkbs/jdk11-mvn-py3 python3 myPyScript.py
```

or,

```bash
alias dpy3='docker run --rm openkbs/jdk11-mvn-py3 python3'
dpy3 -c 'print("Hello World")'
```

## Compile or Run java while no local installation needed
Remember, the default working directory, /data, inside the docker container -- treat is as "/".
So, if you create subdirectory, "./data/workspace", in the host machine and 
the docker container will have it as "/data/workspace".

```java
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
alias djavac='docker run -it --rm --name some-jdk11-mvn-py3 -v '$PWD'/data:/data openkbs/jdk11-mvn-py3 javac'
alias djava='docker run -it --rm --name some-jdk11-mvn-py3 -v '$PWD'/data:/data openkbs/jdk11-mvn-py3 java'

djavac HelloWorld.java
djava HelloWorld
```
And, the output:
```
Hello, World
```
Hence, the alias above, "djavac" and "djava" is your docker-based "javac" and "java" commands and 
it will work the same way as your local installed Java's "javac" and "java" commands. 
However, for larger complex projects, you might want to consider to use Docker-based IDE. 
For example, try this docker-scala-ide:
[Eclipse-Oxygen-Docker](https://github.com/DrSnowbird/eclipse-oxygen-docker)
[Scala IDE in Docker](https://github.com/stevenalexander/docker-scala-ide)
See also,
[Java Development in Docker](https://blog.giantswarm.io/getting-started-with-java-development-on-docker/)

# Versions
```
root@394fabcb40a4:/data# ./printVersions.sh 
JAVA_HOME=/usr/jdk-11.0.1
java version "11.0.1" 2018-10-16 LTS
Java(TM) SE Runtime Environment 18.9 (build 11.0.1+13-LTS)
Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.1+13-LTS, mixed mode)
Apache Maven 3.5.4 (1edded0938998edf8bf061f1ceb3cfdeccf443fe; 2018-06-17T18:33:14Z)
Maven home: /usr/apache-maven-3.5.4
Java version: 11.0.1, vendor: Oracle Corporation, runtime: /usr/jdk-11.0.1
Default locale: en_US, platform encoding: ANSI_X3.4-1968
OS name: "linux", version: "4.15.0-36-generic", arch: "amd64", family: "unix"
Python 3.5.2
Python 3.5.2
pip 8.1.1 from /usr/lib/python3/dist-packages (python 3.5)
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04.3 LTS"
NAME="Ubuntu"
VERSION="16.04.3 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.3 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
```
