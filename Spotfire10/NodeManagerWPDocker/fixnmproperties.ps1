## MAKE SURE TO MODIFY THE SERVICE NAME for the appropriate version

#cat nodemanager.properties | % {$_ -replace "nodemanager.host.names=.*$", "nodemanager.host.names=$env:computername"} > nodemanager.out
##$nmprops = Get-Content .\nodemanager.properties
##$nmprops.replace("nodemanager.host.names=.*$", "nodemanager.host.names=$env:computername") | out-file .\nodemanager.properties2 -force -encoding ascii

## Check to see if supervisor already changed file or not

$modBySupervisor = Get-Content ".\nodemanager.properties" | %{$_ -match "Supervisor changed"}

if (!($modBySupervisor -contains $true))
{
	(Get-Content .\nodemanager.properties)  -replace "nodemanager.host.names=.*$", "nodemanager.host.names=$env:computername" | Set-Content .\nodemanager.properties -force -encoding ascii

	sc.exe config "WpNmRemote1001" start=auto
	net.exe start "WpNmRemote1001"
}
