## TODO: Change service name if needed

## Check to see if supervisor already changed file or not
$modBySupervisor = Get-Content ".\nodemanager.properties" | %{$_ -match "Supervisor changed"}

if (!($modBySupervisor -contains $true))
{
	(Get-Content .\nodemanager.properties)  -replace "nodemanager.host.names=.*$", "nodemanager.host.names=$env:computername" | Set-Content .\nodemanager.properties -force -encoding ascii

	sc.exe config "WpNmRemote1030" start=auto
	net.exe start "WpNmRemote1030"
}
