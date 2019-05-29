REM TODO: Change the database settings and connection URL as needed
REM Make sure to Update the path and the service name if installing a new version

setlocal EnableDelayedExpansion

if not exist C:\tibco\tss\7.11.3\tomcat\webapps\spotfire\WEB-INF\bootstrap.xml (

	PUSHD .
	
	cd \tibco\tss\7.11.3\tomcat\bin


	set DB_DRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver"
	set DB_URL="jdbc:sqlserver://10.0.0.18:1433;DatabaseName=spotfire_server"
	set DB_USER="spotfire_server"
	set DB_PASSWORD="spotfire_server"
	set CONFIG_TOOL_PASSWORD="spotfire"
	echo Creating the database connection configuration
	cmd /c "config bootstrap --no-prompt --driver-class=!DB_DRIVER! --database-url=!DB_URL! --username=!DB_USER! --password=!DB_PASSWORD! --tool-password=!CONFIG_TOOL_PASSWORD! --server-alias=!COMPUTERNAME!"

	echo after bootstrap

	sc config "Tss7113" start=auto
	net start "Tss7113"

	POPD

)
