#!/bin/bash

#TODO: Change the database settings and connection URL as needed

# Check that bootstrap does not exist
if test ! -f /opt/tibco/tss/10.3.0/tomcat/webapps/spotfire/WEB-INF/bootstrap.xml
then

	pushd /opt/tibco/tss/10.3.0/tomcat/spotfire-bin

	./catalina.sh stop

	DB_DRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver"
	DB_URL="jdbc:sqlserver://192.168.40.1:1433;DatabaseName=spotfire_server"
	DB_USER="spotfire_server"
	DB_PASSWORD="spotfire_server"
	CONFIG_TOOL_PASSWORD="spotfire"
	IPADDR=`hostname -I`
	echo Creating the database connection configuration
	#./config.sh bootstrap --no-prompt --driver-class=$DB_DRIVER --database-url=$DB_URL --username=$DB_USER --password=$DB_PASSWORD --tool-password=$CONFIG_TOOL_PASSWORD --server-alias=$HOSTNAME  -A$HOSTNAME
	./config.sh bootstrap --no-prompt --driver-class=$DB_DRIVER --database-url=$DB_URL --username=$DB_USER --password=$DB_PASSWORD --tool-password=$CONFIG_TOOL_PASSWORD --server-alias=$IPADDR  -A$IPADDR

	echo after bootstrap

	./catalina.sh start

	popd

fi

## need to start server when machine starts up
pushd /opt/tibco/tss/10.3.0/tomcat/bin

./catalina.sh start

popd


