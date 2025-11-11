# 🚀 Complete Deployment Guide - AmazKart

This guide will help you deploy AmazKart to **Render (Backend)** and **Vercel (Frontend)**, then push to GitHub.

## 📋 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Step 1: GitHub Setup](#step-1-github-setup)
3. [Step 2: MongoDB Setup](#step-2-mongodb-setup)
4. [Step 3: Backend Deployment (Render)](#step-3-backend-deployment-render)
5. [Step 4: Frontend Deployment (Vercel)](#step-4-frontend-deployment-vercel)
6. [Step 5: Final Configuration](#step-5-final-configuration)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before you start, make sure you have:
- ✅ Git installed on your computer
- ✅ GitHub account (https://github.com)
- ✅ Render account (https://render.com) - free tier is fine
- ✅ Vercel account (https://vercel.com) - free tier is fine
- ✅ MongoDB Atlas account (https://www.mongodb.com/cloud/atlas) - free tier is fine

---

## Step 1: GitHub Setup

### 1.1 Initialize Git Repository

Open PowerShell in your project root and run:

```powershell
# Navigate to your project directory
cd "c:\Users\DEVENDER SINGH\Downloads\AmazKart-main"

# Initialize git (only if not already done)
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: AmazKart e-commerce application"
```

### 1.2 Add Remote Repository

```powershell
# Add your GitHub repository as remote
git remote add origin https://github.com/Dracorav/Ecomerce-website-main.git

# Push to GitHub
git branch -M main
git push -u origin main
```

**Note:** You may be prompted to authenticate. Use your GitHub username and a Personal Access Token (PAT):
1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Create a new token with `repo` scope
3. Copy the token and paste it when prompted for password

---

## Step 2: MongoDB Setup

### 2.1 Create MongoDB Atlas Cluster

1. Go to https://www.mongodb.com/cloud/atlas
2. Sign up or log in
3. Create a new project
4. Create a new cluster (Free tier is fine)
5. Create a database user:
   - Username: `admin`
   - Password: Create a strong password (note it down)
   - Add your IP to the whitelist (or add 0.0.0.0/0 for development)

### 2.2 Get Connection String

1. In MongoDB Atlas, click "Connect"
2. Copy the connection string (looks like: `mongodb+srv://admin:password@cluster.mongodb.net/ecommerce?retryWrites=true&w=majority`)
3. Replace `<password>` with your actual password
4. Save this for later

**Connection String Format:**
```
mongodb+srv://admin:YOUR_PASSWORD@cluster-name.mongodb.net/ecommerce?retryWrites=true&w=majority
```

---

## Step 3: Backend Deployment (Render)

### 3.1 Push Code to Render

1. Go to https://render.com
2. Sign up with GitHub account
3. Click "New +" → "Web Service"
4. Select your GitHub repository (`Ecomerce-website-main`)
5. Configure the service:

   **Name:** `amazkart-backend`
   
   **Environment:** `Node`
   
   **Build Command:** `npm install && npm install --prefix server`
   
   **Start Command:** `npm start --prefix server`
   
   **Region:** Choose closest to you
   
   **Plan:** Free (Starter)

### 3.2 Add Environment Variables

In the Render dashboard for your service, go to **Environment**:

```
MONGODB_URI=mongodb+srv://admin:YOUR_PASSWORD@cluster-name.mongodb.net/ecommerce?retryWrites=true&w=majority
PORT=5000
SEED_KEY=your-secret-key-here
NODE_ENV=production
FRONTEND_URL=https://your-vercel-frontend-url.vercel.app
```

### 3.3 Deploy

Click "Create Web Service" and wait for deployment (5-10 minutes)

Once deployed, you'll get a URL like: `https://amazkart-backend.onrender.com`

**Save this URL for Step 5!**

### 3.4 Test Backend

```powershell
# Test the health endpoint
$backendUrl = "https://amazkart-backend.onrender.com"
Invoke-WebRequest -Uri "$backendUrl/api/health"
```

---

## Step 4: Frontend Deployment (Vercel)

### 4.1 Push Code to Vercel

1. Go to https://vercel.com
2. Sign up with GitHub account
3. Click "Add New" → "Project"
4. Import your GitHub repository (`Ecomerce-website-main`)
5. Configure the project:

   **Project Name:** `amazkart-frontend`
   
   **Framework Preset:** React
   
   **Root Directory:** `./client`

### 4.2 Add Environment Variables

Before deploying, add environment variable:

```
REACT_APP_API_URL=https://amazkart-backend.onrender.com
```

(Replace with your actual Render backend URL)

### 4.3 Deploy

Click "Deploy" and wait (3-5 minutes)

Once deployed, you'll get a URL like: `https://amazkart-frontend.vercel.app`

---

## Step 5: Final Configuration

### 5.1 Update Backend with Frontend URL

Go back to **Render** dashboard:

1. Open your backend service settings
2. Update `FRONTEND_URL` environment variable with your Vercel URL
3. Redeploy the service

### 5.2 Test the Complete Application

1. Open your Vercel frontend URL
2. Try browsing products
3. Add items to cart
4. Check if everything works

### 5.3 Seed the Database

Once everything is deployed, seed your MongoDB database:

```powershell
# Option 1: Using curl
$backendUrl = "https://amazkart-backend.onrender.com"
Invoke-WebRequest -Uri "$backendUrl/api/seed?seedKey=your-secret-key-here" -Method GET

# Option 2: Using PowerShell
$response = Invoke-WebRequest -Uri "$backendUrl/api/seed" `
  -Headers @{"x-seed-key" = "your-secret-key-here"} `
  -Method GET

Write-Host $response.Content
```

---

## Quick Summary

| Component | URL | Platform |
|-----------|-----|----------|
| Frontend | `https://amazkart-frontend.vercel.app` | Vercel |
| Backend API | `https://amazkart-backend.onrender.com` | Render |
| Database | MongoDB Atlas | Cloud |
| Code Repository | `https://github.com/Dracorav/Ecomerce-website-main` | GitHub |

---

## Troubleshooting

### Issue: Frontend can't connect to backend

**Solution:**
1. Check `REACT_APP_API_URL` environment variable in Vercel
2. Verify backend `FRONTEND_URL` environment variable in Render
3. Check CORS configuration in `server/src/server.js`
4. Ensure backend is running (check Render logs)

### Issue: Products not showing

**Solution:**
1. Check if database was seeded
2. Verify `MONGODB_URI` is correct in Render environment
3. Check Render logs for MongoDB connection errors
4. Test API directly: `https://your-backend-url/api/products`

### Issue: Page shows "Cannot GET" error

**Solution:**
1. Make sure you're accessing the correct URL
2. Check Vercel deployment logs
3. Verify build command ran successfully
4. Clear browser cache and restart

### Issue: Seeding fails

**Solution:**
1. Verify `SEED_KEY` matches in the request
2. Check MongoDB Atlas connection string
3. Ensure database user has permissions
4. Check if products collection exists

### Issue: CORS errors

**Solution:**
1. The server already has CORS configured
2. If still getting errors, check the exact origin in browser console
3. Update `allowedOrigins` array in `server/src/server.js`
4. Redeploy backend

---

## Next Steps

After successful deployment:

1. ✅ Test all features (browse, add to cart, search)
2. ✅ Share your deployed URL with others
3. ✅ Monitor Render and Vercel dashboards
4. ✅ Set up custom domain (optional)
5. ✅ Add analytics/monitoring
6. ✅ Plan backend enhancements (checkout, payments, etc.)

---

## Getting Help

- **Render Docs:** https://render.com/docs
- **Vercel Docs:** https://vercel.com/docs
- **MongoDB Atlas Docs:** https://docs.atlas.mongodb.com
- **GitHub Docs:** https://docs.github.com

---

**Good luck with your deployment! 🎉**
