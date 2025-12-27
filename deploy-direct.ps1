# Automated Cloudflare Pages Deployment Script
# This script deploys directly without Git/GitHub

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  CLOUDFLARE PAGES DIRECT DEPLOYMENT     " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if dist folder exists
if (-not (Test-Path "dist\index.html")) {
    Write-Host "Building the project first..." -ForegroundColor Yellow
    npm run build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Build failed!" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host "Build completed!" -ForegroundColor Green
    Write-Host ""
}

Write-Host "To deploy, we need your Cloudflare API Token" -ForegroundColor White
Write-Host ""
Write-Host "OPTION 1: Create API Token with Correct Permissions" -ForegroundColor Yellow
Write-Host "----------------------------------------------" -ForegroundColor Yellow
Write-Host "1. Go to: https://dash.cloudflare.com/profile/api-tokens" -ForegroundColor White
Write-Host "2. Click 'Create Token'" -ForegroundColor White
Write-Host "3. Click 'Create Custom Token' (at the bottom)" -ForegroundColor White
Write-Host "4. Token name: 'Cloudflare Pages Deploy'" -ForegroundColor White
Write-Host "5. Permissions:" -ForegroundColor White
Write-Host "   - Account > Cloudflare Pages > Edit" -ForegroundColor Cyan
Write-Host "6. Click 'Continue to summary'" -ForegroundColor White
Write-Host "7. Click 'Create Token'" -ForegroundColor White
Write-Host "8. COPY the token" -ForegroundColor White
Write-Host ""

# Open the API token page
Write-Host "Opening Cloudflare API Token page..." -ForegroundColor Yellow
Start-Process "https://dash.cloudflare.com/profile/api-tokens"
Write-Host ""
Read-Host "Press Enter after you've created and copied the token"
Write-Host ""

$apiToken = Read-Host "Paste your Cloudflare API Token here"

if (-not $apiToken) {
    Write-Host "ERROR: No token provided!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  DEPLOYING TO CLOUDFLARE PAGES...       " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Set the environment variable
$env:CLOUDFLARE_API_TOKEN = $apiToken

# Deploy
wrangler pages deploy dist --project-name=accounting-app --branch=main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host "  DEPLOYMENT SUCCESSFUL!                 " -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your app is now live at:" -ForegroundColor White
    Write-Host "https://accounting-app.pages.dev" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Opening your deployed app..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    Start-Process "https://accounting-app.pages.dev"
    Write-Host ""
    Write-Host "TIP: To deploy updates in the future:" -ForegroundColor Yellow
    Write-Host "  1. npm run build" -ForegroundColor White
    Write-Host "  2. Set token: " -NoNewline -ForegroundColor White
    Write-Host "`$env:CLOUDFLARE_API_TOKEN = 'your-token'" -ForegroundColor Cyan
    Write-Host "  3. wrangler pages deploy dist --project-name=accounting-app" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "ERROR: Deployment failed!" -ForegroundColor Red
    Write-Host "The token may not have the correct permissions." -ForegroundColor Yellow
    Write-Host "Please create a new token with 'Cloudflare Pages > Edit' permission" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit"
