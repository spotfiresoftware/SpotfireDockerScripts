# Dockerfile for SpotfireServer
## use with - docker build -m 3GB -t tsswin --build-arg toolpwd=spotfire --build-arg adminuser=spotfire --build-arg doconfig=true .
## ARGUMENTS TO Dockerfile
##		toolpwd - if doconfig=true, then pass in the configuration tool password as set in the tss_simpleconfig.txt 
##				using the CONFIG_TOOL_PASSWORD variable.
##		adminuser - if doconfig=true, then this user will be promoted to an admin user.  The user is created by 
##				the tss_simpleconfig.txt using the ADMIN_USER variable.
## 		doconfig - true or false (or missing).  If true, then the configuration section of the Dockerfile will be run.
##				The configuration only needs to run once such that one can turn if off and on if it has already run.
##

### to create a container from the tss image use
## docker run -it -d -p 80:80 -m 3GB --cpus=2 --name tsswin3gb tsswin

#### TODO: BEFORE RUNNING THIS SCRIPT MAKE SURE TO UPDATE Any of the installation paths and ports

# Indicates that the windowsservercore image will be used as the base image.
# Change this line if you want a different Windows base image
FROM mcr.microsoft.com/windows/servercore:ltsc2016

# Metadata indicating an image maintainer.
MAINTAINER pmckinni@tibco.com

ARG toolpwd
ARG adminuser
ARG doconfig

# Copy over files that are needed all at once in case some files are missing
# Spotfire.Dxp.sdn and tss_simpleconfig.txt are ONLY needed for initial configuration and setup items
COPY setup-win64.exe fixservername.bat Spotfire.Dxp.sd[n] tss_simpleconfig.tx[t]  c:/

# install Spotfire Server
RUN setup-win64.exe /s /v"/qn /l*vx TSS_install.log DOWNLOAD_THIRD_PARTY=No INSTALLDIR=C:\tibco\tss\7.11.3 SPOTFIRE_WINDOWS_SERVICE=DoNotCreate \
    SERVER_FRONTEND_PORT=80 SERVER_BACKEND_REGISTRATION_PORT=9080 SERVER_BACKEND_COMMUNICATION_PORT=9443 NODEMANAGER_HOST_NAMES="

############# START CONFIGURATION SECTION

## TODO: MAKE SURE TO UPDATE ANY PATHS TO MATCH THE INSTALLDIR INSTALLATION PATH

######## NOTE These steps only need to be done one time	when doing initial configuration
# update configuration - this step ONLY needs to be done once and not repeatedly, except for bootstrap creation
RUN if "%doconfig%"=="true" ( c:\tibco\tss\7.11.3\tomcat\bin\config run tss_simpleconfig.txt )

# update deployment
RUN if "%doconfig%"=="true" ( c:\tibco\tss\7.11.3\tomcat\bin\config update-deployment --bootstrap-config c:\tibco\tss\7.11.3\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml \
    --tool-password %toolpwd% --area Production c:\Spotfire.Dxp.sdn )

# set auto trust (could be done using a file with the command sets)
## c:\tibco\tss\7.11.3\tomcat\bin\config run set-auto-trust.txt
RUN if "%doconfig%"=="true" ( c:\tibco\tss\7.11.3\tomcat\bin\config export-config --bootstrap-config c:\tibco\tss\7.11.3\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml --tool-password %toolpwd% c:\tibco\tss\configuration.xml )

RUN if "%doconfig%"=="true" ( c:\tibco\tss\7.11.3\tomcat\bin\config set-config-prop --configuration c:\tibco\tss\configuration.xml --bootstrap-config c:\tibco\tss\7.11.3\tomcat\webapps\%toolpwd%\WEB-INF\bootstrap.xml --name=security.trust.auto-trust.enabled --value=true )

RUN if "%doconfig%"=="true" ( c:\tibco\tss\7.11.3\tomcat\bin\config import-config --bootstrap-config c:\tibco\tss\7.11.3\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml --tool-password %toolpwd% --comment "Set security.trust.auto-trust.enabled to True" --delete-file true c:\tibco\tss\configuration.xml )

# promote user to admin user
RUN if "%doconfig%"=="true" ( c:\tibco\tss\7.11.3\tomcat\bin\config promote-admin --tool-password %toolpwd% --username %adminuser% )

# if configuration done then need to remove bootstrap.xml file
RUN if "%doconfig%"=="true" ( if exist c:\tibco\tss\7.11.3\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml (del c:\tibco\tss\7.11.3\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml) )

############# END CONFIGURATION SECTION

## manually install service
WORKDIR /tibco/tss/7.11.3/tomcat/bin
RUN service.bat install

#### TODO: UPDATE SERVICE NAME IN THIS COMMAND BASED ON VERSION INSTALLING, e.g. 7.11.3 would be Tss7113.
# Set Service to manual
RUN sc config "Tss7113" start=demand

EXPOSE 80
EXPOSE 9443
EXPOSE 9080

WORKDIR /

# Sets a command or process that will run each time a container is run from the new image.
#CMD cmd
## Need to create bootstrap when docker container is created
CMD ["cmd", "/k", "/fixservername.bat"]
