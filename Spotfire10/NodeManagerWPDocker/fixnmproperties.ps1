## TODO: Change service name if needed
## Expects environment variables when building container, for example: --env TSSNAME=<SpotfireServerName>
#
#  TSSNAME is required
#  NODENAME is optional and if does not exist the built-in computername environment variable will be used
#

## Check to see if supervisor already changed file or not
$modBySupervisor = Get-Content ".\nodemanager.properties" | %{$_ -match "Supervisor changed"}

if (!($modBySupervisor -contains $true))
{
	if (-not (Test-Path env:NODENAME))
	{
		(Get-Content .\nodemanager.properties)  -replace "nodemanager.host.names=.*$", "nodemanager.host.names=$env:computername" | Set-Content .\nodemanager.properties -force -encoding ascii
	}
	else ## use NodeManager environment variable name
	{
		(Get-Content .\nodemanager.properties)  -replace "nodemanager.host.names=.*$", "nodemanager.host.names=$env:NODENAME" | Set-Content .\nodemanager.properties -force -encoding ascii
	}
	(Get-Content .\nodemanager.properties)  -replace "server.name=.*$", "server.name=$env:TSSNAME" | Set-Content .\nodemanager.properties -force -encoding ascii
	
	sc.exe config "WpNmRemote1039" start=auto
	net.exe start "WpNmRemote1039"
}
