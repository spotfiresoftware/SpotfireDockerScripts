# Dockerfile for SpotfireServer on Linux
## use with - docker build -m 3GB -t tsslinux --build-arg toolpwd=spotfire --build-arg adminuser=spotfire --build-arg doconfig=true .
## if needed add build-args: --build-arg toolpwd=spotfire --build-arg adminuser=spotfire --build-arg doconfig=true
### to create a container from the tss image use
## docker run -it -d -p 80:80 -m 3GB --cpus=2 --name tsslinux3gb tsslinux

# Indicates that the centos image will be used as the base image.
FROM centos

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

ARG toolpwd
ARG adminuser
ARG doconfig

# Copy over files that are needed all at once in case some files are missing
# Spotfire.Dxp.sdn and tss_simpleconfig.txt are ONLY needed for initial configuration and setup items
COPY tss-7.11.3.x86_64.rpm fixservername.sh Spotfire.Dxp.sd[n] tss_simpleconfig.tx[t]  /

## Before using rpm need wget and unzip; dos2unix needed to convert fixservername.sh file
RUN yum -y install wget unzip dos2unix

# install Spotfire Server
RUN rpm -ivh tss-7.11.3.x86_64.rpm
# configure Spotfire Server
RUN /usr/local/bin/tibco/tss/7.11.3/configure -d -s 80 -r 9080 -b 9443

# fix line endings on fixservername.sh
RUN dos2unix fixservername.sh
RUN chmod 755 fixservername.sh 

######################### NOTE These steps only need to be done one time	
# update configuration - this step ONLY needs to be done once and not repeatedly, except for bootstrap creation
RUN if [ "$doconfig" = "true" ] ; then /usr/local/bin/tibco/tss/7.11.3/tomcat/bin/config.sh run tss_simpleconfig.txt ; fi

# update deployment
RUN if [ "$doconfig" = "true" ] ; then /usr/local/bin/tibco/tss/7.11.3/tomcat/bin/config.sh update-deployment --bootstrap-config /usr/local/bin/tibco/tss/7.11.3/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml \
    --tool-password $toolpwd --area Production /Spotfire.Dxp.sdn ; fi

# set auto trust (could be done using a file with the command sets)
## /usr/local/bin/tibco/tss/7.11.3/tomcat/bin/config.sh run set-auto-trust.txt
RUN if [ "$doconfig" = "true" ] ; then /usr/local/bin/tibco/tss/7.11.3/tomcat/bin/config.sh export-config --bootstrap-config /usr/local/bin/tibco/tss/7.11.3/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml --tool-password $toolpwd /usr/local/bin/tibco/tss/7.11.3/tomcat/bin/configuration.xml ; fi

RUN if [ "$doconfig" = "true" ] ; then /usr/local/bin/tibco/tss/7.11.3/tomcat/bin/config.sh set-config-prop --configuration /usr/local/bin/tibco/tss/7.11.3/tomcat/bin/configuration.xml --bootstrap-config /usr/local/bin/tibco/tss/7.11.3/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml --name=security.trust.auto-trust.enabled --value=true ; fi

RUN if [ "$doconfig" = "true" ] ; then /usr/local/bin/tibco/tss/7.11.3/tomcat/bin/config.sh import-config --bootstrap-config /usr/local/bin/tibco/tss/7.11.3/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml --tool-password $toolpwd --comment "Set security.trust.auto-trust.enabled to True" --delete-file true /usr/local/bin/tibco/tss/7.11.3/tomcat/bin/configuration.xml ; fi

# promote user to admin user
RUN if [ "$doconfig" = "true" ] ; then /usr/local/bin/tibco/tss/7.11.3/tomcat/bin/config.sh promote-admin --tool-password $toolpwd --username $adminuser ; fi

# if configuration done then need to remove bootstrap.xml file
RUN if [ "$doconfig" = "true" ] ; then if [ -f /usr/local/bin/tibco/tss/7.11.3/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml ] ; then rm /usr/local/bin/tibco/tss/7.11.3/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml; fi ; fi

EXPOSE 80
EXPOSE 9443
EXPOSE 9080

# Sets a command or process that will run each time a container is run from the new image.
## Need to create bootstrap when docker container is created
ENTRYPOINT ./fixservername.sh && /bin/bash
