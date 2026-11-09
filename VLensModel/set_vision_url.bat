@echo off
chcp 65001 >nul
cd /d "%~dp0"

if "%~1"=="" (
    echo ========================================================
    echo   VIETLENS VISION ENDPOINT SWITCHER ^(PINGGY_URL^)
    echo ========================================================
    echo Cach su dung:
    echo   1. Chuyen ve Local Mock Server ^(port 8082^):
    echo      set_vision_url.bat mock
    echo.
    echo   2. Chuyen sang Real Colab Vision Server ^(Ngrok URL^):
    echo      set_vision_url.bat https://xxxx.ngrok-free.app
    echo ========================================================
    exit /b 0
)

set TARGET_URL=%~1
if /I "%TARGET_URL%"=="mock" (
    set TARGET_URL=http://127.0.0.1:8082
)

python -c "import pathlib, re; p = pathlib.Path('.env'); text = p.read_text(encoding='utf-8') if p.exists() else ''; new_line = f'PINGGY_URL=\"{r'%TARGET_URL%'}\"'; updated = re.sub(r'^PINGGY_URL=.*$', new_line, text, flags=re.MULTILINE) if 'PINGGY_URL=' in text else (text.rstrip() + '\n' + new_line + '\n'); p.write_text(updated, encoding='utf-8'); print(f'✅ Da cap nhat PINGGY_URL = {r\"%TARGET_URL%\"} trong VLensModel/.env')"
echo Hay khoi dong lai run_model.bat de ap dung URL moi!

