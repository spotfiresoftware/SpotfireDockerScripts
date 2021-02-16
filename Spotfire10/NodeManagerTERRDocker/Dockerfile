# Dockerfile for NodeManager - TERR as a Service
##
## Requires that the appropriate Deployment for TERR as a Service be deployed into Spotfire Server
## 
###  USING ENVIRONMENT VARIABLES
## To Run Container need to pass TSSNAME and optionally NODENAME for Node Manager
##  These names are used for communication between Spotfire Server and the Node Manager
##
#### Docker Build example:
##
## docker build -m 3GB -t tsnm_ts103 .
##
####### Docker run examples:
##
## pass server name as environment variable examples of docker run
##
## docker run -it -d --env TSSNAME=963f926d1ce0 --env NODENAME=<NODENAME> -m 4GB --cpus=2 --name tsnmts4gb103 tsnm_ts103
## 
## docker run -it -d --env TSSNAME=4884594badbb -m 4GB --cpus=2 --name tsnmts4gb103 tsnm_ts103
##
## **** ENVIRONMENT VARIABLES
## *REQUIRED 
##    	TSSNAME - must pass in TSSNAME for node to communicate with Spotfire Server.  Can be an server in the cluster.
## 
## *OPTIONAL
##    	NODENAME - will use COMPUTERNAME if does not exist
##

# Indicates that the windowsservercore image will be used as the base image.
# Change this line if you want a different Windows base image
## Specific image version must match version of host operating system
##
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

# Copy over files that are needed
COPY nm-setup.exe c:/nm-setup.exe
COPY defaultTS.conf C:/default.conf
COPY fixnmproperties.ps1 C:/fixnmproperties.ps1
COPY fixnmproperties.bat C:/fixnmproperties.bat

# install Node Manager
RUN nm-setup.exe INSTALLDIR="C:\tibco\tsnm\10.3.9" NODEMANAGER_REGISTRATION_PORT=9080 NODEMANAGER_COMMUNICATION_PORT=9443 SERVER_NAME=PLACEHOLDER SERVER_BACKEND_REGISTRATION_PORT=9080 SERVER_BACKEND_COMMUNICATION_PORT=9443 -silent -log C:\TSS_NM_install.log

RUN copy \default.conf c:\tibco\tsnm\10.3.9\nm\config

EXPOSE 9501
EXPOSE 9443
EXPOSE 9080

## Need to set service to manual start so that the final configuration can be done before starting
RUN sc config "WpNmRemote1039" start=demand

# Sets a command or process that will run each time a container is run from the new image.
##CMD cmd
## Need to modify nodemanager.properties file when docker container is created to have correct nodemanager host name
CMD ["cmd", "/k", "/fixnmproperties.bat"]