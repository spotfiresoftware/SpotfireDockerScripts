

PUSHD .

cd \tibco\tsnm\7.11.0\nm\config

REM ONLY perform the action if the nodemanager has not already started

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '\fixnmproperties.ps1'"
REM "cat nodemanager.test | % {$_ -replace \"nodemanager.host.names=.*$\", \"nodemanager.host.names=$env:computername\"} > nodemanager.out"

REM del nodemanager.properties
REM ren nodemanager.out nodemanager.properties

REM sc config "WpNmRemote7110" start=auto
REM net start "WpNmRemote7110"

POPD
