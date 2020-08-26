@echo off

if not "%1" == "max" start /MAX cmd /c %0 max & exit/b

title Uncanny Windows Configuration Script
set flag=0

:entry
cls
echo.
echo.
echo ===========================================================================================
echo                          Uncanny Windows Congifuration Script
echo ===========================================================================================

if /i '%flag%' == '1' goto skip

:start
echo.
echo One Script that does it all.
echo.
echo.
echo Detecting System Status... (If you're low on data, please exit now)
timeout /t 5 /nobreak
echo.
echo.
echo Installing the necessary packages
echo.
echo.
powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
echo.
echo.
echo Configuring Chocolatey...
echo.
timeout /t 5 /nobreak
set flag=1
goto entry

:skip
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
echo What do you want to do?
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
if /i '%choice%' == '3' goto (
	set package=max
	goto proc
)
if /i '%choice%' == '4' goto end

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
timeout /t 5 /nobreak
start /wait powershell.exe -ExecutionPolicy Bypass -WindowStyle Maximized -File "%~dp0scripts\update.ps1" -Verb RunAs
echo.
echo Update Completed. Returning to Main Menu...
/timeout /t 5 /nobreak
goto skip


:proc
echo.
echo.
echo Proceeding with Package Installation...
echo.
start /wait powershell.exe -ExecutionPolicy RemoteSigned -WindowStyle Maximized -File "%~dp0scripts\scoop-install.ps1" -Verb RunAs
start /wait powershell.exe -ExecutionPolicy Bypass -WindowStyle Maximized -File "%~dp0scripts\scoop-packages.ps1" -Verb RunAs
start /wait powershell.exe -ExecutionPolicy Bypass -WindowStyle Maximized -File "%~dp0scripts\%package%.ps1" -Verb RunAs
echo.
echo.
echo Configuring Packages...
timeout /t 5 /nobreak
echo.
echo.
echo All Packages Installed Succesfully...
echo.
echo.
echo Installing Android USB Drivers...
echo.
pnputil /add-driver "%~dp0Driver\android_winusb.inf" /subdirs /install
echo.
echo.
echo Installation Complete. Returning to Main Menu...
timeout /t 5 /nobreak
cls
goto skip
exit