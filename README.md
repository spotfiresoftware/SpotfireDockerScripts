# SpotfireDockerScripts
These directories include scripts for working with TIBCO Spotfire components in a Docker environment.  They are initial scripts tested within a non-enterprise environment.  

The scripts have been split into Spotfire7.11 and Spotfire10 directories.  The docker scripts in Spotfire7.11 should work with Spotfire 7.12 and earlier versions (they were tested with 7.11). The silent installation command changed in Spotfire 7.13 so the scripts in Spotfire10 should work with Spotfire 7.13 (they were testing with Spotfire 10.0.1).

The purpose of this information is to help one get started with using TIBCO Spotfire Server and TIBCO Spotfire Node Manager with Docker Containers.  The Docker and Spotfire Server software may change overtime.  The testing in this document was done with Spotfire version 7.11 and 10 and Docker engine version 18.06.1 on Windows.  The Spotfire install scripts likely will not change much between versions, but one should be aware of this possibility.

Please see the TIBCO Community article for more information - [TIBCO Spotfire Server Docker Scripts](https://community.tibco.com/wiki/tibco-spotfirer-server-docker-scripts)

The folders in this repository contain the following files:
* Spotfire7.11
  * NodeManagerASDocker
    * defaultAS.conf – default configuration for Automation Services instance
    * Dockerfile – Docker image build file
    * fixnmproperties.bat – batch file for startup of Node Manager Docker container that fixes the node manager machine name
    * fixnmproperties.ps1 – PowerShell script called by fixnmproperties.bat
  * NodeManagerWPDocker
    * defaultWP.conf – default configuration for Web Player instance
    * Dockerfile – Docker image build file
    * fixnmproperties.bat – batch file for startup of Node Manager Docker container that fixes the node manager machine name
    * fixnmproperties.ps1 – PowerShell script called by fixnmproperties.bat
  * SpotfireServerConfig – extra configuration files to help with Spotfire server configuration
    * tss_createbootstrap.txt – Spotfire config script for creating bootstrap file
    * tss_simpleconfig.txt – Spotfire config script for simple initial server configuration
    * tss_simpleconfigldap.txt – Spotfire config script for simple LDAP initial server configuration
  * SpotfireServerDocker
    * Dockerfile – Docker image build file
    * fixservername.bat – batch file for startup of Spotfire Server Docker container that fixes the Spotfire Server bootstrap.xml file.
  * SpotfireStatisticsServices
    * Dockerfile – Docker image build file
    * TSSSInstallFile.txt - Silent installation property file for TIBCO Spotfire Statistics Services.
* Spotfire10 - Contains same files as above except is missing SpotfireStatisticsServices
  
