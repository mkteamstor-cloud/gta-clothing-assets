@echo off
setlocal enabledelayedexpansion

echo ====================================
echo         MK3 - PNG Compressor
echo ====================================
echo.

REM Count PNG files
set "count=0"
for %%f in (*.png) do (
    set /a count+=1
)

if !count! EQU 0 (
    echo No PNG files found.
    pause
    exit /b
)

echo Found !count! PNG files. Starting compression in parallel...
echo.

set "current=0"
set "parallel=100"
set "batchCount=0"

for %%f in (*.png) do (
    set /a batchCount+=1

    REM Launch pngquant in a new cmd window (parallel)
    start "" /b cmd /c "pngquant --quality=65-80 --ext .png --force "%%f" >nul 2>&1 && echo Compressed: %%f"

    REM If batchCount hits the parallel limit, wait for a bit
    if !batchCount! GEQ %parallel% (
        REM Wait for child processes to finish
        timeout /t 2 /nobreak >nul
        set batchCount=0
    )
)

REM Final wait to let all processes finish
timeout /t 5 /nobreak >nul

echo.
echo Done compressing !count! PNG files!
pause
