REM Update Path to config if needed

PUSHD .

cd \tibco\tsnm\7.11.3\nm\config

REM ONLY perform the action if the nodemanager has not already started

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '\fixnmproperties.ps1'"

POPD
