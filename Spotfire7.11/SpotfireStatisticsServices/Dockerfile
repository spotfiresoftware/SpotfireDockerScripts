# Dockerfile for TIBCO Spotfire Statistics Services
## use with - docker build -m 3GB -t tssswin .
### to create a container from the tsss image use
## docker run -it -d -p 8080:8080 -m 3GB --cpus=2 --name tsss3gb tssswin

# Indicates that the windowsservercore image will be used as the base image.
# Change this line if you want a different Windows base image
FROM mcr.microsoft.com/windows/servercore:ltsc2016

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

# Copy over files that are needed
COPY TSSS_7.11.2_win_x86_64.exe c:/TSSS_7.11.2_win_x86_64.exe
COPY TSSSInstallFile.txt c:/TSSSInstallFile.txt

# install TIBCO Spotfire Statistics Services
RUN TSSS_7.11.2_win_x86_64.exe -f c:/TSSSInstallFile.txt

## NOTE: We have seen in some environments that TSSS uses the CPU count from the host instead of the container
## This following set of code will set a limit on the number of engines - the engine.count value
### TODO: MODIFY PATH HERE TO INSTALL PATH FROM TSSSInstallFile.txt and Service Name
#WORKDIR /TIBCO/statsvcs711/TERR/tomcat/bin

#RUN TSSS711TERR.exe //US//TSSS711TERR ++JvmOptions=-Dengine.count=2

#WORKDIR /

# Set Service to automatic
RUN sc config "TSSS711TERR" start=auto

EXPOSE 8080
EXPOSE 9004
