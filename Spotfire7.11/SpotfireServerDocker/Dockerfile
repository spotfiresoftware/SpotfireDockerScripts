# Dockerfile for SpotfireServer
## use with - docker build -m 3GB -t tss --build-arg toolpwd=spotfire --build-arg adminuser=spotfire .
### to create a container from the tss image use
## docker run -it -d -p 80:80 -m 3GB --cpus=2 --name tss3gb tss

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

# install Spotfire Server
RUN setup-win64.exe /s /v"/qn /l*vx TSS_install.log DOWNLOAD_THIRD_PARTY=No INSTALLDIR=C:\tibco\tss\7.11.0 SPOTFIRE_WINDOWS_SERVICE=DoNotCreate \
    SERVER_FRONTEND_PORT=80 SERVER_BACKEND_REGISTRATION_PORT=9080 SERVER_BACKEND_COMMUNICATION_PORT=9443 NODEMANAGER_HOST_NAMES="

######################### NOTE These steps only need to be done one time	
# update configuration - this step ONLY needs to be done once and not repeatedly, except for bootstrap creation
#RUN c:\tibco\tss\7.11.0\tomcat\bin\config run tss_simpleconfig.txt

# update deployment
#RUN c:\tibco\tss\7.11.0\tomcat\bin\config update-deployment --bootstrap-config c:\tibco\tss\7.11.0\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml \
#    --tool-password %toolpwd% --area Production c:\Spotfire.Dxp.sdn

# set auto trust (could be done using a file with the command sets)
## c:\tibco\tss\7.11.0\tomcat\bin\config run set-auto-trust.txt
#RUN c:\tibco\tss\7.11.0\tomcat\bin\config export-config --bootstrap-config c:\tibco\tss\7.11.0\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml --tool-password %toolpwd% c:\tibco\tss\configuration.xml

#RUN c:\tibco\tss\7.11.0\tomcat\bin\config set-config-prop --configuration c:\tibco\tss\configuration.xml --bootstrap-config c:\tibco\tss\7.11.0\tomcat\webapps\%toolpwd%\WEB-INF\bootstrap.xml --name=security.trust.auto-trust.enabled --value=true

#RUN c:\tibco\tss\7.11.0\tomcat\bin\config import-config --bootstrap-config c:\tibco\tss\7.11.0\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml --tool-password %toolpwd% --comment "Set security.trust.auto-trust.enabled to True" --delete-file true c:\tibco\tss\configuration.xml

# promote user to admin user
#RUN c:\tibco\tss\7.11.0\tomcat\bin\config promote-admin --tool-password %toolpwd% --username %adminuser%

# if configuration done then need to remove bootstrap.xml file
#RUN	if exist c:\tibco\tss\7.11.0\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml (del c:\tibco\tss\7.11.0\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml)

## manually install service
WORKDIR /tibco/tss/7.11.0/tomcat/bin
RUN service.bat install

# Set Service to manual
RUN sc config "Tss7110" start=demand

EXPOSE 80
EXPOSE 9443
EXPOSE 9080

WORKDIR /

# Sets a command or process that will run each time a container is run from the new image.
#CMD cmd
## Need to create bootstrap when docker container is created
CMD ["cmd", "/k", "/fixservername.bat"]
