# Dockerfile for NodeManager
## use with - docker build -m 3GB -t tsnm_wp --build-arg tssname=d92b1f6414ee .
### to create a container from the tsnm_wp image use
### pass server name as arg 
## docker run -it -d -m 3GB --cpus=2 --name tsnmwp3gb tsnm_wp

# Indicates that the windowsservercore image will be used as the base image.
FROM microsoft/windowsservercore

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

ARG tssname

# Copy over files that are needed
COPY nm-setup.exe c:/nm-setup.exe
COPY defaultWP.conf C:/default.conf
COPY fixnmproperties.ps1 C:/fixnmproperties.ps1
COPY fixnmproperties.bat C:/fixnmproperties.bat

# install Node Manager
RUN nm-setup.exe INSTALLDIR="C:\tibco\tsnm\10.0.1" NODEMANAGER_REGISTRATION_PORT=9080 NODEMANAGER_COMMUNICATION_PORT=9443 SERVER_NAME=%tssname% SERVER_BACKEND_REGISTRATION_PORT=9080 SERVER_BACKEND_COMMUNICATION_PORT=9443 -silent -log C:\TSS_NM_install.log

RUN copy \default.conf c:\tibco\tsnm\10.0.1\nm\config

EXPOSE 9501
EXPOSE 9443
EXPOSE 9080

## Need to set service to manual start so that the final configuration can be done before starting
RUN sc config "WpNmRemote1001" start=demand

# Sets a command or process that will run each time a container is run from the new image.
##CMD cmd
## Need to modify nodemanager.properties file when docker container is created to have correct nodemanager host name
CMD ["cmd", "/k", "/fixnmproperties.bat"]