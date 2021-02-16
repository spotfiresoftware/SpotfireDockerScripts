# Dockerfile for NodeManager - TERR as a Service on Linux
##
## Requires that the appropriate Deployment for TERR as a Service be deployed into Spotfire Server
## 
###  USING ENVIRONMENT VARIABLES
## To Run Container need to pass TSSNAME and optionally NODENAME for Node Manager
##  These names are used for communication between Spotfire Server and the Node Manager
##
#### Docker Build example:
##
## docker build -m 3GB -t tsnmts103_linux .
##
####### Docker run examples:
##
## pass server name as environment variable examples of docker run
##
## docker run -it -d --env TSSNAME=963f926d1ce0 --env NODENAME=<NODENAME> -m 4GB --cpus=2 --name tsnmtslx4gb103 tsnmts103_linux
## 
## docker run -it -d --env TSSNAME=4884594badbb -m 4GB --cpus=2 --name tsnmtslx4gb103 tsnmts103_linux
##
## **** ENVIRONMENT VARIABLES
## *REQUIRED 
##    	TSSNAME - must pass in TSSNAME for node to communicate with Spotfire Server.  Can be an server in the cluster.
## 
## *OPTIONAL
##    	NODENAME - will use COMPUTERNAME if does not exist
##

#
# Indicates that the windowsservercore image will be used as the base image.
# Change this line if you want a different Linux base image
#
FROM centos

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

ARG tssname

# Copy over files that are needed
COPY tss-nm-10.3.9.x86_64.rpm defaultTS.conf fixnmproperties.sh /

## Before using rpm need wget and unzip; dos2unix needed to convert fixservername.sh file
RUN yum -y install wget unzip dos2unix iproute docker

# install Node Manager
RUN rpm -ivh tss-nm-10.3.9.x86_64.rpm

RUN /opt/tibco/tsnm/10.3.9/configure -m 9080 -c 9443 -s $tssname -r 9080 -b 9443

RUN cp /defaultTS.conf /opt/tibco/tsnm/10.3.9/nm/config/default.conf

# fix line endings on fixnmproperties.sh
RUN dos2unix fixnmproperties.sh
RUN chmod 755 fixnmproperties.sh 

EXPOSE 9501
EXPOSE 9443
EXPOSE 9080

# Sets a command or process that will run each time a container is run from the new image.
## Need to modify nodemanager.properties file when docker container is created to have correct nodemanager host name
ENTRYPOINT ./fixnmproperties.sh && /bin/bash
