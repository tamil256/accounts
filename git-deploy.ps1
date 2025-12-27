# Quick Git Setup and GitHub Push
# Run this in a NEW PowerShell window

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CLOUDFLARE DEPLOYMENT SETUP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to project
cd f:\projects\accounting

# Check Git
try {
    git --version
    Write-Host "Git is ready!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Git not found. Close this window, open a NEW PowerShell, and try again." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Write-Host ""
Write-Host "Initializing Git repository..." -ForegroundColor Yellow

# Initialize Git
git init

# Configure Git
Write-Host ""
$name = Read-Host "Enter your name (for Git)"
$email = Read-Host "Enter your email (for Git)"

git config user.name "$name"
git config user.email "$email"

Write-Host ""
Write-Host "Adding files..." -ForegroundColor Yellow
git add .

Write-Host "Creating commit..." -ForegroundColor Yellow
git commit -m "Initial commit - Accounting app for Cloudflare Pages"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Git setup complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Create GitHub repository:" -ForegroundColor Yellow
Write-Host "   - Go to: https://github.com/new" -ForegroundColor White
Write-Host "   - Name: accounting-app" -ForegroundColor White
Write-Host "   - Click 'Create repository'" -ForegroundColor White
Write-Host ""
Write-Host "2. Copy the repository URL from GitHub" -ForegroundColor Yellow
Write-Host ""

start https://github.com/new

$repoUrl = Read-Host "Paste your GitHub repository URL here (e.g., https://github.com/username/accounting-app.git)"

if ($repoUrl) {
    Write-Host ""
    Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
    
    git remote add origin $repoUrl
    git branch -M main
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "  SUCCESS! Code pushed to GitHub!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "FINAL STEP - Connect to Cloudflare:" -ForegroundColor Cyan
        Write-Host "1. Opening Cloudflare Pages..." -ForegroundColor White
        Write-Host "2. Click 'Connect to Git'" -ForegroundColor White
        Write-Host "3. Select GitHub and authorize" -ForegroundColor White
        Write-Host "4. Select 'accounting-app' repository" -ForegroundColor White
        Write-Host "5. Build command: npm run build" -ForegroundColor Cyan
        Write-Host "6. Build output: dist" -ForegroundColor Cyan
        Write-Host "7. Click 'Save and Deploy'" -ForegroundColor White
        Write-Host ""
        Write-Host "Your app will be live at: https://accounting-app.pages.dev" -ForegroundColor Green
        Write-Host ""
        
        start https://dash.cloudflare.com/
    } else {
        Write-Host ""
        Write-Host "Push failed. You may need to authenticate with GitHub." -ForegroundColor Yellow
    }
}

Write-Host ""
Read-Host "Press Enter to exit"
