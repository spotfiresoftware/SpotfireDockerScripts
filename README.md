# SpotfireDockerScripts
These directories include scripts for working with TIBCO Spotfire components in a Docker environment.  They are initial scripts tested within a non-enterprise environment.  

NOTE: Containerization is not officially supported in TIBCO Spotfire at this time (November 28, 2018).  Containerization may be supported in the future.

The scripts have been split into Spotfire7.11 and Spotfire10 directories.  The docker scripts in Spotfire7.11 should work with Spotfire 7.12 and earlier versions (they were tested with 7.11.3). The silent installation command changed in Spotfire 7.13 so the scripts in Spotfire10 should work with Spotfire 7.13 (they were tested with Spotfire 10.3.0).    In Spotfire Server 10.3, some of the directories where one finds the Spotfire scripts are different, thus the scripts for Spotfire 10.3 and Spotfire 10.2 also differ.  The Spotfire config.sh/config.bat command-line program is now in tomcat/spotfire-bin instead of tomcat/bin. 

The purpose of this information is to help one get started with using TIBCO Spotfire Server and TIBCO Spotfire Node Manager with Docker Containers.  The Docker and Spotfire Server software may change overtime.  The testing in this document was done with Spotfire version 7.11 and 10 and Docker engine version 18.09.2 on Windows.  The Spotfire install scripts likely will not change much between versions, but one should be aware of this possibility.

Please see the TIBCO Community article for more information - [TIBCO Spotfire Server Docker Scripts](https://community.tibco.com/wiki/tibco-spotfirer-server-docker-scripts)

**NOTE: Any executable files, rpm files, and sdn (Spotfire deployment files) MUST be obtained from the TIBCO Software download site and are not provided as part of the GitHub files.**  For example, the Dockerfile for Spotifre Server for Windows references the setup-win64.exe, the Spotfire.Dxp.sdn and the tss_simpleconfig.txt file which are not in the directory downloaded from GitHub.  The setup-win64.exe file comes from the TIB_sfire_server_<version>_win.zip file available from the TIBCO Software download site.  The Spotfire.Dxp.sdn file is part of the TIB_sfire_deploy_<version>.zip file.  The tss_simpleconfig.txt file is part of the GitHub scripts but is in the SpotfireServerConfig directory.  Please see the referenced TIBCO Community article for more information.

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
  * SpotfireServerLinuxDocker
    * Dockerfile – Docker image build file
    * fixservername.sh – batch file for startup of Spotfire Server Docker container that fixes the 
  * SpotfireStatisticsServices
    * Dockerfile – Docker image build file
    * TSSSInstallFile.txt - Silent installation property file for TIBCO Spotfire Statistics Services.
  * SpotfireStatisticsServicesLinux
    * Dockerfile – Docker image build file
    * TSSSInstallFile.txt - Silent installation property file for TIBCO Spotfire Statistics Services.
* Spotfire10 - Contains same files as above except is missing SpotfireStatisticsServices and SpotfireStatisticsServicesLinux and contains the following additional directories
  * NodeManagerTERRDocker
    * defaultTS.conf – default configuration for TERR Service Services instance
    * Dockerfile – Docker image build file
    * fixnmproperties.bat – batch file for startup of Node Manager Docker container that fixes the node manager machine name
    * fixnmproperties.ps1 – PowerShell script called by fixnmproperties.bat
  * NodeManagerTERRLinuxDocker
    * defaultTS.conf – default configuration for TERR Service Services instance
    * Dockerfile – Docker image build file
    * fixnmproperties.sh – batch file for startup of Node Manager Docker container that fixes the node manager machine name
    
## Example Docker Build and Run Commands
The following are example docker build and run commands for the various components provided with these scripts:

 * Spotfire Server - Windows
    * Docker build with config
       * docker build -m 3GB -t tsswin --build-arg toolpwd=spotfire --build-arg adminuser=spotfire --build-arg doconfig=true .
    * Docker build with config and deploy TERR Service deployment package
       * docker build -m 3GB -t tsswin --build-arg toolpwd=spotfire --build-arg adminuser=spotfire --build-arg doconfig=true --build-arg deployTERR=true .
    * Docker build with config set to false
       * docker build -m 3GB -t tsswin_noconfig --build-arg doconfig=false .
    * Docker run examples
       * docker run -it -d -p 80:80 -m 4GB --cpus=2 --name tss_3gb tsswin
       * docker run -it -d -p 80:80 -m 4GB --cpus=2 --name tss_nc tsswin_noconfig
 * Spotfire Server - Linux
    * Docker build with config
       * docker build -m 3GB -t tsslinux --build-arg toolpwd=spotfire --build-arg adminuser=spotfire --build-arg doconfig=true --build-arg deployTERR=true .
    * Docker build with config set to false and no doconfig argument
       * docker build -m 3GB -t tsslinux_nc --build-arg toolpwd=spotfire --build-arg adminuser=spotfire --build-arg doconfig=false .
       * docker build -m 3GB -t tsslinux_nc3 .
    * Docker run examples
       * docker run -it -d -p 80:80 -m 3GB --cpus=2 --name tsslinux3gb tsslinux
       * docker run -it -d -p 80:80 -m 3GB --cpus=2 --name tsslinux3gb_nc tsslinux_nc
 * Web Player - Windows
    * Docker build
       * docker build -m 3GB -t tsnm_wp --build-arg tssname=0d586b4ec2e2 .
    * Docker run
       * docker run -it -d -m 3GB --cpus=2 --name tsnmwp3gb tsnm_wp
 * Automation Services - Windows
    * Docker build
       * docker build -m 3GB -t tsnm_as103 --build-arg tssname=0d586b4ec2e2 .
    * Docker run
       * docker run -it -d -m 3GB --cpus=2 --name tsnmas3gb tsnm_as
 * TERR Service - Windows
    * Docker build
       * docker build -m 3GB -t tsnm_ts --build-arg tssname=40b6472b7c12 .
    * Docker run
       * docker run -it -d -m 3GB --cpus=2 --name tsnmts tsnm_ts
 * TERR Service - Linux  (Note: containers need to be disabled since docker in docker does not work)
    * Docker build
       * docker build -m 3GB -t tsnmts_linux --build-arg tssname=172.17.0.2 .
    * Docker run
       * docker run -it -d -m 3GB --cpus=2 --name tsnmts tsnmts_linux
 * TIBCO Spotfire Statistics Services (TSSS) - Wndows
    * Docker build
       * docker build -m 3GB -t tssswin .
    * Docker run
       * docker run -it -d -p 8080:8080 -m 3GB --cpus=2 --name tsss3gb tssswin
 * TIBCO Spotfire Statistics Services (TSSS) - Linux
    * Docker build
       * docker build -m 3GB -t tssslinux .
    * Docker run
       * docker run -it -d -p 8081:8080 -m 3GB --cpus=2 --name tsss3gb tssslinux

### Versioning
  
  1. September 2018 - Initial version with Windows Docker Scripts for Spotfire 7.11
  2. December 2018 - Added scripts to GitHub and Community Article
  3. February 2019 - Added scripts for Spotfire 10 for silent installation change in 7.13 and TSSS 7.11 scripts
  4. March 2019 - Added Spotfire Server Linux 7.11 scripts
  5. May 2019
      * Added build-arg to support turning on/off configuration steps (doconfig)
      * Updated images to pull for Microsoft Windows Server Core
      * Updated 7.11 scripts to 7.11.3
      * Updated Spotfire10 scripts to 10.3 to handle changes in directory structure and additional TERR Node Manager
      * Added additional Linux scripts for TSSS and Node Manager for the TERR service
