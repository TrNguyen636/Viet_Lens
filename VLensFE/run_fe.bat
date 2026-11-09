@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ===================================================
echo   KHOI DONG VIETLENS FRONTEND (EXPO GO MODE)
echo ===================================================
set EXPO_NO_TELEMETRY=1
call .\node_modules\.bin\expo.cmd start --go -c
pause
