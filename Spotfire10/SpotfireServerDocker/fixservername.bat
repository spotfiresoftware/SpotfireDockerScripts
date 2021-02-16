REM TODO: Change the database settings and connection URL as needed
REM Make sure to Update the path and the service name if installing a new version

REM Requires the following environment variables to do setup configuration if needed
REM Script will determine if configuration is needed or not
REM **** ENVIRONMENT VARIABLES
REM *REQUIRED 
REM    	DB_DRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver" 
REM    	DB_URL="jdbc:sqlserver://172.31.14.28:1433;DatabaseName=spotfire1039_docker" 
REM    	DB_USER="spotfire1039" 
REM    	DB_PASSWORD="spotfire1039"
REM    	CONFIG_TOOL_PASSWORD="spotfire"
REM		ADMIN_USER="spotfire"
REM		ADMIN_PASSWORD="spotfire"
REM 
REM *OPTIONAL
REM    	TSSNAME - will use COMPUTERNAME if does not exist
REM		DEPLOY_TERR - true or false
REM		SET_AUTO_TRUST - false or default of true

setlocal EnableDelayedExpansion

set TSSDIR=C:\tibco\tss\10.3.9\tomcat
set TSSCONFIGFILE=C:\TestConfig.xml

if not exist %TSSDIR%\webapps\spotfire\WEB-INF\bootstrap.xml (

	REM cd %TSSDIR%\spotfire-bin

	if not defined TSSNAME ( set TSSNAME=!COMPUTERNAME!	)
	
	echo TSSNAME=!TSSNAME!

	echo Creating the bootstrap file
	
	%TSSDIR%\spotfire-bin\config bootstrap --no-prompt --driver-class=!DB_DRIVER! --database-url=!DB_URL! --username=!DB_USER! --password=!DB_PASSWORD! --tool-password=!CONFIG_TOOL_PASSWORD! --server-alias=!TSSNAME! -A!TSSNAME!

	echo Checking configuration

	REM Check to see if a configuration already exists or not
	%TSSDIR%\spotfire-bin\config export-config --tool-password="%CONFIG_TOOL_PASSWORD%" %TSSCONFIGFILE%
	
	if not exist %TSSCONFIGFILE% (
	    REM Need to create configuration

		REM ############# START CONFIGURATION SECTION

		REM ## TODO: MAKE SURE TO UPDATE ANY PATHS TO MATCH THE INSTALLDIR INSTALLATION PATH

		REM ######## NOTE These steps only need to be done one time	when doing initial configuration
		REM # update configuration - this step ONLY needs to be done once and not repeatedly, except for bootstrap creation
		REM # DO SIMPLE Configuration 
		echo Creating the default configuration
		%TSSDIR%\spotfire-bin\config create-default-config --force %TSSCONFIGFILE%
		
		echo Importing the configuration
		%TSSDIR%\spotfire-bin\config import-config --tool-password="%CONFIG_TOOL_PASSWORD%" --comment="Initial Configuration" %TSSCONFIGFILE%

		REM # update deployment
		%TSSDIR%\spotfire-bin\config update-deployment --bootstrap-config %TSSDIR%\webapps\spotfire\WEB-INF\bootstrap.xml --tool-password="%CONFIG_TOOL_PASSWORD%" --area Production c:\Spotfire.Dxp.sdn

		REM # deploy TERR as a service deployment
		if "%DEPLOY_TERR%"=="true" ( 
			%TSSDIR%\spotfire-bin\config update-deployment --bootstrap-config %TSSDIR%\webapps\spotfire\WEB-INF\bootstrap.xml --tool-password="%CONFIG_TOOL_PASSWORD%" --area Production c:\Spotfire.Dxp.TerrServiceWindows.sdn 
		)

		REM # set auto trust - SET_AUTO_TRUST default is true 
		if not "%SET_AUTO_TRUST%"=="false" (
			%TSSDIR%\spotfire-bin\config set-config-prop --configuration=%TSSCONFIGFILE% --name=security.trust.auto-trust.enabled --value=true
			echo Importing the configuration with auto trust enabled
			%TSSDIR%\spotfire-bin\config import-config --tool-password="%CONFIG_TOOL_PASSWORD%" --comment="Enabling Auto Trust" %TSSCONFIGFILE%
		)
		
		echo Creating the '${ADMIN_USER}' user to become administrator
		%TSSDIR%\spotfire-bin\config create-user --tool-password="%CONFIG_TOOL_PASSWORD%" --username="%ADMIN_USER%" --password="%ADMIN_PASSWORD%"
		echo

		echo Promoting the user '${ADMIN_USER}' to administrator
		%TSSDIR%\spotfire-bin\config promote-admin --tool-password="%CONFIG_TOOL_PASSWORD%" --username="%ADMIN_USER%"
		echo	

		REM ############# END CONFIGURATION SECTION
	
	) 

	REM Remove configuration file - either created now or created when testing configuration
	del %TSSCONFIGFILE%
	
	sc config "Tss1039" start=auto
	net start "Tss1039"

)
