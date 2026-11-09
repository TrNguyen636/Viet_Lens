@echo off
chcp 65001 >nul
set PYTHONIOENCODING=utf-8
title VLensModel - Khoi dong he thong AI
echo ====================================================
echo   Khoi chay Tron Bo VLensModel (Mock + FastAPI)
echo ====================================================
cd /d "%~dp0"

echo [1/2] Dang bat Mock Vision Server (:8082)...
start "VLensModel - Mock Vision Server (:8082)" cmd /k call run_mock.bat

timeout /t 2 >nul

echo [2/2] Dang bat FastAPI AI Service (:8000)...
start "VLensModel - FastAPI Server (:8000)" cmd /k call run_model.bat

echo ====================================================
echo   Ca 2 server da duoc bat thanh cong!
echo ====================================================
timeout /t 3 >nul
exit

