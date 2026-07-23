# ==============================================================================
# STATIC SITE CLONER 4.0 INTERACTIVE
# Windows 10/11 + PowerShell + Wget
# ==============================================================================

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "      STATIC SITE CLONER 4.0"
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# ==============================================================================
# NHAP URL
# ==============================================================================

$TargetUrl = Read-Host "Nhap URL website"

if ([string]::IsNullOrWhiteSpace($TargetUrl)) {
    Write-Error "URL khong hop le"
    exit
}

try {
    $uri = [System.Uri]$TargetUrl
}
catch {
    Write-Error "URL khong hop le"
    exit
}

# ==============================================================================
# TEN THU MUC TU DONG
# ==============================================================================

$SiteName =
    $uri.Host `
        .Replace("www.","") `
        .Replace(":","_")

$OutputDir =
    Join-Path `
        ([Environment]::GetFolderPath("Desktop")) `
        $SiteName

$LogFile =
    Join-Path `
        $OutputDir `
        "wget.log"

# ==============================================================================
# TIM WGET
# ==============================================================================

Write-Host ""
Write-Host "[1/3] Kiem tra Wget..." -ForegroundColor Cyan

$wgetExePath = $null

$possiblePaths = @(
    "$env:LOCALAPPDATA\Microsoft\WinGet\Links\wget.exe",
    "$env:ProgramFiles\GNU\Wget\wget.exe",
    "$env:ProgramFiles(x86)\GNU\Wget\wget.exe"
) + (
    Get-ChildItem `
        -Path "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" `
        -Filter "wget.exe" `
        -Recurse `
        -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty FullName
)

foreach ($p in $possiblePaths) {
    if (Test-Path $p) {
        $wgetExePath = $p
        break
    }
}

if (-not $wgetExePath) {

    Write-Host "Dang cai Wget..." -ForegroundColor Yellow

    winget install `
        --id JernejSimoncic.Wget `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

    # Dò lại toàn bộ danh sách sau khi cài, không gán cứng 1 path
    foreach ($p in $possiblePaths) {
        if (Test-Path $p) {
            $wgetExePath = $p
            break
        }
    }
}

if (-not $wgetExePath) {
    Write-Error "Khong tim thay Wget"
    exit
}

Write-Host "Wget OK" -ForegroundColor Green

# ==============================================================================
# THU MUC
# ==============================================================================

if (-not (Test-Path $OutputDir)) {
    New-Item `
        -ItemType Directory `
        -Path $OutputDir `
        -Force | Out-Null
}

# ==============================================================================
# USER AGENT
# ==============================================================================

$UserAgent =
"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36"

# ==============================================================================
# CHAY WGET
# ==============================================================================

Write-Host ""
Write-Host "[2/3] Dang clone..." -ForegroundColor Cyan
Write-Host "URL : $TargetUrl"
Write-Host "DIR : $OutputDir"
Write-Host ""

$args = @(

    "--mirror"

    "--convert-links"

    "--adjust-extension"

    "--page-requisites"

    "--no-parent"

    "--continue"

    "--timestamping"

    "--retry-connrefused"

    "--tries=10"

    "--timeout=30"

    "--wait=1"

    "--random-wait"

    "--no-check-certificate"

    "-e"
    "robots=off"

    "--user-agent=$UserAgent"

    "-o"
    $LogFile

    "-P"
    $OutputDir

    $TargetUrl
)

& $wgetExePath $args

# ==============================================================================
# KET THUC
# ==============================================================================

Write-Host ""
Write-Host "[3/3] Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "Thu muc : $OutputDir"
Write-Host "Log     : $LogFile"
Write-Host ""
