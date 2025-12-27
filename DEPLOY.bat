@echo off
echo ==========================================
echo   CLOUDFLARE DEPLOYMENT
echo ==========================================
echo.
echo Opening a NEW PowerShell window...
echo Follow the prompts to deploy your app!
echo.
pause
start powershell -NoExit -ExecutionPolicy Bypass -File "%~dp0git-deploy.ps1"
