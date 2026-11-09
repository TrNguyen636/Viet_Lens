@echo off
chcp 65001 >nul
set PYTHONIOENCODING=utf-8
title VLensModel - Mock Vision Server (:8082)
echo ====================================================
echo   Khoi chay Mock Vision Server (Port 8082)
echo ====================================================
cd /d "%~dp0"

REM Tu dong su dung venv cuc bo hoac venv co san tu Model_VietLens
if exist ".\venv\Scripts\activate.bat" (
    call .\venv\Scripts\activate.bat
) else if exist "..\..\Model_VietLens\venv\Scripts\activate.bat" (
    call ..\..\Model_VietLens\venv\Scripts\activate.bat
)

python mock_server.py
pause
