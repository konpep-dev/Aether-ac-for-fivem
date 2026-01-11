@echo off
echo ========================================
echo   Aether Anticheat - Screenshot API
echo ========================================
echo.
echo Installing dependencies...
pip install -r requirements.txt
echo.
echo Starting API server on port 5000...
python screenshot_api.py
pause
