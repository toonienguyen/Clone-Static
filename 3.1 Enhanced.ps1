<#
.SYNOPSIS
    Script tải trọn bộ Static Website bằng Wget trên PowerShell.
#>

# 1. Cấu hình thông tin tải về
$TargetURL = "https://giaitri321.vip/doc-truyen/truyen-hay/"                # Thay bằng URL website bạn muốn clone
$OutputDir = "$ENV:USERPROFILE\Desktop\cloned_site" # Thư mục lưu kết quả (Ví dụ: Desktop)

# User-Agent giả lập Chrome trên Windows 10/11
$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"

# ------------------------------------------------------------------------------

# 2. Kiểm tra và cài đặt Wget qua Winget nếu chưa có
Write-Host "[1/3] Kiểm tra công cụ Wget..." -ForegroundColor Cyan

function Get-WgetBinaryPath {
    # Kiểm tra trong PATH môi trường
    $cmd = Get-Command wget.exe -ErrorAction SilentlyContinue | Where-Object { $_.CommandType -eq "Application" }
    if ($cmd) { return $cmd.Source }

    # Dò tìm trực tiếp trong thư mục WinGetLinks (nơi winget tạo symlink mặc định)
    $wingetLinkPath = "$ENV:LOCALAPPDATA\Microsoft\WinGet\Links\wget.exe"
    if (Test-Path $wingetLinkPath) { return $wingetLinkPath }

    # Dò tìm trong thư mục Packages của Winget
    $wingetPackage = Get-ChildItem -Path "$ENV:LOCALAPPDATA\Microsoft\WinGet\Packages" -Filter "wget.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($wingetPackage) { return $wingetPackage.FullName }

    return $null
}

$WgetPath = Get-WgetBinaryPath

if (-not $WgetPath) {
    Write-Host "-> Chưa tìm thấy wget.exe. Đang tiến hành cài đặt qua Winget..." -ForegroundColor Yellow
    winget install --id JernejSimoncic.Wget --silent --accept-source-agreements --accept-package-agreements

    # Cập nhật lại PATH cho phiên làm việc hiện tại
    $ENV:PATH = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    # Dò lại đường dẫn sau khi cài
    $WgetPath = Get-WgetBinaryPath
}

if (-not $WgetPath) {
    Write-Error "Không thể tìm thấy hoặc cài đặt wget.exe. Vui lòng kiểm tra lại Winget!"
    exit 1
}

Write-Host "-> Đã xác định thực thi Wget tại: $WgetPath" -ForegroundColor Green

# ------------------------------------------------------------------------------

# 3. Chuẩn bị thư mục đầu ra
Write-Host "[2/3] Kiểm tra thư mục lưu trữ..." -ForegroundColor Cyan
if (-not (Test-Path -Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# ------------------------------------------------------------------------------

# 4. Tiến hành Clone Static Website
Write-Host "[3/3] Bắt đầu tải website từ: $TargetURL" -ForegroundColor Cyan

# Danh sách các flag wget tối ưu cho clone static site:
# --mirror (-m) : Bật chế độ mirror (tương đương -r -N -l inf --no-remove-listing)
# --convert-links (-k) : Chuyển đổi liên kết để xem offline mượt mà
# --page-requisites (-p) : Tải toàn bộ tài nguyên đi kèm (CSS, JS, Images, Fonts...)
# --adjust-extension (-E) : Tự động thêm đuôi .html cho file cgi/asp/php hoặc file thiếu extension
# --no-parent (-np) : Không leo ngược lên thư mục cha ngoài URL chỉ định
# --user-agent : Giả lập trình duyệt để tránh bị chặn 403
# -P : Thư mục lưu kết quả

$wgetArgs = @(
    "--mirror",
    "--convert-links",
    "--page-requisites",
    "--adjust-extension",
    "--no-parent",
    "--user-agent=$UserAgent",
    "-P", $OutputDir,
    $TargetURL
)

# Thích ứng chạy lệnh bằng & để bypass Alias "wget" của PowerShell
& $WgetPath $wgetArgs

Write-Host "`nHoàn thành! Website đã được lưu tại: $OutputDir" -ForegroundColor Green
