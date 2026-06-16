# Push Archiproject website update to GitHub
# Repo: https://github.com/jbeltri/Archiproject
# Run in PowerShell on your Windows computer.

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/jbeltri/Archiproject.git"
$SourceWebsite = "E:\Archiproject_website\Archiproject_website"
$WorkFolder = "E:\Archiproject_website\Archiproject_github_work"
$CommitMessage = "Update Archiproject website with dynamic regional portfolio samples"

Write-Host "Checking source website folder..." -ForegroundColor Cyan
if (!(Test-Path $SourceWebsite)) {
    throw "Source folder not found: $SourceWebsite"
}

Write-Host "Preparing Git working folder..." -ForegroundColor Cyan
if (Test-Path $WorkFolder) {
    Write-Host "Existing work folder found. Pulling latest changes..." -ForegroundColor Yellow
    Set-Location $WorkFolder
    git pull --rebase
} else {
    git clone $RepoUrl $WorkFolder
    Set-Location $WorkFolder
}

Write-Host "Copying updated website files into the GitHub repo folder..." -ForegroundColor Cyan
Copy-Item -Path "$SourceWebsite\*" -Destination $WorkFolder -Recurse -Force

Write-Host "Git status after copy:" -ForegroundColor Cyan
git status --short

Write-Host "Adding files..." -ForegroundColor Cyan
git add .

$Changes = git status --porcelain
if ([string]::IsNullOrWhiteSpace($Changes)) {
    Write-Host "No changes to commit. Repository is already up to date." -ForegroundColor Green
    exit 0
}

Write-Host "Committing changes..." -ForegroundColor Cyan
git commit -m $CommitMessage

Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
$Branch = git branch --show-current
if ([string]::IsNullOrWhiteSpace($Branch)) { $Branch = "main" }
git push origin $Branch

Write-Host "Done. Updated GitHub repo: $RepoUrl" -ForegroundColor Green
