# Dockerfile for SpotfireServer on Linux - 7.13 and above - currently done for Spotfire 10
##
## use with:
##
## docker build -m 3GB -t tsslinux103_env . 
##
### to create a container from the tss image use as an example
## docker run -it -d -p 82:80 --env DB_DRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver" --env DB_URL="jdbc:sqlserver://172.31.14.28:1433;DatabaseName=spotfire1039_docker" --env DB_USER="spotfire1039" --env DB_PASSWORD="spotfire1039" --env CONFIG_TOOL_PASSWORD="spotfire" --env ADMIN_USER="spotfire" --env ADMIN_PASSWORD="spotfire" --env SET_AUTO_TRUST=false -m 6GB --cpus=2 --name tss103_linux tsslinux103_env
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

# Indicates that the centos image will be used as the base image.
FROM centos

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

# Copy over files that are needed all at once in case some files are missing
# Spotfire.Dxp.sdn and tss_simpleconfig.txt are ONLY needed for initial configuration and setup items
COPY tss-10.3.9.x86_64.rpm fixservername.sh Spotfire.Dxp.sd[n] Spotfire.Dxp.TerrServiceWindows.sd[n] Spotfire.Dxp.TerrServiceLinux.sd[n]   /

## Before using rpm need wget and unzip; dos2unix needed to convert fixservername.sh file
RUN yum -y install wget unzip dos2unix

# install Spotfire Server
RUN rpm -ivh tss-10.3.9.x86_64.rpm
# configure Spotfire Server
RUN /opt/tibco/tss/10.3.9/configure -d -s 80 -r 9080 -b 9443

# fix line endings on fixservername.sh
RUN dos2unix fixservername.sh
RUN chmod 755 fixservername.sh 

EXPOSE 80
EXPOSE 9443
EXPOSE 9080
EXPOSE 5701

# Sets a command or process that will run each time a container is run from the new image.
## Need to create bootstrap when docker container is created
ENTRYPOINT ./fixservername.sh && /bin/bash
