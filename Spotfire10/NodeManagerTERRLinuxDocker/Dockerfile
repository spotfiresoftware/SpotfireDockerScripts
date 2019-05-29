# Dockerfile for NodeManager
# Also requires that the appropriate Deployment be loaded into Spotfire Server
### NOTE: tssname should be IP address with Linux Containers on Windows or host need to go into /etc/hosts file
## use with - docker build -m 3GB -t tsnmts_linux --build-arg tssname=d92b1f6414ee .
### to create a container from the tsnmts_linux image use
### pass server name as arg 
## docker run -it -d -m 3GB --cpus=2 --name tsnmts103 tsnmts_linux

# Indicates that the windowsservercore image will be used as the base image.
# Change this line if you want a different Windows base image
FROM centos

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

ARG tssname

# Copy over files that are needed
COPY tss-nm-10.3.0.x86_64.rpm defaultTS.conf fixnmproperties.sh /

## Before using rpm need wget and unzip; dos2unix needed to convert fixservername.sh file
RUN yum -y install wget unzip dos2unix iproute docker

# install Node Manager
RUN rpm -ivh tss-nm-10.3.0.x86_64.rpm

RUN /opt/tibco/tsnm/10.3.0/configure -m 9080 -c 9443 -s $tssname -r 9080 -b 9443

RUN cp /defaultTS.conf /opt/tibco/tsnm/10.3.0/nm/config/default.conf

# fix line endings on fixnmproperties.sh
RUN dos2unix fixnmproperties.sh
RUN chmod 755 fixnmproperties.sh 

EXPOSE 9501
EXPOSE 9443
EXPOSE 9080

# Sets a command or process that will run each time a container is run from the new image.
## Need to modify nodemanager.properties file when docker container is created to have correct nodemanager host name
ENTRYPOINT ./fixnmproperties.sh && /bin/bash
