@echo off

:: Globals
:: <GameTitle>
:: <ModTitle>
:: <URL>
::
:: <NoFileMsg>
:: <VanillaPatchMsg>
:: <MismatchMsg>
::
:: <VanillaChecksum>
:: <ModChecksum>
:: <ModVersion>
:: <UpdateFile>
:: <OutFormat>

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
move /Y "%~dp0*.update" "%~dp0patches\" > nul 2>&1
if exist "%~dp0patches\*.xdelta" goto :GameCheck
title Error! & cls
echo.
%cecho% {0c}No patches found in the {07}.\patches\ {0c}directory!{\n}
%cecho% {0e}{\n}
set /p choice="Download patches now? (y/n): "
if /i "%choice%" equ "Y" goto :DownloadPatches
if /i "%choice%" equ "N" exit /b
echo.
%cecho% {0c}You must enter 'y' or 'n' to proceed...{\n}
pause > nul
goto :PatchCheck

:DownloadPatches
cls & echo.
%cecho% {0e}Place patches in the {07}.\patches\ {0e}directory then press any key to proceed...{\n}
start <URL>
pause > nul
goto :PatchCheck

:GameCheck
cls
if exist "%~1" goto :Main
title Error! & cls
echo.
%cecho% {0c}No game dump supplied! Drag-and-drop your copy of <GameTitle> onto this script to patch it.{\n}
echo.
%cecho% {0e}<NoFileMsg>
pause > nul & exit /b

:Main
title <ModTitle> Patcher
echo.
%cecho% {0c}<VanillaPatchMsg>
echo.
%cecho% {0e}Infile: {07}%~nx1{\n}
echo.
%cecho% {0e}Press any key to proceed with verification.{\n}
pause > nul
echo.

:ComputeHash
%cecho% {0e}Calculating MD5 checksum...{\n}
Set "MD5="
for /f "skip=1 Delims=" %%# in ('certutil -hashfile "%~f1" MD5') do if not defined MD5 set MD5=%%#
set MD5=%MD5: =%
set "VanillaChecksum=<VanillaChecksum>"
if "%MD5%" equ "%VanillaChecksum%" goto :VerifyVanilla
if "%MD5%" equ "<ModChecksum>" set "ModChecksum=<ModChecksum>" & set "ModVersion=<ModVersion>" & set "UpdateFile=<UpdateFile>" & goto :PatchUpdate
title Error! & cls
echo.
%cecho% {\u07 \u07}
%cecho% {0c}MD5 checksum mismatch! The MD5 of {07}%~nx1 {0c}does not match the required checksum:{\n}
echo.
%cecho% {0e}Required checksum {07}..... {0a}%VanillaChecksum%{\n}
%cecho% {0e}Your checksum {07}......... {0c}%MD5%{\n}
echo.
%cecho% {0e}<MismatchMsg>
pause > nul & exit /b
echo.

:VerifyVanilla
cls
echo.
%cecho% {0a}MD5 checksum match! The MD5 of {07}%~nx1 {0a}matches the required checksum:{\n}
echo.
%cecho% {0e}Required checksum {07}..... {0a}%VanillaChecksum%{\n}
%cecho% {0e}Your checksum {07}......... {0a}%MD5%{\n}

:ListPatches
title <ModTitle> Patcher
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
if /i "%PatchFile%" neq "" goto :PatchVanilla
title Error!
echo.
%cecho% {0c}You must select a patch from the list to proceed!{\n}
pause > nul
goto :VerifyVanilla

:PatchVanilla
echo.
%cecho% {0e}Patching {07}%~nx1{0e} with {07}<ModTitle> %PatchFile%{0e}...{\n}
echo.
"%~dp0bin\xdelta.exe" -d -f -s "%~1" "%PatchFile%.xdelta" "%~dp1<ModTitle> %PatchFile%.<OutFormat>"
%cecho% {02}Patching completed. Press any key to view patched file.{\n}
pause > nul
start "" explorer /select, "%~dp1<ModTitle> %PatchFile%.<OutFormat>"
exit/b

:PatchUpdate
set choice=""
cls
echo.
%cecho% {0d}<ModTitle> %ModVersion% detected!{\n}
echo.
%cecho% {0e}%ModVersion% checksum {07}....... {0a}%ModChecksum%{\n}
%cecho% {0e}Your checksum {07}......... {0a}%MD5%{\n}
echo.
%cecho% {0e}
set /p choice="Update to %UpdateFile%?: "
if /i "%choice%" equ "Y" goto :CheckUpdates
if /i "%choice%" equ "N" exit /b
title Error!
echo.
%cecho% {0c}You must enter 'y' or 'n' to proceed...{\n}
pause > nul
goto :PatchUpdate

:CheckUpdates
set choice=""
if exist "%~dp0patches\%UpdateFile%.update" goto :ApplyUpdate
title Error! & cls
echo.
%cecho% {0c}%UpdateFile%.update not found in the {07}.\patches\ {0c}directory!{\n}
%cecho% {0e}{\n}
set /p choice="Download patches now? (y/n): "
if /i "%choice%" equ "Y" goto :DownloadUpdates
if /i "%choice%" equ "N" exit /b
echo.
%cecho% {0c}You must enter 'y' or 'n' to proceed...{\n}
goto :CheckUpdates

:DownloadUpdates
cls & echo.
%cecho% {0e}Place updates in the {07}.\patches\ {0e}directory then press any key to proceed...{\n}
start <URL>
pause > nul
goto :CheckUpdates

:ApplyUpdate
echo.
%cecho% {0e}Patching {07}%~nx1{0e} with {07}%UpdateFile%{0e}...{\n}
echo.
"%~dp0bin\xdelta.exe" -d -f -s "%~1" "%~dp0patches\%UpdateFile%.update" "%~dp1<ModTitle> %UpdateFile%.<OutFormat>"
%cecho% {02}Patching completed. Press any key to view patched file.{\n}
pause > nul
start "" explorer /select, "%~dp1<ModTitle> %UpdateFile%.<OutFormat>"
exit/b
