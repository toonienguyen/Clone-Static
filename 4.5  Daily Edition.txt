# clone-4.5.ps1

```powershell
# ==============================================================================
# STATIC SITE CLONER 4.5 DAILY EDITION
# Windows 10 / 11
# ==============================================================================

Clear-Host

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "      STATIC SITE CLONER 4.5"
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------------------------------------------
# URL
# ------------------------------------------------------------------------------

$TargetUrl = Read-Host "Nhap URL website"

if ([string]::IsNullOrWhiteSpace($TargetUrl)) {
    Write-Error "URL khong hop le."
    exit
}

try {
    $Uri = [System.Uri]$TargetUrl
}
catch {
    Write-Error "URL khong hop le."
    exit
}

$Domain = $Uri.Host.Replace("www.","")

# ------------------------------------------------------------------------------
# OUTPUT
# ------------------------------------------------------------------------------

$OutputDir = Join-Path $env:USERPROFILE "Desktop\$Domain"

if (-not (Test-Path $OutputDir)) {
    New-Item `
        -ItemType Directory `
        -Force `
        -Path $OutputDir | Out-Null
}

# ------------------------------------------------------------------------------
# FIND WGET
# ------------------------------------------------------------------------------

Write-Host ""
Write-Host "[1/4] Kiem tra Wget..." -ForegroundColor Cyan

$wgetPath =
(Get-Command wget.exe -ErrorAction SilentlyContinue).Path

if (-not $wgetPath) {

    $wgetPath = (
        Get-ChildItem `
            "$env:LOCALAPPDATA\Microsoft\WinGet" `
            -Filter wget.exe `
            -Recurse `
            -ErrorAction SilentlyContinue |
        Select-Object -First 1
    ).FullName
}

if (-not $wgetPath) {

    Write-Host "Dang cai Wget..." -ForegroundColor Yellow

    winget install `
        --id JernejSimoncic.Wget `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

    Start-Sleep 5

    $wgetPath = (
        Get-ChildItem `
            "$env:LOCALAPPDATA\Microsoft\WinGet" `
            -Filter wget.exe `
            -Recurse `
            -ErrorAction SilentlyContinue |
        Select-Object -First 1
    ).FullName
}

if (-not $wgetPath) {
    Write-Error "Khong tim thay wget.exe"
    exit
}

Write-Host "OK -> $wgetPath" -ForegroundColor Green

# ------------------------------------------------------------------------------
# USER AGENT
# ------------------------------------------------------------------------------

$UserAgent =
"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"

# ------------------------------------------------------------------------------
# LOG
# ------------------------------------------------------------------------------

$LogFile =
Join-Path $OutputDir "wget.log"

# ------------------------------------------------------------------------------
# CLONE
# ------------------------------------------------------------------------------

Write-Host ""
Write-Host "[2/4] Dang clone..." -ForegroundColor Cyan

$args = @(

    "--mirror"

    "--convert-links"

    "--adjust-extension"

    "--page-requisites"

    "--no-parent"

    "--restrict-file-names=windows"

    "--retry-connrefused"

    "--tries=15"

    "--timeout=30"

    "--wait=1"

    "--random-wait"

    "--continue"

    "--timestamping"

    "-e"
    "robots=off"

    "--user-agent=$UserAgent"

    "-o"
    $LogFile

    "-P"
    $OutputDir

    $TargetUrl
)

& $wgetPath $args

# ------------------------------------------------------------------------------
# SUMMARY
# ------------------------------------------------------------------------------

Write-Host ""
Write-Host "[3/4] Hoan tat"

$FileCount =
(Get-ChildItem `
    $OutputDir `
    -Recurse `
    -File `
    -ErrorAction SilentlyContinue).Count

Write-Host ""
Write-Host "Website : $TargetUrl"
Write-Host "Folder  : $OutputDir"
Write-Host "Files   : $FileCount"
Write-Host "Log     : $LogFile"

Write-Host ""
Write-Host "[4/4] Xong!"
Write-Host ""
```
