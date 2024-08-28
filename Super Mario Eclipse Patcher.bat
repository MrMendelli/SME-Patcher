@echo off

:PatchCheck
if exist "%~dp0*.xdelta" goto :GameCheck
cls & title Error! & color 0c
echo. & echo No patches found!
echo A SME Xdelta patch file must be present in the same directory as this patcher to proceed.
pause > nul & exit /b

:GameCheck
if exist "%~1" goto :Main
cls & title Error! & color 0c
echo. & echo No game dump supplied!
echo Drag-and-drop your Super Mario Sunshine ISO onto this script to patch it.
pause > nul & exit /b

:Main
title Super Mario Eclipse Patcher & color 0a
echo   ____________________________
echo  ^|                            ^|
echo  ^|  SUPER MARIO ECLIPSE v1.0  ^|
echo  ^|____________________________^|
echo.
echo If patching fails, please ensure the following:
echo.
echo Format: ISO (NKIT is unsupported!)
echo Mods:  Unmodified
echo Compression: Uncompressed
echo Region: NTSC (USA)
echo MD5: 0c6d2edae9fdf40dfc410ff1623e4119
echo.
echo ^*Use Dolphin or visit https://emn178.github.io/online-tools/md5_checksum.html to validate your checksum.
echo For other issues and support, please visit our Discord server @ https://discord.com/invite/u6NHuHVRpJ.
echo.
echo Infile: %~nx1
echo.
echo Press any key to begin patching.
echo. & pause > nul

cls & color 0e
pushd %~dp0
for %%a in (*.xdelta) do (set "PatchFile=%%a")
echo.
echo Patching %~nx1...
echo.
"xdelta.exe" -d -f -s "%~1" "%PatchFile%" "%~dp1Super Mario Eclipse.iso"

:WriteLog
(
echo [%date:~-10,2%/%date:~-7,2%/%date:~-4,4% @ %time:~0,2%:%time:~3,2%]
echo Super Mario Eclipse patch/version: %PatchFile%
echo -----------------------------------------------------------------
echo.
)> "%~dp1SME.log"

cls & color 0a
echo.
echo Patching completed.
pause
start "" notepad "%~dp1SME.log"
start "" explorer /select, "%~dp1Super Mario Eclipse.iso"
exit /b
