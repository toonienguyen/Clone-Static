# ==============================================================================
# STATIC SITE CLONER 4.6
# Windows 10 / 11
# Wget Optimized Edition
# ==============================================================================

Clear-Host

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "         STATIC SITE CLONER 4.6"
Write-Host "============================================" -ForegroundColor Cyan
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

$HostName = $Uri.Host
$RootDomain = $HostName.Replace("www.","")

# ------------------------------------------------------------------------------
# OUTPUT
# ------------------------------------------------------------------------------

$OutputDir = Join-Path $env:USERPROFILE "Desktop\$RootDomain"

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# ------------------------------------------------------------------------------
# WGET
# ------------------------------------------------------------------------------

Write-Host ""
Write-Host "[1/4] Kiem tra Wget..." -ForegroundColor Cyan

$wgetPath = (Get-Command wget.exe -ErrorAction SilentlyContinue).Path

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

    Write-Host "Dang cai dat Wget..." -ForegroundColor Yellow

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

$LogFile = Join-Path $OutputDir "wget.log"

# ------------------------------------------------------------------------------
# CDN SUPPORT
# ------------------------------------------------------------------------------

Write-Host ""
Write-Host "[2/4] Cau hinh crawl..." -ForegroundColor Cyan

$Domains = @(
    $HostName
)

# Thêm www nếu chưa có
if ($HostName -notlike "www.*") {
    $Domains += "www.$RootDomain"
}

# Một số subdomain CDN phổ biến
$Domains += @(
    "cdn.$RootDomain"
    "static.$RootDomain"
    "img.$RootDomain"
    "images.$RootDomain"
    "assets.$RootDomain"
)

$DomainList =
($Domains | Select-Object -Unique) -join ","

Write-Host "Domains:"
$Domains | ForEach-Object {
    Write-Host " - $_"
}

# ------------------------------------------------------------------------------
# CLONE
# ------------------------------------------------------------------------------

Write-Host ""
Write-Host "[3/4] Dang clone..." -ForegroundColor Cyan

$args = @(

    "--mirror"

    "--convert-links"

    "--adjust-extension"

    "--page-requisites"

    "--no-parent"

    "-H"

    "--domains=$DomainList"

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
Write-Host "[4/4] Hoan tat!" -ForegroundColor Green

$FileCount =
(Get-ChildItem $OutputDir -Recurse -File -ErrorAction SilentlyContinue).Count

Write-Host ""
Write-Host "Website : $TargetUrl"
Write-Host "Folder  : $OutputDir"
Write-Host "Files   : $FileCount"
Write-Host "Log     : $LogFile"
Write-Host ""
