@echo off
chcp 65001 >nul
set PYTHONIOENCODING=utf-8
title VLensModel - FastAPI Service (:8000)
echo ====================================================
echo   Khoi chay VLensModel FastAPI (Port 8000)
echo ====================================================
cd /d "%~dp0"

REM Tu dong su dung venv cuc bo hoac venv co san tu Model_VietLens
if exist ".\venv\Scripts\activate.bat" (
    call .\venv\Scripts\activate.bat
) else if exist "..\..\Model_VietLens\venv\Scripts\activate.bat" (
    call ..\..\Model_VietLens\venv\Scripts\activate.bat
)

python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
pause
