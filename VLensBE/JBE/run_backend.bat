@echo off
chcp 65001 > nul
echo =======================================================
echo   VIETLENS - JAVA SPRING BOOT BACKEND (Port 8080)
echo =======================================================

cd /d "%~dp0"

echo Nạp biến môi trường từ ..\.env ...
if exist "..\.env" (
    for /f "usebackq tokens=1* delims==" %%A in ("..\.env") do (
        set line=%%A
        if not "!line:~0,1!"=="#" (
            if not "%%B"=="" set %%A=%%B
        )
    )
)

echo Đang khởi động Spring Boot trên cổng 8080 ...
call mvnw.cmd spring-boot:run
pause
