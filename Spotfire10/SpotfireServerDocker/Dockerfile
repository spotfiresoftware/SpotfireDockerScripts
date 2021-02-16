# Dockerfile for SpotfireServer - 7.13 and above - currently done for Spotfire 10
##
## use with:
##
## docker build -m 3GB -t tsswin103_env . 
##
### to create a container from the tss image use as an example
## docker run -it -d -p 82:80 --env DB_DRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver" --env DB_URL="jdbc:sqlserver://172.31.14.28:1433;DatabaseName=spotfire1039_docker" --env DB_USER="spotfire1039" --env DB_PASSWORD="spotfire1039" --env CONFIG_TOOL_PASSWORD="spotfire" --env ADMIN_USER="spotfire" --env ADMIN_PASSWORD="spotfire" --env SET_AUTO_TRUST=false -m 6GB --cpus=2 --name tss103_env tsswin103_env
##
##
## DOCKER RUN with Environment Variables
##
## **** ENVIRONMENT VARIABLES
## *REQUIRED 
##    	DB_DRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver" 
##    	DB_URL="jdbc:sqlserver://172.31.14.28:1433;DatabaseName=spotfire1039_docker" 
##    	DB_USER="username" 
##    	DB_PASSWORD="password"
##    	CONFIG_TOOL_PASSWORD="password"
##		ADMIN_USER="username"
##		ADMIN_PASSWORD="password"
## 
## *OPTIONAL
##    	TSSNAME - will use COMPUTERNAME if does not exist
##		DEPLOY_TERR - true or false
##		SET_AUTO_TRUST - false or default of true
##

#### TODO: BEFORE RUNNING THIS SCRIPT MAKE SURE TO UPDATE Any of the installation paths and ports

# Indicates that the windowsservercore image will be used as the base image.
# Change this line if you want a different Windows base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

# Copy over files that are needed all at once in case some files are missing
# Spotfire.Dxp.sdn and tss_simpleconfig.txt are ONLY needed for initial configuration and setup items
##COPY setup-win64.exe fixservername.bat Spotfire.Dxp.sd[n] tss_simpleconfig.tx[t] Spotfire.Dxp.TerrServiceWindows.sd[n]   c:/
COPY setup-win64.exe fixservername.bat Spotfire.Dxp.sd[n] Spotfire.Dxp.TerrServiceWindows.sd[n]   c:/

# install Spotfire Server - NOTE: as of January 31, 2019 the installer ignores all parameters
RUN setup-win64.exe DOWNLOAD_THIRD_PARTY=No INSTALLDIR=C:\tibco\tss\10.3.9 SPOTFIRE_WINDOWS_SERVICE=DoNotCreate SERVER_FRONTEND_PORT=80 SERVER_BACKEND_REGISTRATION_PORT=9080 SERVER_BACKEND_COMMUNICATION_PORT=9443 NODEMANAGER_HOST_NAMES= -silent -log C:\TSS_Install.log

## manually install service
WORKDIR /tibco/tss/10.3.9/tomcat/bin
RUN service.bat install

#### TODO: UPDATE SERVICE NAME IN THIS COMMAND BASED ON VERSION INSTALLING, e.g. 7.11.3 would be Tss7113.
# Set Service to manual
RUN sc config "Tss1039" start=demand

EXPOSE 80
EXPOSE 9443
EXPOSE 9080
EXPOSE 5701

WORKDIR /

# Sets a command or process that will run each time a container is run from the new image.
#CMD cmd
## Need to create bootstrap when docker container is created
CMD ["cmd", "/k", "/fixservername.bat"]
