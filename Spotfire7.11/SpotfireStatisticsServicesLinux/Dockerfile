# Dockerfile for TIBCO Spotfire Statistics Services
## use with - docker build -m 3GB -t tssslinux .
### to create a container from the tsss image use
## docker run -it -d -p 8081:8080 -m 3GB --cpus=2 --name tsss3gb tssslinux

# Indicates that the windowsservercore image will be used as the base image.
# Change this line if you want a different Windows base image
FROM centos

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

# Copy over files that are needed
COPY TSSS_7.11.2_linux24gl23_x86_64.bin /TSSS_7.11.2_linux24gl23_x86_64.bin
COPY TSSSInstallFile.txt /TSSSInstallFile.txt

## Before installing need unzip
RUN yum -y install unzip

# install TIBCO Spotfire Statistics Services
RUN ./TSSS_7.11.2_linux24gl23_x86_64.bin -f /TSSSInstallFile.txt

### TODO: MODIFY PATH HERE TO INSTALL PATH FROM TSSSInstallFile.txt and Service Name
RUN /opt/TIBCO/statsvcs711/TERR/init.d/register-service.sh

EXPOSE 8080
EXPOSE 9004

# Sets a command or process that will run each time a container is run from the new image.
## Need to create bootstrap when docker container is created
ENTRYPOINT /opt/TIBCO/statsvcs711/TERR/init.d/spserver start && /bin/bash
