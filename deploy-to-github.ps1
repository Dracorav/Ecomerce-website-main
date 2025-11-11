#!/usr/bin/env pwsh
<#
.SYNOPSIS
    GitHub deployment script for AmazKart project
    
.DESCRIPTION
    Initializes git, commits all changes, and pushes to GitHub repository
    
.EXAMPLE
    .\deploy-to-github.ps1
#>

param(
    [string]$GitHubUrl = "https://github.com/Dracorav/Ecomerce-website-main.git",
    [string]$CommitMessage = "AmazKart: Complete e-commerce application with Render backend and Vercel frontend"
)

# Color functions
function Write-Success {
    Write-Host "✅ $args" -ForegroundColor Green
}

function Write-Error {
    Write-Host "❌ $args" -ForegroundColor Red
}

function Write-Info {
    Write-Host "ℹ️  $args" -ForegroundColor Cyan
}

function Write-Warning {
    Write-Host "⚠️  $args" -ForegroundColor Yellow
}

# Main script
Write-Info "Starting GitHub deployment..."
Write-Info "Repository: $GitHubUrl"

try {
    # Check if git is installed
    $gitVersion = git --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Git is not installed or not in PATH"
        exit 1
    }
    Write-Success "Git found: $gitVersion"

    # Check if we're in the correct directory
    if (-not (Test-Path "package.json")) {
        Write-Error "package.json not found. Please run this script from the project root."
        exit 1
    }
    Write-Success "Found package.json - in correct directory"

    # Initialize git if needed
    if (-not (Test-Path ".git")) {
        Write-Info "Initializing git repository..."
        git init
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Git repository initialized"
        } else {
            Write-Error "Failed to initialize git"
            exit 1
        }
    } else {
        Write-Success "Git repository already initialized"
    }

    # Check for existing remote
    $remoteExists = git remote get-url origin 2>$null
    if ($remoteExists) {
        Write-Info "Updating existing remote..."
        git remote set-url origin $GitHubUrl
    } else {
        Write-Info "Adding GitHub remote..."
        git remote add origin $GitHubUrl
    }
    Write-Success "Remote configured: $GitHubUrl"

    # Add all files
    Write-Info "Staging all files..."
    git add .
    Write-Success "Files staged for commit"

    # Check if there are changes to commit
    $hasChanges = git status --porcelain | Measure-Object | Select-Object -ExpandProperty Count
    if ($hasChanges -eq 0) {
        Write-Warning "No changes to commit"
        exit 0
    }

    # Create commit
    Write-Info "Creating commit..."
    git commit -m $CommitMessage
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Commit created successfully"
    } else {
        Write-Error "Failed to create commit"
        exit 1
    }

    # Ensure main branch exists
    Write-Info "Checking branch..."
    $currentBranch = git rev-parse --abbrev-ref HEAD 2>$null
    if ($currentBranch -ne "main") {
        Write-Info "Renaming branch to main..."
        git branch -M main
        Write-Success "Branch renamed to main"
    } else {
        Write-Success "Already on main branch"
    }

    # Push to GitHub
    Write-Info "Pushing to GitHub (this may prompt for authentication)..."
    Write-Warning "If prompted, use your GitHub username and Personal Access Token (PAT)"
    Write-Info "To create a PAT: Settings → Developer settings → Personal access tokens → Generate new token"
    Write-Info "Token should have 'repo' scope"
    
    git push -u origin main
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Successfully pushed to GitHub!"
    } else {
        Write-Error "Failed to push to GitHub"
        Write-Warning "Please check your GitHub credentials and internet connection"
        exit 1
    }

    Write-Success "✨ Deployment to GitHub complete!"
    Write-Info ""
    Write-Info "Next steps:"
    Write-Info "1. Open https://github.com/Dracorav/Ecomerce-website-main"
    Write-Info "2. Go to Settings → Deployment → Environments"
    Write-Info "3. Connect to Render and Vercel"
    Write-Info ""
    Write-Info "For complete deployment guide, see: COMPLETE_DEPLOYMENT_GUIDE.md"

} catch {
    Write-Error "An error occurred: $_"
    exit 1
}
