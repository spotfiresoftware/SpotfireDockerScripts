# Dockerfile for SpotfireServer on Linux - 7.13 and above - currently done for Spotfire 10
## use with - docker build -m 3GB -t tsslinux103 --build-arg toolpwd=spotfire --build-arg adminuser=spotfire --build-arg doconfig=true --build-arg deployTERR=true .
## ARGUMENTS TO Dockerfile
##		toolpwd - if doconfig=true, then pass in the configuration tool password as set in the tss_simpleconfig.txt 
##				using the CONFIG_TOOL_PASSWORD variable.
##		adminuser - if doconfig=true, then this user will be promoted to an admin user.  The user is created by 
##				the tss_simpleconfig.txt using the ADMIN_USER variable.
## 		doconfig - true or false (or missing).  If true, then the configuration section of the Dockerfile will be run.
##				The configuration only needs to run once such that one can turn if off and on if it has already run.
## 		deployTERR - true or false (or missing).  If true, then the build deploys the TERR Service Spotfire Package to the deployment.
##
### to create a container from the tss image use
## docker run -it -d -p 80:80 -m 3GB --cpus=2 --name tsslinux3gb tsslinux103

#### TODO: BEFORE RUNNING THIS SCRIPT MAKE SURE TO UPDATE Any of the installation paths and ports

# Indicates that the centos image will be used as the base image.
FROM centos

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

ARG toolpwd
ARG adminuser
ARG doconfig
ARG deployTERR

# Copy over files that are needed all at once in case some files are missing
# Spotfire.Dxp.sdn and tss_simpleconfig.txt are ONLY needed for initial configuration and setup items
COPY tss-10.3.0.x86_64.rpm fixservername.sh Spotfire.Dxp.sd[n] tss_simpleconfig.tx[t] Spotfire.Dxp.TerrServiceWindows.sd[n] Spotfire.Dxp.TerrServiceLinux.sd[n]   /

## Before using rpm need wget and unzip; dos2unix needed to convert fixservername.sh file
RUN yum -y install wget unzip dos2unix

# install Spotfire Server
RUN rpm -ivh tss-10.3.0.x86_64.rpm
# configure Spotfire Server
RUN /opt/tibco/tss/10.3.0/configure -d -s 80 -r 9080 -b 9443

# fix line endings on fixservername.sh
RUN dos2unix fixservername.sh
RUN chmod 755 fixservername.sh 

######################### NOTE These steps only need to be done one time	
# update configuration - this step ONLY needs to be done once and not repeatedly, except for bootstrap creation
RUN if [ "$doconfig" = "true" ] ; then /opt/tibco/tss/10.3.0/tomcat/spotfire-bin/config.sh run tss_simpleconfig.txt ; fi

# update deployment
RUN if [ "$doconfig" = "true" ] ; then /opt/tibco/tss/10.3.0/tomcat/spotfire-bin/config.sh update-deployment --bootstrap-config /opt/tibco/tss/10.3.0/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml \
    --tool-password $toolpwd --area Production /Spotfire.Dxp.sdn ; fi

# deploy TERR as a service deployment - Determine if need to deploy Windows or Linux TERR Service package (or both)
##RUN if [ "$deployTERR" = "true" ] ; then /opt/tibco/tss/10.3.0/tomcat/spotfire-bin/config.sh update-deployment --bootstrap-config /opt/tibco/tss/10.3.0/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml \
##    --tool-password $toolpwd --area Production /Spotfire.Dxp.TerrServiceWindows.sdn ; fi
# Deploy TERR as a Service Linux deployment
RUN if [ "$deployTERR" = "true" ] ; then /opt/tibco/tss/10.3.0/tomcat/spotfire-bin/config.sh update-deployment --bootstrap-config /opt/tibco/tss/10.3.0/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml \
    --tool-password $toolpwd --area Production /Spotfire.Dxp.TerrServiceLinux.sdn ; fi
	
# set auto trust (could be done using a file with the command sets)
## /opt/tibco/tss/10.3.0/tomcat/bin/config.sh run set-auto-trust.txt
RUN if [ "$doconfig" = "true" ] ; then /opt/tibco/tss/10.3.0/tomcat/spotfire-bin/config.sh export-config --bootstrap-config /opt/tibco/tss/10.3.0/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml --tool-password $toolpwd /opt/tibco/tss/10.3.0/configuration.xml ; fi

RUN if [ "$doconfig" = "true" ] ; then /opt/tibco/tss/10.3.0/tomcat/spotfire-bin/config.sh set-config-prop --configuration /opt/tibco/tss/10.3.0/configuration.xml --bootstrap-config /opt/tibco/tss/10.3.0/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml --name=security.trust.auto-trust.enabled --value=true ; fi

RUN if [ "$doconfig" = "true" ] ; then /opt/tibco/tss/10.3.0/tomcat/spotfire-bin/config.sh import-config --bootstrap-config /opt/tibco/tss/10.3.0/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml --tool-password $toolpwd --comment "Set security.trust.auto-trust.enabled to True" --delete-file true /opt/tibco/tss/10.3.0/configuration.xml ; fi

# promote user to admin user
RUN if [ "$doconfig" = "true" ] ; then /opt/tibco/tss/10.3.0/tomcat/spotfire-bin/config.sh promote-admin --tool-password $toolpwd --username $adminuser ; fi

# if configuration done then need to remove bootstrap.xml file
RUN if [ "$doconfig" = "true" ] ; then if [ -f /opt/tibco/tss/10.3.0/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml ] ; then rm /opt/tibco/tss/10.3.0/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml; fi ; fi

EXPOSE 80
EXPOSE 9443
EXPOSE 9080

# Sets a command or process that will run each time a container is run from the new image.
## Need to create bootstrap when docker container is created
ENTRYPOINT ./fixservername.sh && /bin/bash
