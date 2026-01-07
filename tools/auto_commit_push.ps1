$ErrorActionPreference = "Stop"

$RepoDir = "C:\Users\north\Documents\GitHub\Running-Research"
Set-Location $RepoDir

# Safety checks
if (-not (Test-Path ".git")) {
    throw "Not a git repository: $RepoDir"
}

# Make sure we are on main
$branch = (git rev-parse --abbrev-ref HEAD).Trim()
if ($branch -ne "main") {
    throw "Expected branch main but found $branch"
}

# Stage everything
git add -A

# If nothing staged, exit quietly
git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    exit 0
}

# Commit with timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Nightly research log update" -m "Auto commit at $timestamp"

# Push
git push origin main
