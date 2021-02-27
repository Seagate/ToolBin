@echo off
REM ================================================================================
REM  update_seachest.ps1 - Seagate drive utilities
REM  Copyright (c) 2018 Seagate Technology LLC and/or its Affiliates, All Rights Reserved
REM  v0.1 initial release
REM  Date last edit: 22-Mar-2018
REM  ================================================================================

REM Open a command prompt in Administrator mode (right click then 'Run as administrator')

IF [%1]==[] GOTO helpmsg

echo.
echo Running...
echo powershell.exe -ExecutionPolicy RemoteSigned -Command "& '.\update_seachest.ps1' '.\%1'"
powershell.exe -ExecutionPolicy Bypass -Command "& '.\update_seachest.ps1' '.\%1'"
REM powershell.exe -ExecutionPolicy RemoteSigned -Command "& '.\update_seachest.ps1' '.\%1'"
GOTO end

:helpmsg
echo.
echo ======================================================================
echo  SeaChest Utilities Update Script
echo.
echo Missing a SeaChest file name to check.
echo.
echo Usage is update_seachest.bat ^<SeaChest file name you want to check for update^>
echo example: update_seachest.bat SeaChest_Firmware_250_1164_32s.exe
echo.

:end
