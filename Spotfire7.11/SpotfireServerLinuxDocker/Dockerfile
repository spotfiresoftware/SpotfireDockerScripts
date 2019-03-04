# Dockerfile for SpotfireServer on Linux
## use with - docker build -m 3GB -t tsslinux .
## if needed add build-args: --build-arg toolpwd=spotfire --build-arg adminuser=spotfire
### to create a container from the tss image use
## docker run -it -d -p 80:80 -m 3GB --cpus=2 --name tsslinux3gb tsslinux

# Indicates that the centos image will be used as the base image.
FROM centos

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

#ARG toolpwd
#ARG adminuser

# Copy over files that are needed
COPY tss-7.11.2.x86_64.rpm /tss-7.11.2.x86_64.rpm
COPY fixservername.sh /fixservername.sh
### Only needed for initial configuration and setup items
#COPY Spotfire.Dxp.sdn C:/Spotfire.Dxp.sdn
#COPY tss_simpleconfig.txt C:/tss_simpleconfig.txt

## Before using rpm need wget and unzip; dos2unix needed to convert fixservername.sh file
RUN yum -y install wget unzip dos2unix

# install Spotfire Server
RUN rpm -ivh tss-7.11.2.x86_64.rpm
# configure Spotfire Server
RUN /usr/local/bin/tibco/tss/7.11.2/configure -d -s 80 -r 9080 -b 9443

# fix line endings on fixservername.sh
RUN dos2unix fixservername.sh
RUN chmod 755 fixservername.sh 

######################### NOTE These steps only need to be done one time	
# update configuration - this step ONLY needs to be done once and not repeatedly, except for bootstrap creation
#RUN /usr/local/bin/tibco/tss/7.11.2/tomcat/bin/config.sh run tss_simpleconfig.txt

# update deployment
#RUN /usr/local/bin/tibco/tss/7.11.2/tomcat/bin/config.sh update-deployment --bootstrap-config /usr/local/bin/tibco/tss/7.11.2/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml \
#    --tool-password %toolpwd% --area Production /Spotfire.Dxp.sdn

# set auto trust (could be done using a file with the command sets)
## /usr/local/bin/tibco/tss/7.11.2/tomcat/bin/config.sh run set-auto-trust.txt
#RUN /usr/local/bin/tibco/tss/7.11.2/tomcat/bin/config.sh export-config --bootstrap-config /usr/local/bin/tibco/tss/7.11.2/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml --tool-password %toolpwd% /usr/local/bin/tibco/tss/7.11.2/tomcat/bin/configuration.xml

#RUN /usr/local/bin/tibco/tss/7.11.2/tomcat/bin/config.sh set-config-prop --configuration /usr/local/bin/tibco/tss/7.11.2/tomcat/bin/configuration.xml --bootstrap-config /usr/local/bin/tibco/tss/7.11.2/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml --name=security.trust.auto-trust.enabled --value=true

#RUN /usr/local/bin/tibco/tss/7.11.2/tomcat/bin/config.sh import-config --bootstrap-config /usr/local/bin/tibco/tss/7.11.2/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml --tool-password %toolpwd% --comment "Set security.trust.auto-trust.enabled to True" --delete-file true c:\tibco\tss\configuration.xml

# promote user to admin user
#RUN /usr/local/bin/tibco/tss/7.11.2/tomcat/bin/config.sh promote-admin --tool-password %toolpwd% --username %adminuser%

# if configuration done then need to remove bootstrap.xml file
#RUN	if exist /usr/local/bin/tibco/tss/7.11.2/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml (del /usr/local/bin/tibco/tss/7.11.2/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml)

## manually install service
#WORKDIR /usr/local/bin/tibco/tss/7.11.2/tomcat/bin
#RUN ./catalina.sh stop

EXPOSE 80
EXPOSE 9443
EXPOSE 9080

#WORKDIR /

# Sets a command or process that will run each time a container is run from the new image.
## Need to create bootstrap when docker container is created
#CMD ["/bin/bash", "./fixservername.sh"]
#CMD ["/bin/bash"]
ENTRYPOINT ./fixservername.sh && /bin/bash
