# clone-4.9.ps1

```powershell id="j7g2xw"
# ==============================================================================
# STATIC SITE CLONER 4.9 ARCHIVE EDITION
# Windows 10 / 11
# Maximum Reliability Wget Build
# ==============================================================================

Clear-Host

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "       STATIC SITE CLONER 4.9 ARCHIVE"
Write-Host "==================================================" -ForegroundColor Cyan
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

$HostName   = $Uri.Host
$RootDomain = $HostName.Replace("www.","")

# ------------------------------------------------------------------------------
# OUTPUT
# ------------------------------------------------------------------------------

$Timestamp =
Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$OutputDir =
Join-Path $env:USERPROFILE "Desktop\$RootDomain"

if (-not (Test-Path $OutputDir)) {
    New-Item `
        -ItemType Directory `
        -Path $OutputDir `
        -Force | Out-Null
}

# ------------------------------------------------------------------------------
# LOGS
# ------------------------------------------------------------------------------

$LogDir =
Join-Path $OutputDir "_logs"

if (-not (Test-Path $LogDir)) {
    New-Item `
        -ItemType Directory `
        -Path $LogDir `
        -Force | Out-Null
}

$WgetLog =
Join-Path $LogDir "wget_$Timestamp.log"

$SummaryLog =
Join-Path $LogDir "summary_$Timestamp.txt"

# ------------------------------------------------------------------------------
# FIND WGET
# ------------------------------------------------------------------------------

Write-Host "[1/5] Kiem tra Wget..." -ForegroundColor Cyan

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
# DOMAIN DISCOVERY
# ------------------------------------------------------------------------------

Write-Host "[2/5] Tao danh sach host..." -ForegroundColor Cyan

$Domains = @(
    $HostName
)

if ($HostName -notlike "www.*") {
    $Domains += "www.$RootDomain"
}

$Domains += @(
    "cdn.$RootDomain"
    "static.$RootDomain"
    "img.$RootDomain"
    "images.$RootDomain"
    "assets.$RootDomain"
    "media.$RootDomain"
    "files.$RootDomain"
)

$DomainList =
($Domains | Select-Object -Unique) -join ","

# ------------------------------------------------------------------------------
# CLONE
# ------------------------------------------------------------------------------

Write-Host "[3/5] Bat dau clone..." -ForegroundColor Cyan

$StartTime = Get-Date

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

    "--tries=20"

    "--timeout=30"

    "--dns-timeout=15"

    "--connect-timeout=15"

    "--read-timeout=30"

    "--wait=1"

    "--random-wait"

    "--continue"

    "--timestamping"

    "--compression=auto"

    "--execute"
    "robots=off"

    "--user-agent=$UserAgent"

    "-o"
    $WgetLog

    "-P"
    $OutputDir

    $TargetUrl
)

& $wgetPath $args

$EndTime = Get-Date

# ------------------------------------------------------------------------------
# STATISTICS
# ------------------------------------------------------------------------------

Write-Host "[4/5] Thu thap thong ke..." -ForegroundColor Cyan

$Files =
Get-ChildItem `
    $OutputDir `
    -Recurse `
    -File `
    -ErrorAction SilentlyContinue

$FileCount =
$Files.Count

$TotalBytes =
($Files | Measure-Object Length -Sum).Sum

$TotalMB =
[math]::Round($TotalBytes / 1MB, 2)

$Duration =
New-TimeSpan `
    -Start $StartTime `
    -End $EndTime

# ------------------------------------------------------------------------------
# SUMMARY
# ------------------------------------------------------------------------------

@"
==================================================
STATIC SITE CLONER 4.9 REPORT
==================================================

Website:
$TargetUrl

Folder:
$OutputDir

Files:
$FileCount

Size:
$TotalMB MB

Duration:
$Duration

Wget:
$wgetPath

Log:
$WgetLog

Generated:
$(Get-Date)

==================================================
"@ | Set-Content $SummaryLog

# ------------------------------------------------------------------------------
# COMPLETE
# ------------------------------------------------------------------------------

Write-Host ""
Write-Host "[5/5] HOAN TAT" -ForegroundColor Green
Write-Host ""

Write-Host "Website : $TargetUrl"
Write-Host "Folder  : $OutputDir"
Write-Host "Files   : $FileCount"
Write-Host "Size    : $TotalMB MB"
Write-Host "Log     : $WgetLog"
Write-Host "Report  : $SummaryLog"

Write-Host ""
Write-Host "Archive completed successfully."
Write-Host ""
```
