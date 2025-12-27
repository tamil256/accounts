@echo off
echo ==========================================
echo   AUTOMATED CLOUDFLARE DEPLOYMENT
echo ==========================================
echo.

echo This script will deploy your app directly to Cloudflare Pages
echo without needing Git or GitHub!
echo.

REM Check if we have the build
if not exist dist\index.html (
    echo Building the project first...
    call npm run build
    if %errorlevel% neq 0 (
        echo ERROR: Build failed!
        pause
        exit /b 1
    )
    echo Build completed!
    echo.
)

echo.
echo To deploy, we need your Cloudflare API Token.
echo.
echo STEP 1: Get your API Token
echo ----------------------------------------
echo 1. Opening Cloudflare API Token page...
echo 2. Click "Create Token"
echo 3. Use "Edit Cloudflare Workers" template
echo 4. Click "Continue to summary"
echo 5. Click "Create Token"
echo 6. COPY the token (you'll only see it once!)
echo.
start https://dash.cloudflare.com/profile/api-tokens
echo.
pause
echo.

set /p CLOUDFLARE_API_TOKEN="Paste your Cloudflare API Token here: "

if "%CLOUDFLARE_API_TOKEN%"=="" (
    echo ERROR: No token provided!
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   DEPLOYING TO CLOUDFLARE PAGES...
echo ==========================================
echo.

REM Deploy using wrangler
set CLOUDFLARE_API_TOKEN=%CLOUDFLARE_API_TOKEN%
wrangler pages deploy dist --project-name=accounting-app --branch=main

if %errorlevel% equ 0 (
    echo.
    echo ==========================================
    echo   DEPLOYMENT SUCCESSFUL!
    echo ==========================================
    echo.
    echo Your app is now live at:
    echo https://accounting-app.pages.dev
    echo.
    echo Opening your deployed app...
    timeout /t 3
    start https://accounting-app.pages.dev
    echo.
    echo TIP: To deploy updates in the future, just run:
    echo      npm run build
    echo      wrangler pages deploy dist --project-name=accounting-app
    echo.
) else (
    echo.
    echo ERROR: Deployment failed!
    echo Check the error message above.
    echo.
)

pause
