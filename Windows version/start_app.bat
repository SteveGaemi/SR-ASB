@echo off
cd /d %~dp0

if not exist frontend\build\nul (
    echo ⚠️ Frontend not built. Please run install_2.bat first.
    pause
    exit /b
)

REM Start the Flask backend using embedded Python
echo Starting Flask server...
start "" /B Python\python.exe backend\main.py

REM Wait for Flask to start up before opening the browser
timeout /t 5 >nul

REM Open browser to frontend
start http://localhost:5000

pause
