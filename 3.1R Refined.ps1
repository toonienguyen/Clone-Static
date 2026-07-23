# ==============================================================================
# STATIC SITE CLONER 3.1R REFINED
# ==============================================================================
<#
.SYNOPSIS
    Script tải trọn bộ Static Website bằng Wget trên PowerShell.
    Phiên bản 3.1R (Refined)
#>

# ============================================================================
# 1. CẤU HÌNH
# ============================================================================

$TargetURL = "https://example.com"
$OutputDir = "$ENV:USERPROFILE\Desktop\cloned_site"

$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"

# ============================================================================
# 2. KIỂM TRA WGET
# ============================================================================

Write-Host "[1/3] Kiểm tra công cụ Wget..." -ForegroundColor Cyan

function Get-WgetBinaryPath {

    $cmd = Get-Command wget.exe -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandType -eq "Application" }

    if ($cmd) {
        return $cmd.Source
    }

    $wingetLinkPath =
        "$ENV:LOCALAPPDATA\Microsoft\WinGet\Links\wget.exe"

    if (Test-Path $wingetLinkPath) {
        return $wingetLinkPath
    }

    $wingetPackage =
        Get-ChildItem `
            "$ENV:LOCALAPPDATA\Microsoft\WinGet\Packages" `
            -Filter "wget.exe" `
            -Recurse `
            -ErrorAction SilentlyContinue |
        Select-Object -First 1

    if ($wingetPackage) {
        return $wingetPackage.FullName
    }

    return $null
}

$WgetPath = Get-WgetBinaryPath

if (-not $WgetPath) {

    Write-Host "-> Đang cài đặt Wget..." -ForegroundColor Yellow

    winget install `
        --id JernejSimoncic.Wget `
        --silent `
        --accept-source-agreements `
        --accept-package-agreements

    $ENV:PATH =
        [System.Environment]::GetEnvironmentVariable("Path","Machine") +
        ";" +
        [System.Environment]::GetEnvironmentVariable("Path","User")

    $WgetPath = Get-WgetBinaryPath
}

if (-not $WgetPath) {
    Write-Error "Không thể tìm thấy hoặc cài đặt wget.exe"
    exit 1
}

Write-Host "-> Wget: $WgetPath" -ForegroundColor Green

# ============================================================================
# 3. THƯ MỤC ĐẦU RA
# ============================================================================

Write-Host "[2/3] Chuẩn bị thư mục..." -ForegroundColor Cyan

if (-not (Test-Path $OutputDir)) {
    New-Item `
        -ItemType Directory `
        -Path $OutputDir `
        -Force | Out-Null
}

$LogFile = Join-Path $OutputDir "wget.log"

# ============================================================================
# 4. CLONE WEBSITE
# ============================================================================

Write-Host "[3/3] Clone website..." -ForegroundColor Cyan

$wgetArgs = @(

    "--mirror"

    "--convert-links"

    "--page-requisites"

    "--adjust-extension"

    "--no-parent"

    "--retry-connrefused"

    "--tries=10"

    "--continue"

    "--timestamping"

    "--user-agent=$UserAgent"

    "-o"
    $LogFile

    "-P"
    $OutputDir

    $TargetURL
)

& $WgetPath $wgetArgs

Write-Host ""
Write-Host "Hoàn thành!" -ForegroundColor Green
Write-Host "Folder : $OutputDir"
Write-Host "Log    : $LogFile"
Write-Host ""
