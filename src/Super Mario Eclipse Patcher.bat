@echo off

md "%~dp0bin\"
md "%~dp0patches\"

:cechoCheck
if exist "%~dp0bin\cecho.exe" goto :XdeltaCheck
title Error! & cls & color 0c
echo.
echo .\bin\cecho.exe not found! Re-extract, then press any key to proceed...
pause > nul
goto :cechoCheck

:XdeltaCheck
set cecho="%~dp0bin\cecho.exe"
if exist "%~dp0bin\xdelta.exe" goto :PatchCheck
title Error! & cls
echo.
%cecho% {07}.\bin\xdelta.exe {0c}not found! Re-extract, then press any key to proceed...{\n}
pause > nul
goto :XdeltaCheck

:PatchCheck
md "%~dp0patches\" > nul 2>&1
move /Y "%~dp0*.xdelta" "%~dp0patches\" > nul 2>&1
rename "%~dp0patches\Super_Mario_Eclipse_v1_0.xdelta" "v1.0.0.xdelta" > nul 2>&1
rename "%~dp0patches\Super_Mario_Eclipse_v1_0_hotfix_0.xdelta" "v1.0.1.xdelta" > nul 2>&1
rename "%~dp0patches\Super_Mario_Eclipse_v1_0_hotfix_1.xdelta" "v1.0.2.xdelta" > nul 2>&1
if exist "%~dp0patches\*.xdelta" goto :GameCheck
title Error! & cls
echo.
%cecho% {0c}No patches found in the {07}.\patches\ {0c}directory!{\n}
%cecho% {0e}{\n}
set /p choice="Download patches now? (y/n): "
if /i "%choice%" equ "Y" goto :DownloadPatches
if /i "%choice%" equ "N" exit /b
echo.
%cecho% {0c}You must enter 'y' or 'n' to proceed...{\n} & pause > nul
goto :PatchCheck

:DownloadPatches
cls & echo.
%cecho% {0e}Place patches in the {07}.\patches\ {0e}directory then press any key to proceed...{\n}
start https://gamebanana.com/mods/download/536309
pause > nul
goto :PatchCheck

:GameCheck
cls
if exist "%~1" goto :Main
title Error! & cls
echo.
%cecho% {0c}No game dump supplied! Drag-and-drop your copy of Super Mario Sunshine onto this script to patch it.{\n}
echo.
%cecho% {0e}The following requirements must be met for successful patching:{\n}
%cecho% {\t}{07}Format {07}... {0a}ISO{\n}
%cecho% {\t}{07}Region {07}... {0a}NTSC (USA){\n}
%cecho% {0e}{4e}Modified or compressed formats such as CISO, NKIT, ^& RVZ are unsupported!{\n}
echo.
%cecho% {0c}Piracy is not condoned or endorsed by Eclipse Team, you must legally dump your own copy of the game!{\n}
%cecho% {0e}Dumping guide: {09}https://wii.hacks.guide/dump-games.html{\n}
%cecho% {0e}For other issues and support, please visit our Discord server @ {09}https://discord.gg/u6NHuHVRpJ{\n}
%cecho% {0e}{4e}If you are updating Super Mario Eclipse, patch from your original copy of Super Mario Sunshine!{\n}
pause > nul & exit /b

:Main
title Super Mario Eclipse Patcher
echo.
%cecho% {0c}Piracy is not condoned or endorsed by Eclipse Team, you must legally dump your own copy of the game!{\n}
%cecho% {0e}Dumping guide: {09}https://wii.hacks.guide/dump-games.html{\n}
%cecho% {0e}For other issues and support, please visit our Discord server @ {09}https://discord.gg/u6NHuHVRpJ{\n}
echo.
%cecho% {0e}Infile: {07}%~nx1{\n}
echo.
%cecho% {0e}{4e}If you are updating Super Mario Eclipse, patch from your original copy of Super Mario Sunshine!{\n}
%cecho% {0e}Press any key to proceed with verification.{\n}
pause > nul
echo.

:ComputeHash
%cecho% {0e}Calculating MD5 checksum...{\n}
Set "MD5="
for /f "skip=1 Delims=" %%# in ('certutil -hashfile "%~f1" MD5') do if not defined MD5 set MD5=%%#
set MD5=%MD5: =%
if "%MD5%" equ "0c6d2edae9fdf40dfc410ff1623e4119" goto :ChecksumMatch
title Error! & cls
echo.
%cecho% {\u07 \u07}
%cecho% {0c}MD5 checksum mismatch! The MD5 of {07}%~nx1 {0c}does not match the required checksum:{\n}
echo.
%cecho% {0e}Required checksum {07}..... {0a}0c6d2edae9fdf40dfc410ff1623e4119{\n}
%cecho% {0e}Your checksum {07}......... {0c}%MD5%{\n}
echo.
%cecho% {0e}The following requirements must be met for successful patching:{\n}
%cecho% {\t}{07}Format {07}... {0a}ISO{\n}
%cecho% {\t}{07}Region {07}... {0a}NTSC (USA){\n}
%cecho% {0e}{4e}Modified or compressed formats such as CISO, NKIT, ^& RVZ are unsupported! The game must be redumped.{\n}
echo.
%cecho% {0c}Piracy is not condoned or endorsed by Eclipse Team, you must legally dump your own copy of the game!{\n}
%cecho% {0e}Dumping guide: {09}https://wii.hacks.guide/dump-games.html{\n}
%cecho% {0e}For other issues and support, please visit our Discord server @ {09}https://discord.gg/u6NHuHVRpJ{\n}
%cecho% {0e}{4e}If you are updating Super Mario Eclipse, patch from your original copy of Super Mario Sunshine!{\n}
pause > nul & exit /b
echo.

:ChecksumMatch
cls
echo.
%cecho% {0a}MD5 checksum match! The MD5 of {07}%~nx1 {0a}matches the required checksum:{\n}
echo.
%cecho% {0e}Required checksum {07}..... {0a}0c6d2edae9fdf40dfc410ff1623e4119{\n}
%cecho% {0e}Your checksum {07}......... {0a}%MD5%{\n}

:ListPatches
title Super Mario Eclipse Patcher
pushd "%~dp0patches"
echo.
%cecho% {0e}Available patches:{\n}
%cecho% {0d}
echo.
::dir *.xdelta /b /a-d
for %%f in (*.xdelta) do (echo %%~nf)
echo.
%cecho% {0e}
set /p PatchFile="Copy or type the full patch name from the above list: "
if /i "%PatchFile%" neq "" goto :PatchDump
title Error!
echo.
%cecho% {0c}You must select a patch from the list to proceed!{\n}
pause > nul & cls & goto :ListPatches

:PatchDump
echo.
%cecho% {0e}Patching {07}%~nx1{0e} with {07}Super Mario Eclipse %PatchFile%{0e}...{\n}
echo.
"%~dp0bin\xdelta.exe" -d -f -s "%~1" "%PatchFile%.xdelta" "%~dp1(GMSE04) Super Mario Eclipse %PatchFile%.iso"
%cecho% {02}Patching completed. Press any key to view patched file.{\n}
pause > nul
start "" explorer /select, "%~dp1(GMSE04) Super Mario Eclipse %PatchFile%.iso"
exit/b
