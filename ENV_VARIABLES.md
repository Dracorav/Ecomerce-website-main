# Environment Variables Setup for AmazKart

This file explains all environment variables needed for development and production.

## Local Development (.env file in root)

Create a `.env` file in the root directory with:

```env
# Server Configuration
PORT=5000
NODE_ENV=development

# MongoDB Connection
MONGODB_URI=mongodb+srv://admin:YOUR_PASSWORD@cluster-name.mongodb.net/ecommerce?retryWrites=true&w=majority

# Seed Configuration
SEED_KEY=changeme

# Frontend URL (for CORS)
FRONTEND_URL=http://localhost:3000

# Vercel Preview URL (optional)
VERCEL_URL=

# React App Configuration
REACT_APP_API_URL=http://localhost:5000
```

## Server Environment Variables (Render Deployment)

Set these in **Render Dashboard → Environment**:

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `MONGODB_URI` | MongoDB Atlas connection string | `mongodb+srv://admin:password@cluster.mongodb.net/ecommerce?retryWrites=true&w=majority` |
| `SEED_KEY` | Protection key for seed endpoint | `your-secret-key-here` |
| `NODE_ENV` | Environment mode | `production` |

### Optional Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `FRONTEND_URL` | Frontend application URL | `https://amazkart-frontend.vercel.app` |
| `PORT` | Server port (usually auto-set) | `5000` |

## Client Environment Variables (Vercel Deployment)

Set these in **Vercel Dashboard → Settings → Environment Variables**:

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `REACT_APP_API_URL` | Backend API URL | `https://amazkart-backend.onrender.com` |

## How to Get MongoDB Connection String

1. Go to MongoDB Atlas (https://www.mongodb.com/cloud/atlas)
2. Create/access your cluster
3. Click "Connect"
4. Select "Drivers" → "Node.js"
5. Copy the connection string
6. Replace `<password>` with your MongoDB user password

**Format:**
```
mongodb+srv://username:password@cluster-name.mongodb.net/ecommerce?retryWrites=true&w=majority
```

## Creating a Strong Seed Key

For production, create a secure seed key:

```bash
# Using Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Using PowerShell
[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([guid]::NewGuid().ToString()))
```

## Security Notes

⚠️ **Important Security Tips:**

1. **Never commit `.env` files** - They're in `.gitignore` for a reason
2. **Rotate seed keys regularly** - Change them periodically in production
3. **Use strong MongoDB passwords** - At least 16 characters with mixed case and symbols
4. **Whitelist IP addresses** - In MongoDB Atlas, only allow your deployment services
5. **Enable SSL/TLS** - MongoDB Atlas provides this by default
6. **Validate all inputs** - Even though we don't have auth yet, validate everything

## Testing Environment Variables

### Test Backend Connection

```powershell
# Test health endpoint
$backendUrl = $env:REACT_APP_API_URL
if (-not $backendUrl) { $backendUrl = "http://localhost:5000" }

Invoke-WebRequest -Uri "$backendUrl/api/health"
```

### Test Database Connection

```powershell
# Seed the database
$backendUrl = "http://localhost:5000"
$seedKey = "changeme"  # Use your actual seed key

Invoke-WebRequest -Uri "$backendUrl/api/seed?seedKey=$seedKey"
```

## Troubleshooting

### "MONGODB_URI is not defined"
- Check that `MONGODB_URI` is set in your `.env` file (local) or environment variables (Render)
- Verify the connection string format is correct
- Ensure the password doesn't contain special characters that need URL encoding

### "Cannot connect to MongoDB"
- Check internet connectivity
- Verify IP is whitelisted in MongoDB Atlas
- Ensure MongoDB user has permissions
- Check if cluster is paused/suspended

### "CORS errors"
- Verify `FRONTEND_URL` matches your actual frontend domain
- Check browser console for exact origin error
- Make sure backend is deployed and running

## Environment Variables by Stage

### 1. Local Development
```env
NODE_ENV=development
PORT=5000
MONGODB_URI=mongodb+srv://admin:password@localhost/ecommerce
SEED_KEY=changeme
REACT_APP_API_URL=http://localhost:5000
```

### 2. Staging/Testing
```env
NODE_ENV=development
PORT=auto (Render sets this)
MONGODB_URI=mongodb+srv://admin:password@cluster-staging.mongodb.net/ecommerce
SEED_KEY=staging-secret-key
REACT_APP_API_URL=https://amazkart-staging.onrender.com
FRONTEND_URL=https://amazkart-staging.vercel.app
```

### 3. Production
```env
NODE_ENV=production
PORT=auto (Render sets this)
MONGODB_URI=mongodb+srv://admin:password@cluster-prod.mongodb.net/ecommerce
SEED_KEY=production-secret-key-change-regularly
REACT_APP_API_URL=https://amazkart-backend.onrender.com
FRONTEND_URL=https://amazkart-frontend.vercel.app
```

## Updating Environment Variables After Deployment

### On Render
1. Go to your service dashboard
2. Click "Environment"
3. Update the variables
4. Click "Save" - this will trigger a redeploy
5. Wait for the service to restart

### On Vercel
1. Go to your project settings
2. Click "Environment Variables"
3. Add/update/delete variables
4. The next deployment will use the new variables
5. You can trigger a redeploy from the "Deployments" tab

## See Also
- `COMPLETE_DEPLOYMENT_GUIDE.md` - Step-by-step deployment guide
- `README.md` - Project overview
- `ENV_SETUP.md` - Original environment setup notes
