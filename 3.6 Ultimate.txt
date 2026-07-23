```powershell
# ==============================================================================
# STATIC SITE CLONER 3.6 ULTIMATE
# WGET + POWERSHELL
# ==============================================================================

Write-Host "[1/3] Kiem tra Wget..." -ForegroundColor Cyan

$wgetExePath = $null

$possiblePaths = @(
    "$env:LOCALAPPDATA\Microsoft\WinGet\Links\wget.exe",
    "$env:ProgramFiles\GNU\Wget\wget.exe",
    "$env:ProgramFiles(x86)\GNU\Wget\wget.exe"
) + (
    Get-ChildItem `
        "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" `
        -Filter "wget.exe" `
        -Recurse `
        -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty FullName
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $wgetExePath = $path
        break
    }
}

if (-not $wgetExePath) {

    Write-Host "Dang cai dat Wget..." -ForegroundColor Yellow

    winget install `
        --id JernejSimoncic.Wget `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements

    $env:Path =
        [Environment]::GetEnvironmentVariable("Path","Machine") +
        ";" +
        [Environment]::GetEnvironmentVariable("Path","User")

    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            $wgetExePath = $path
            break
        }
    }
}

if (-not $wgetExePath) {
    Write-Error "Khong tim thay wget.exe"
    exit
}

Write-Host "Wget: $wgetExePath" -ForegroundColor Green

# ==============================================================================
# CAU HINH
# ==============================================================================

$TargetUrl = "https://example.com"

$OutputDir = Join-Path `
    $env:USERPROFILE `
    "Desktop\cloned_site"

$LogFile = Join-Path `
    $OutputDir `
    "wget.log"

$UserAgent =
"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36"

if (-not (Test-Path $OutputDir)) {
    New-Item `
        -ItemType Directory `
        -Path $OutputDir `
        -Force | Out-Null
}

Write-Host "[2/3] Bat dau clone..." -ForegroundColor Cyan
Write-Host "URL : $TargetUrl"
Write-Host "DIR : $OutputDir"

# ==============================================================================
# WGET FLAGS
# ==============================================================================

$wargs = @(

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

& $wgetExePath $wargs

Write-Host ""
Write-Host "[3/3] Hoan tat!" -ForegroundColor Green
Write-Host "Thu muc : $OutputDir"
Write-Host "Log     : $LogFile"
Write-Host ""
```
