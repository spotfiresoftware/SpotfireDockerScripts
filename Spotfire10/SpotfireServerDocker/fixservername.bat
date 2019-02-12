REM Make sure to Update the path and the service name if installing a new version
REM Make sure to update the DB variables for a different database

setlocal EnableDelayedExpansion

if not exist C:\tibco\tss\10.0.1\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml (

	PUSHD .
	
	cd \tibco\tss\10.0.1\tomcat\bin


	set DB_DRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver"
	set DB_URL="jdbc:sqlserver://192.168.40.1:1433;DatabaseName=spotfire_server10"
	set DB_USER="spotfire10"
	set DB_PASSWORD="spotfire10"
	set CONFIG_TOOL_PASSWORD="spotfire"
	echo Creating the database connection configuration
	cmd /c "config bootstrap --no-prompt --driver-class=!DB_DRIVER! --database-url=!DB_URL! --username=!DB_USER! --password=!DB_PASSWORD! --tool-password=!CONFIG_TOOL_PASSWORD! --server-alias=!COMPUTERNAME!"

	echo after bootstrap
	REM config update-bootstrap --server-alias=%COMPUTERNAME%

	sc config "Tss1001" start=auto
	net start "Tss1001"

	REM sc config "Tss7110" start=auto
	REM net start "Tss7110"

	POPD

)
