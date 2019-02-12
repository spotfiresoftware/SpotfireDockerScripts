# Dockerfile for TIBCO Spotfire Statistics Services
## use with - docker build -m 3GB -t tsss .
### to create a container from the tsss image use
## docker run -it -d -p 80:80 -m 3GB --cpus=2 --name tsss3gb tsss

# Indicates that the windowsservercore image will be used as the base image.
FROM microsoft/windowsservercore

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

# Copy over files that are needed
COPY TSSS_7.11.0_win_x86_64.exe c:/TSSS_7.11.1_win_x86_64.exe
COPY TSSSInstallFile.txt c:/TSSSInstallFile.txt


# install TIBCO Spotfire Statistics Services
EXPOSE 8080
EXPOSE 9004
RUN TSSS_7.11.1_win_x86_64.exe -f c:/TSSSInstallFile.txt

# Set Service to manual
RUN sc config "TSSS711SplusServer" start=auto

EXPOSE 8080
EXPOSE 9004
