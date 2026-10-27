@echo off
chcp 65001 > nul
echo =======================================================
echo   VIETLENS - PYTHON AI MICROSERVICE (FastAPI + PyTorch)
echo =======================================================

cd /d "%~dp0"
set PYTHONIOENCODING=utf-8

if exist "venv\Scripts\python.exe" (
    set PYTHON_EXE=venv\Scripts\python.exe
) else (
    set PYTHON_EXE=python
)

echo Starting AI Microservice on http://0.0.0.0:8000 ...
%PYTHON_EXE% -m uvicorn app:app --host 0.0.0.0 --port 8000 --workers 1
pause
