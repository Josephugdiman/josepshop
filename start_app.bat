@echo off
TITLE MarketMap System
echo ===================================================
echo      Starting MarketMap System (Offline Mode)
echo ===================================================

echo.
echo 1. Starting Database Server (Backend)...
cd backend
start /MIN npm start
cd ..

echo.
echo 2. Waiting for server initialization...
timeout /t 5 >nul

echo.
echo 3. Starting User Interface...
echo    This may take a moment to load in your browser.
start http://localhost:5173
call npm run dev

echo.
echo System stopped.
pause
