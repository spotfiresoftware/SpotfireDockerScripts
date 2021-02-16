#!/bin/bash

## TODO: Change service name if needed and Paths if needed
#
## Expects environment variables when building container, for example: --env TSSNAME=<SpotfireServerName>
#
#  TSSNAME is required
#  NODENAME is optional and if does not exist the built-in computername environment variable will be used
#

## TODO: change paths as needed
pushd /opt/tibco/tsnm/10.3.9/nm/config

# ONLY perform the action if the nodemanager has not already started

## Check to see if supervisor already changed file or not
if [ ! `grep -Fq "Supervisor changed" nodemanager.properties` ]
then

	sed -i.bak "s/^\(nodemanager.host.names=\).*/\1`hostname -I`/" nodemanager.properties

fi

popd

## need to start node manager when machine starts up
/etc/init.d/tss-nm-10.3.9 start
