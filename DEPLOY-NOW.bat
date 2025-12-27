@echo off
REM Refresh environment and run deployment commands
echo.
echo ==========================================
echo   AUTOMATED CLOUDFLARE DEPLOYMENT
echo ==========================================
echo.

REM Refresh PATH
call refreshenv 2>nul

REM Try to use Git
echo [Step 1/8] Checking Git installation...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Git is not yet available in this terminal.
    echo.
    echo SOLUTION: Please follow these simple steps:
    echo.
    echo 1. Open Windows Start Menu
    echo 2. Type "PowerShell"
    echo 3. Right-click "Windows PowerShell" and select "Run as administrator"
    echo 4. In the new window, run these commands:
    echo.
    echo    cd f:\projects\accounting
    echo    git init
    echo    git config user.name "YourName"
    echo    git config user.email "your@email.com"
    echo    npm run build
    echo    git add .
    echo    git commit -m "Initial commit"
    echo.
    echo 5. Then create GitHub repo at: https://github.com/new
    echo 6. Run: git remote add origin YOUR_REPO_URL
    echo 7. Run: git push -u origin main
    echo.
    echo After GitHub push, go to: https://dash.cloudflare.com/
    echo Navigate to Workers and Pages, then Pages, click Connect to Git
    echo.
    pause
    exit /b 1
)

echo SUCCESS: Git is installed!
echo.

echo [Step 2/8] Initializing Git repository...
if not exist .git (
    git init
    echo SUCCESS: Repository initialized
) else (
    echo Repository already exists
)
echo.

echo [Step 3/8] Configuring Git user...
set /p username="Enter your name: "
set /p useremail="Enter your email: "
git config user.name "%username%"
git config user.email "%useremail%"
echo SUCCESS: Git configured
echo.

echo [Step 4/8] Building the project...
call npm run build
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)
echo SUCCESS: Build completed
echo.

echo [Step 5/8] Staging files...
git add .
echo SUCCESS: Files staged
echo.

echo [Step 6/8] Creating commit...
git commit -m "Initial commit - Accounting app ready for Cloudflare"
echo.

echo [Step 7/8] GitHub Setup...
echo.
echo Please create a GitHub repository:
echo 1. Go to: https://github.com/new
echo 2. Name: accounting-app
echo 3. Do NOT initialize with README
echo 4. Click Create repository
echo.
pause
echo.

set /p repourl="Enter your GitHub repository URL: "
git remote add origin %repourl% 2>nul || git remote set-url origin %repourl%
git branch -M main
echo.

echo [Step 8/8] Pushing to GitHub...
git push -u origin main
echo.

if %errorlevel% equ 0 (
    echo ==========================================
    echo   SUCCESS! Code pushed to GitHub
    echo ==========================================
    echo.
    echo Next: Deploy to Cloudflare Pages
    echo 1. Go to: https://dash.cloudflare.com/
    echo 2. Navigate to Workers and Pages, then Pages
    echo 3. Click "Connect to Git"
    echo 4. Select GitHub and authorize
    echo 5. Select your accounting-app repository
    echo 6. Build command: npm run build
    echo 7. Build output: dist
    echo 8. Click Save and Deploy
    echo.
    echo Your app will be live at:
    echo https://accounting-app.pages.dev
    echo.
    set /p openbrowser="Open Cloudflare Pages now? (y/n): "
    if /i "%openbrowser%"=="y" start https://dash.cloudflare.com/
) else (
    echo.
    echo WARNING: GitHub push failed.
    echo You may need to authenticate with GitHub first.
    echo.
)

echo.
echo Deployment script completed!
pause
