#!/bin/bash

# Check that bootstrap does not exist
if test ! -f /usr/local/bin/tibco/tss/7.11.2/tomcat/bin/webapps/spotfire/WEB-INF/bootstrap.xml
then

	pushd /usr/local/bin/tibco/tss/7.11.2/tomcat/bin

	./catalina.sh stop

	DB_DRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver"
	DB_URL="jdbc:sqlserver://192.168.40.1:1433;DatabaseName=tssdocker7112"
	DB_USER="spotfire7112"
	DB_PASSWORD="spotfire7112"
	CONFIG_TOOL_PASSWORD="spotfire"
	echo Creating the database connection configuration
	./config.sh bootstrap --no-prompt --driver-class=$DB_DRIVER --database-url=$DB_URL --username=$DB_USER --password=$DB_PASSWORD --tool-password=$CONFIG_TOOL_PASSWORD --server-alias=$HOSTNAME

	echo after bootstrap
	# config update-bootstrap --server-alias=%COMPUTERNAME%

	./catalina.sh start

	popd

fi

