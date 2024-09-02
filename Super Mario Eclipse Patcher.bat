@echo off

:cEchoCheck
if exist "%~dp0bin\cecho.exe" goto :XdeltaCheck
title Error! & cls & color 0c
echo.
echo .\bin\cecho.exe not found, exiting...
pause > nul & exit /b

:XdeltaCheck
set cecho="%~dp0bin\cecho.exe"
if exist "%~dp0bin\xdelta.exe" goto :PatchCheck
title Error! & cls
echo.
%cecho% {0c}.\bin\xdelta.exe not found, exiting...
pause > nul & exit /b

:PatchCheck
move /Y "%~dp0*.xdelta" "%~dp0patches\" > nul 2>&1
if exist "%~dp0patches\*.xdelta" goto :GameCheck
title Error! & cls
echo.
%cecho% {0c}No patches found! A SME Xdelta patch file must be present in the .\patches folder to proceed.
pause > nul & exit /b

:GameCheck
if exist "%~1" goto :Main
title Error! & cls
echo.
%cecho% {0c}No game dump supplied! Drag-and-drop your copy of Super Mario Sunshine onto this script to patch it.{\n}
echo.
%cecho% {0c}Piracy is not condoned or endorsed by Eclipse Team, you must legally dump your own copy of the game!{\n}
%cecho% {0e}Dumping guide: {09}https://wii.hacks.guide/dump-games.html{\n}
echo.
%cecho% {0e}The following requirements must be met for successful patching:{\n}
%cecho% {\t}{07}Format ... {0a}ISO{\n}
%cecho% {\t}{07}Region ... {0a}NTSC (USA){\n}
%cecho% {\t}{07}MD5 ...... {0a}0c6d2edae9fdf40dfc410ff1623e4119{\n}
%cecho% {0c}Modified or compressed formats such as CISO, NKIT, ^& RVZ are unsupported!{\n}
echo.
%cecho% {0e}For other issues and support, please visit our Discord server @ {09}https://discord.gg/u6NHuHVRpJ{\n}
%cecho% {0c}IF YOU ARE UPDATING, PATCH FROM THE ORIGINAL COPY, NOT A COPY THAT HAS ALREADY BEEN PATCHED!{\n}
pause > nul & exit /b

:Main
title Super Mario Eclipse Patcher
echo.
%cecho% {0c}Piracy is not condoned or endorsed by Eclipse Team, you must legally dump your own copy of the game!{\n}
%cecho% {0e}Dumping guide: {09}https://wii.hacks.guide/dump-games.html{\n}
echo.
%cecho% {0e}For other issues and support, please visit our Discord server @ {09}https://discord.gg/u6NHuHVRpJ{\n}
%cecho% {0c}IF YOU ARE UPDATING, PATCH FROM THE ORIGINAL COPY, NOT A COPY THAT HAS ALREADY BEEN PATCHED!{\n}
echo.
%cecho% {07}Infile: {07}%~nx1{\n}
echo.
%cecho% {0e}Press any key to proceed with verification.{\n}
pause > nul
echo.

:ComputeHash
%cecho% {0e}Computing MD5 checksum...{\n}
Set "MD5="
for /f "skip=1 Delims=" %%# in ('certutil -hashfile "%~f1" MD5') do if not defined MD5 set MD5=%%#
set MD5=%MD5: =%
if "%MD5%" equ "0c6d2edae9fdf40dfc410ff1623e4119" goto :ChecksumMatch
title Error! & cls
echo.
%cecho% {\u07 \u07}
%cecho% {0c}MD5 checksum mismatch! The MD5 of {07}%~nx1 {0c}does not match the required checksum:{\n}
echo.
%cecho% {0e}Required checksum ..... {0a}0c6d2edae9fdf40dfc410ff1623e4119{\n}
%cecho% {0e}Your checksum ......... {0c}%MD5%{\n}
echo.
%cecho% {0c}The game must be redumped.{\n}
echo.
%cecho% {0c}Piracy is not condoned or endorsed by Eclipse Team, you must legally dump your own copy of the game!{\n}
%cecho% {0e}Dumping guide: {09}https://wii.hacks.guide/dump-games.html{\n}
pause > nul & exit /b
echo.

:ChecksumMatch
cls
set InFile="%~nx1"
echo.
%cecho% {0a}MD5 checksum match! The MD5 of {07}%~nx1 {0a}matches the required checksum:{\n}
echo.
%cecho% {0e}Required checksum ..... {0a}0c6d2edae9fdf40dfc410ff1623e4119{\n}
%cecho% {0e}Your checksum ......... {0a}%MD5%{\n}
echo.
%cecho% {0e}Press any key to proceed to patching.{\n}
echo. & pause > nul

:ListPatches
title Super Mario Eclipse Patcher & cls
pushd "%~dp0patches"
::for %%a in ("*.xdelta") do (set PatchFiles="%%a")
echo.
%cecho% {0a}Available patches:{\n}
echo.
dir *.xdelta /b /a-d
echo.
set /p PatchFile="Apply patch: "
if /i "%PatchFile%" neq "" goto :PatchDump
echo.
title Error! & cls
echo.
%cecho% {0c}You must select a patch from the list to proceed.{\n}
pause > nul & goto :ListPatches

:PatchDump
for %%a in (%PatchFile%) do (set PatchName=%%~na)
echo.
%cecho% {0e}Patching {07}%~nx1{0e} with {07}%PatchName%{0e}...{\n}
echo.
"%~dp0bin\xdelta.exe" -d -f -s "%~1" %PatchFile% "%~dp1Super Mario Eclipse %PatchName%.iso"
%cecho% {02}Patching completed.{\n}
pause
start "" explorer /select, "%~dp1Super Mario Eclipse %PatchName%.iso" & exit /b
