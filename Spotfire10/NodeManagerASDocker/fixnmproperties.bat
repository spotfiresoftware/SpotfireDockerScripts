REM Make sure to modify the installation directory when installing another version
REM Update Path to config if needed

PUSHD .

cd \tibco\tsnm\10.3.0\nm\config

REM ONLY perform the action if the nodemanager has not already started

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '\fixnmproperties.ps1'"

POPD
