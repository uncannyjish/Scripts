@echo off

title Uncanny Windows Configuration Script

:entry

cls
echo.
echo.
echo =======================================================================
echo               Uncanny Windows Congifuration Script
echo =======================================================================
echo.
echo.
echo.
echo Detecting System Status...
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
timeout /t 5 /nobreak
echo.
echo Proceeding with Package Installation...
echo.
timeout /t 5 /nobreak
start /wait powershell.exe -ExecutionPolicy Bypass -WindowStyle Maximized -File "%~dp0scripts\chocolatey-packages.ps1" -Verb RunAs
start /wait powershell.exe -ExecutionPolicy RemoteSigned -WindowStyle Maximized -File "%~dp0scripts\scoop-install.ps1" -Verb RunAs
start /wait powershell.exe -ExecutionPolicy Bypass -WindowStyle Maximized -File "%~dp0scripts\scoop-packages.ps1" -Verb RunAs
echo.
echo.
echo Configuring Packages...
timeout /t 5 /nobreak
echo.
echo.
echo All Packages Installed Succesfully
echo.
echo.
echo Installing Android USB Drivers...
echo.
pnputil /add-driver "%~dp0Driver\android_winusb.inf" /subdirs /install
echo.
echo.
echo Install Completed. Exiting...
timeout /t 5 /nobreak

exit