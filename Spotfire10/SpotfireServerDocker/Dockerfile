# Dockerfile for SpotfireServer - 7.13 and above - currently done for Spotfire 10
## use with - docker build -m 3GB -t tss --build-arg toolpwd=spotfire --build-arg adminuser=spotfire .
### to create a container from the tss image use
## docker run -it -d -p 80:80 -m 4GB --cpus=2 --name tss3gb tss

## NOTE: Make sure to change install directory names and Service name when installing another version

# Indicates that the windowsservercore image will be used as the base image.
FROM microsoft/windowsservercore

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

ARG toolpwd
ARG adminuser

# Copy over files that are needed
COPY setup-win64.exe c:/setup-win64.exe
COPY fixservername.bat C:/fixservername.bat
### Only needed for initial configuration and setup items
#COPY Spotfire.Dxp.sdn C:/Spotfire.Dxp.sdn
#COPY tss_simpleconfig.txt C:/tss_simpleconfig.txt

# install Spotfire Server - NOTE: as of January 31, 2019 the installer ignores all parameters
RUN setup-win64.exe DOWNLOAD_THIRD_PARTY=No INSTALLDIR=C:\tibco\tss\10.0.1 SPOTFIRE_WINDOWS_SERVICE=Create SERVER_FRONTEND_PORT=80 SERVER_BACKEND_REGISTRATION_PORT=9080 SERVER_BACKEND_COMMUNICATION_PORT=9443 NODEMANAGER_HOST_NAMES= -silent -log C:\TSS_Install.log

######################### NOTE These steps only need to be done one time	
# update configuration - this step ONLY needs to be done once and not repeatedly, except for bootstrap creation
#RUN C:	ibco	ss\10.0.1\tomcat\bin\config run tss_simpleconfig.txt

# update deployment
#RUN C:	ibco	ss\10.0.1\tomcat\bin\config update-deployment --bootstrap-config C:	ibco	ss\10.0.1\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml \
#    --tool-password %toolpwd% --area Production c:\Spotfire.Dxp.sdn

# set auto trust (could be done using a file with the command sets)
## c:\tibco\tss\10.0.1\tomcat\bin\config run set-auto-trust.txt
#RUN C:	ibco	ss\10.0.1\tomcat\bin\config export-config --bootstrap-config C:	ibco	ss\10.0.1\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml --tool-password %toolpwd% c:\tibco\tss\configuration.xml

#RUN C:	ibco	ss\10.0.1\tomcat\bin\config set-config-prop --configuration c:\tibco\tss\configuration.xml --bootstrap-config C:	ibco	ss\10.0.1\tomcat\webapps\%toolpwd%\WEB-INF\bootstrap.xml --name=security.trust.auto-trust.enabled --value=true

#RUN C:	ibco	ss\10.0.1\tomcat\bin\config import-config --bootstrap-config C:	ibco	ss\10.0.1\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml --tool-password %toolpwd% --comment "Set security.trust.auto-trust.enabled to True" --delete-file true c:\tibco\tss\configuration.xml

# promote user to admin user
#RUN C:	ibco	ss\10.0.1\tomcat\bin\config promote-admin --tool-password %toolpwd% --username %adminuser%

# if configuration done then need to remove bootstrap.xml file
#RUN	if exist C:	ibco	ss\10.0.1\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml (del c:\tibco\tss\10.0.1\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml)


# WORKAROUND for issue NOTE: as of January 31, 2019 the tomcat9.exe file does not get installed correctly
#COPY tomcat9.exe C:/tibco/tss/10.0.1/tomcat/bin/tomcat9.exe

## manually install service
#WORKDIR /tibco/tss/10.0.1/tomcat/bin
#RUN service.bat install

# Set Service to manual
RUN sc config "Tss1001" start=demand

EXPOSE 80
EXPOSE 9443
EXPOSE 9080

WORKDIR /

# Sets a command or process that will run each time a container is run from the new image.
#CMD cmd
## Need to create bootstrap when docker container is created
CMD ["cmd", "/k", "/fixservername.bat"]
