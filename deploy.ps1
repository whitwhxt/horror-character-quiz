# Complete GitHub Deployment Script
# This will set up and push everything to your GitHub repository

$username = "whitwhxt"
$repoName = "horror-character-quiz"
$email = "onoberhiew@gmail.com"

Write-Host "Deploying to GitHub..." -ForegroundColor Cyan
Write-Host "Repository: https://github.com/$username/$repoName" -ForegroundColor Yellow
Write-Host ""

# Check if git is available
$gitPath = $null
$possiblePaths = @(
    "git",
    "C:\Program Files\Git\bin\git.exe",
    "C:\Program Files (x86)\Git\bin\git.exe",
    "$env:LOCALAPPDATA\Programs\Git\bin\git.exe"
)

foreach ($path in $possiblePaths) {
    try {
        if ($path -eq "git") {
            $result = Get-Command git -ErrorAction SilentlyContinue
            if ($result) {
                $gitPath = "git"
                break
            }
        } else {
            if (Test-Path $path) {
                $gitPath = $path
                break
            }
        }
    } catch {
        continue
    }
}

if (-not $gitPath) {
    Write-Host "Git is not installed or not found in PATH." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Git from: https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "After installing Git, run this script again." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Or manually run these commands:" -ForegroundColor Cyan
    Write-Host "  git init" -ForegroundColor White
    Write-Host "  git config user.email `"$email`"" -ForegroundColor White
    Write-Host "  git config user.name `"$username`"" -ForegroundColor White
    Write-Host "  git add ." -ForegroundColor White
    Write-Host "  git commit -m `"Initial commit: Horror Character Quiz`"" -ForegroundColor White
    Write-Host "  git branch -M main" -ForegroundColor White
    Write-Host "  git remote add origin https://github.com/$username/$repoName.git" -ForegroundColor White
    Write-Host "  git push -u origin main" -ForegroundColor White
    exit 1
}

Write-Host "Git found! Setting up repository..." -ForegroundColor Green
Write-Host ""

# Initialize git if not already done
if (-not (Test-Path .git)) {
    Write-Host "Initializing git repository..." -ForegroundColor Yellow
    & $gitPath init
}

# Set git config
Write-Host "Configuring git user..." -ForegroundColor Yellow
& $gitPath config user.email $email
& $gitPath config user.name $username

# Add all files
Write-Host "Adding files..." -ForegroundColor Yellow
& $gitPath add .

# Create initial commit
Write-Host "Creating commit..." -ForegroundColor Yellow
& $gitPath commit -m "Initial commit: Horror Character Quiz"

# Set main branch
Write-Host "Setting main branch..." -ForegroundColor Yellow
& $gitPath branch -M main

# Check if remote exists
$remoteExists = & $gitPath remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Adding remote repository..." -ForegroundColor Yellow
    & $gitPath remote add origin "https://github.com/$username/$repoName.git"
} else {
    Write-Host "Remote already exists, updating..." -ForegroundColor Yellow
    & $gitPath remote set-url origin "https://github.com/$username/$repoName.git"
}

Write-Host ""
Write-Host "Ready to push!" -ForegroundColor Green
Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
& $gitPath push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Success! Your quiz is now on GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next step: Enable GitHub Pages" -ForegroundColor Cyan
    Write-Host "1. Go to: https://github.com/$username/$repoName/settings/pages" -ForegroundColor White
    Write-Host "2. Under 'Source', select 'Deploy from a branch'" -ForegroundColor White
    Write-Host "3. Select 'main' branch and '/ (root)' folder" -ForegroundColor White
    Write-Host "4. Click Save" -ForegroundColor White
    Write-Host ""
    Write-Host "Your quiz will be live at:" -ForegroundColor Green
    Write-Host "https://$username.github.io/$repoName/" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "Push failed. You may need to:" -ForegroundColor Red
    Write-Host "1. Make sure the repository exists at: https://github.com/$username/$repoName" -ForegroundColor Yellow
    Write-Host "2. Authenticate with GitHub (you may be prompted for credentials)" -ForegroundColor Yellow
    Write-Host "3. If using 2FA, use a Personal Access Token as your password" -ForegroundColor Yellow
}
