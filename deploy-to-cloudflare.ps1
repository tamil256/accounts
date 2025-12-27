# Cloudflare Pages Deployment Script for Accounting App
# Run this script in a NEW PowerShell window after Git installation

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Cloudflare Pages Deployment Setup  " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check if Git is installed
Write-Host "[1/7] Checking Git installation..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>$null
    Write-Host "SUCCESS: Git is installed: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Git is not installed or not in PATH!" -ForegroundColor Red
    Write-Host "Please close this window, open a NEW PowerShell window, and try again." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Check if already a git repository
if (Test-Path .git) {
    Write-Host "WARNING: Git repository already exists." -ForegroundColor Yellow
    $reinit = Read-Host "Do you want to reinitialize? (y/n)"
    if ($reinit -eq "y") {
        Remove-Item -Recurse -Force .git
        Write-Host "SUCCESS: Removed existing .git directory" -ForegroundColor Green
    }
}

# Initialize Git repository
if (-not (Test-Path .git)) {
    Write-Host "[2/7] Initializing Git repository..." -ForegroundColor Yellow
    git init
    Write-Host "SUCCESS: Git repository initialized" -ForegroundColor Green
}

Write-Host ""

# Configure Git user
Write-Host "[3/7] Git User Configuration" -ForegroundColor Cyan
Write-Host "-------------------------" -ForegroundColor Cyan

$currentName = git config user.name 2>$null
$currentEmail = git config user.email 2>$null

if ($currentName) {
    Write-Host "Current name: $currentName" -ForegroundColor Gray
    $changeName = Read-Host "Keep this name? (y/n)"
    if ($changeName -ne "y") {
        $userName = Read-Host "Enter your name"
        git config user.name "$userName"
    }
} else {
    $userName = Read-Host "Enter your name (e.g., John Doe)"
    git config user.name "$userName"
}

if ($currentEmail) {
    Write-Host "Current email: $currentEmail" -ForegroundColor Gray
    $changeEmail = Read-Host "Keep this email? (y/n)"
    if ($changeEmail -ne "y") {
        $userEmail = Read-Host "Enter your email"
        git config user.email "$userEmail"
    }
} else {
    $userEmail = Read-Host "Enter your email (e.g., john@example.com)"
    git config user.email "$userEmail"
}

Write-Host "SUCCESS: Git user configured" -ForegroundColor Green
Write-Host ""

# Build the project
Write-Host "[4/7] Building the project..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "SUCCESS: Build completed successfully" -ForegroundColor Green
Write-Host ""

# Add all files
Write-Host "[5/7] Staging files..." -ForegroundColor Yellow
git add .
Write-Host "SUCCESS: Files staged" -ForegroundColor Green
Write-Host ""

# Commit
Write-Host "[6/7] Creating commit..." -ForegroundColor Yellow
$status = git status --porcelain
if ($status) {
    git commit -m "Initial commit - Accounting app ready for Cloudflare deployment"
    Write-Host "SUCCESS: Commit created" -ForegroundColor Green
} else {
    Write-Host "WARNING: No changes to commit" -ForegroundColor Yellow
}
Write-Host ""

# GitHub setup
Write-Host "[7/7] GitHub Repository Setup" -ForegroundColor Cyan
Write-Host "-------------------------" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please create a new repository on GitHub:" -ForegroundColor White
Write-Host "1. Go to: https://github.com/new" -ForegroundColor White
Write-Host "2. Repository name: accounting-app (or your preferred name)" -ForegroundColor White
Write-Host "3. Keep it Public or Private" -ForegroundColor White
Write-Host "4. Do NOT initialize with README, .gitignore, or license" -ForegroundColor White
Write-Host "5. Click 'Create repository'" -ForegroundColor White
Write-Host ""

$repoUrl = Read-Host "Enter your GitHub repository URL (e.g., https://github.com/username/accounting-app.git)"

if ($repoUrl) {
    # Check if remote already exists
    $existingRemote = git remote get-url origin 2>$null
    if ($existingRemote) {
        Write-Host "WARNING: Remote 'origin' already exists: $existingRemote" -ForegroundColor Yellow
        git remote set-url origin $repoUrl
        Write-Host "SUCCESS: Remote URL updated" -ForegroundColor Green
    } else {
        git remote add origin $repoUrl
        Write-Host "SUCCESS: Remote added" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
    
    # Check if main branch exists
    $currentBranch = git branch --show-current
    if (-not $currentBranch) {
        git checkout -b main
    } elseif ($currentBranch -ne "main") {
        git branch -M main
    }
    
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "SUCCESS: Successfully pushed to GitHub!" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Push failed. You may need to authenticate with GitHub." -ForegroundColor Yellow
        Write-Host "Try running: git push -u origin main" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       GITHUB SETUP COMPLETE!            " -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Cloudflare Pages setup
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "    CLOUDFLARE PAGES DEPLOYMENT          " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Now let's deploy to Cloudflare Pages:" -ForegroundColor White
Write-Host ""
Write-Host "STEP 1: Go to Cloudflare Dashboard" -ForegroundColor Yellow
Write-Host "   https://dash.cloudflare.com/" -ForegroundColor White
Write-Host ""
Write-Host "STEP 2: Navigate to Pages" -ForegroundColor Yellow
Write-Host "   Click 'Workers & Pages' then 'Pages'" -ForegroundColor White
Write-Host ""
Write-Host "STEP 3: Connect to Git" -ForegroundColor Yellow
Write-Host "   Click 'Connect to Git' button" -ForegroundColor White
Write-Host ""
Write-Host "STEP 4: Select GitHub" -ForegroundColor Yellow
Write-Host "   Authorize Cloudflare to access your GitHub account" -ForegroundColor White
Write-Host ""
Write-Host "STEP 5: Select Your Repository" -ForegroundColor Yellow
Write-Host "   Find and select your 'accounting-app' repository" -ForegroundColor White
Write-Host ""
Write-Host "STEP 6: Configure Build Settings" -ForegroundColor Yellow
Write-Host "   Framework preset: None (or Vite if available)" -ForegroundColor White
Write-Host "   Build command: npm run build" -ForegroundColor Cyan
Write-Host "   Build output directory: dist" -ForegroundColor Cyan
Write-Host "   Root directory: / (default)" -ForegroundColor White
Write-Host ""
Write-Host "STEP 7: Deploy!" -ForegroundColor Yellow
Write-Host "   Click 'Save and Deploy'" -ForegroundColor White
Write-Host "   Wait for deployment to complete (usually 2-3 minutes)" -ForegroundColor Gray
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Your app will be available at:       " -ForegroundColor Green
Write-Host "   https://accounting-app.pages.dev     " -ForegroundColor White
Write-Host "   (or your custom URL)                 " -ForegroundColor Gray
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "TIP: Future deployments are automatic!" -ForegroundColor Cyan
Write-Host "     Just push to GitHub and Cloudflare will auto-deploy" -ForegroundColor Gray
Write-Host ""

# Open Cloudflare in browser
$openBrowser = Read-Host "Would you like to open Cloudflare Pages now? (y/n)"
if ($openBrowser -eq "y") {
    Start-Process "https://dash.cloudflare.com/"
}

Write-Host ""
Write-Host "Script completed! Happy deploying!" -ForegroundColor Green
Read-Host "Press Enter to exit"
