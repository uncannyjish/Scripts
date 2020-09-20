@echo off

::::::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights V2
::::::::::::::::::::::::::::::::::::::::::::

CLS
ECHO.
ECHO =============================
ECHO Running Admin shell
ECHO =============================

:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::

if not "%1" == "max" start /MAX cmd /c %0 max & exit/b

title Uncanny Windows Configuration Script

set flag=0

:entry
cls
echo.
echo.
echo ===========================================================================================
echo                           Uncanny Windows Congifuration Script
echo ===========================================================================================

if /i '%flag%' == '1' goto skip

:start
echo.
echo One Script that does it all.
echo.
echo.
echo Detecting System Status... (If you're low on data, please exit now)
timeout /t 3 /nobreak >nul
echo.
echo.
echo Installing the necessary packages...
echo.
echo.
powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
echo.
echo.
echo Configuring Chocolatey...
echo.
timeout /t 3 /nobreak >nul
set flag=1
goto entry

:skip
echo.
echo.
echo What do you want to do?
echo.
echo.
echo 1] Install Packages
echo.
echo 2] Update Packages
echo.
echo 3] Exit
echo.
echo.

set /p choice=Enter your choice:

if /i '%choice%' == '1' goto install
if /i '%choice%' == '2' goto update
if /i '%choice%' == '3' goto end

echo.
echo.
echo Can't you read?  Try again.
pause >nul
goto skip

:install
echo.
echo.
echo Select Your Package
echo.
echo.
echo 1] Basic
echo.
echo 2] Best
echo.
echo 3] Max
echo.
echo 4] Return to Main Menu
echo.
echo.

set /p choice=Enter your choice:

if /i '%choice%' == '1' ( 
	set package=basic
	goto proc
)
if /i '%choice%' == '2' (
	set package=best
	goto proc
)
if /i '%choice%' == '3' (
	set package=max
	goto proc
)
if /i '%choice%' == '4' goto skip

echo.
echo.
echo Can't you read?  Try again.
pause >nul
goto install

:update
echo.
echo.
echo Proceeding with Update...
echo.
timeout /t 3 /nobreak >nul
start /wait powershell.exe -ExecutionPolicy Bypass -WindowStyle Maximized -File "%~dp0scripts\update.ps1" -Verb RunAs
echo.
echo Update Completed. Returning to Main Menu...
timeout /t 3 /nobreak >nul
goto skip


:proc
echo.
echo.
echo Proceeding with Package Installation...
echo.
start /wait powershell.exe -WindowStyle Maximized -File "%~dp0scripts\scoop-install.ps1" -Verb RunAs
start /wait powershell.exe -ExecutionPolicy Bypass -WindowStyle Maximized -File "%~dp0scripts\scoop-packages.ps1" -Verb RunAs
start /wait powershell.exe -ExecutionPolicy Bypass -WindowStyle Maximized -File "%~dp0scripts\%package%.ps1" -Verb RunAs
echo.
echo.
echo Configuring Packages...
timeout /t 3 /nobreak
echo.
echo.
echo All Packages Installed Succesfully...
echo.
echo.
echo Installing Android USB Drivers...
echo.
pnputil /add-driver "%~dp0Driver\android_winusb.inf" /subdirs /install
echo.
echo Installing ADB System-Wide...
md "C:\Android\adb-fastboot"
copy "%~dp0adb-fastboot" "C:\Android\adb-fastboot"
setx /M path "%path%;C:\Android\adb-fastboot"
echo.
echo Installation Complete. Returning to Main Menu...
timeout /t 3 /nobreak >nul
goto entry

pause