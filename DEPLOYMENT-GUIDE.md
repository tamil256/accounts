# 🚀 Deployment Guide - Accounting App to Cloudflare Pages

This guide will help you deploy your accounting application to Cloudflare Pages with automatic GitHub integration.

## Prerequisites

- ✅ Git installed (already done!)
- ✅ Node.js installed (already done!)
- 🔲 GitHub account (create one at https://github.com if needed)
- 🔲 Cloudflare account (create one at https://cloudflare.com if needed)

## Quick Start Deployment

### Option 1: Using the Automated Script (Recommended)

1. **Close your current PowerShell/Terminal window**
2. **Open a NEW PowerShell window** (this refreshes the PATH for Git)
3. **Navigate to the project:**
   ```powershell
   cd f:\projects\accounting
   ```
4. **Run the deployment script:**
   ```powershell
   .\deploy-to-cloudflare.ps1
   ```
5. **Follow the prompts** - the script will guide you through everything!

### Option 2: Manual Deployment

If you prefer to do it step-by-step manually, follow these instructions:

#### Step 1: Initialize Git Repository

```powershell
# Navigate to project
cd f:\projects\accounting

# Initialize Git
git init

# Configure your identity
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Build the project
npm run build

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit - Accounting app"
```

#### Step 2: Create GitHub Repository

1. Go to https://github.com/new
2. **Repository name:** `accounting-app` (or your preferred name)
3. **Visibility:** Public or Private (your choice)
4. **Important:** Do NOT check "Initialize with README"
5. Click **"Create repository"**

#### Step 3: Push to GitHub

```powershell
# Add GitHub repository as remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/accounting-app.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

#### Step 4: Deploy to Cloudflare Pages

1. **Go to Cloudflare Dashboard:** https://dash.cloudflare.com/
2. **Navigate to Pages:**
   - Click on "Workers & Pages" in the sidebar
   - Click on "Pages" tab
3. **Connect to Git:**
   - Click "Connect to Git" button
   - Choose "GitHub"
   - Authorize Cloudflare to access your GitHub account
4. **Select Repository:**
   - Find and select your `accounting-app` repository
   - Click "Begin setup"
5. **Configure Build Settings:**
   - **Project name:** accounting-app (or customize)
   - **Production branch:** main
   - **Framework preset:** None (or Vite if available)
   - **Build command:** `npm run build`
   - **Build output directory:** `dist`
   - **Root directory:** `/` (leave as default)
6. **Deploy:**
   - Click "Save and Deploy"
   - Wait 2-3 minutes for the build to complete

## 🎉 Success!

Once deployed, your app will be available at:
- **Default URL:** `https://accounting-app.pages.dev`
- **Custom domain:** You can add your own domain in Cloudflare Pages settings

## 🔄 Automatic Deployments

The best part? **Future deployments are automatic!**

Every time you push changes to GitHub:
```powershell
git add .
git commit -m "Your commit message"
git push
```

Cloudflare will automatically:
- Detect the changes
- Build your app
- Deploy the new version
- Update your live site

## 📊 Monitoring Your Deployment

### View Build Logs
1. Go to https://dash.cloudflare.com/
2. Navigate to "Workers & Pages" → "Pages"
3. Click on your project
4. View deployment history and logs

### Build Status
- ✅ **Success:** Your site is live!
- ⏳ **Building:** Deployment in progress
- ❌ **Failed:** Check build logs for errors

## 🔧 Troubleshooting

### Build Fails
- Check build logs in Cloudflare dashboard
- Ensure `npm run build` works locally
- Verify all dependencies are in `package.json`

### Site Not Loading
- Check if TypeScript compiled without errors
- Verify `dist` folder contains `index.html`
- Check browser console for errors

### Git Push Fails
- You may need to authenticate with GitHub
- Use GitHub Desktop or create a Personal Access Token
- See: https://docs.github.com/en/authentication

### PATH Issues (Git Not Found)
- Close and reopen your terminal/PowerShell
- Restart your computer if needed
- Verify Git is installed: `git --version`

## 🌐 Your Live URLs

After deployment, you'll have:

1. **Cloudflare Pages URL:**
   - Production: `https://accounting-app.pages.dev`
   - Preview deployments: `https://[hash].accounting-app.pages.dev`

2. **Custom Domain (Optional):**
   - You can add your own domain in Cloudflare Pages settings
   - Cloudflare provides free SSL certificates

## 📝 Next Steps

### Test Your Deployed App
1. Open your Cloudflare Pages URL
2. Test all features:
   - ✓ Dashboard loads
   - ✓ Charts render correctly
   - ✓ Banks page works
   - ✓ All navigation works
   - ✓ Data persistence (localStorage)

### Configure Custom Domain (Optional)
1. In Cloudflare Pages, go to "Custom domains"
2. Click "Set up a custom domain"
3. Follow the DNS configuration steps

### Set Up Environment Variables (If Needed)
1. Go to your project in Cloudflare Pages
2. Click "Settings" → "Environment variables"
3. Add any necessary variables for production

## 🎨 Making Updates

To update your live site:

```powershell
# 1. Make your changes to the code
# 2. Test locally
npm run dev

# 3. Commit and push
git add .
git commit -m "Description of changes"
git push

# 4. Cloudflare automatically deploys! ✨
```

## 🔐 Security Notes

- Your code is version controlled on GitHub
- Cloudflare provides DDoS protection
- HTTPS is enabled by default
- Consider setting repository to private if needed

## 📞 Support

- **Cloudflare Pages Docs:** https://developers.cloudflare.com/pages/
- **GitHub Docs:** https://docs.github.com/
- **Vite Docs:** https://vitejs.dev/

---

**Happy Deploying! 🚀**

Your accounting app is now live and ready to share with the world!
