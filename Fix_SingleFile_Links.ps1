<#
.SYNOPSIS
    2 buoc gop lai, chay tu dong cho MOI thu muc truyen trong 1 thu muc goc (KhoTruyen):
    1) Doi ten file theo dung so trang (doc tu dong "url:" SingleFile tu ghi san) thanh
       Trang_1.html, Trang_2.html...
    2) Sua link cheo giua cac trang, cho tro dung vao ten file moi.

.NOTES
    Cau truc ky vong:
    KhoTruyen
    |- Truyen_A
    |    |- (file SingleFile luu, ten cu the nao cung duoc)
    |- Truyen_B
    |    |- ...

    Co the doi thu muc goc qua bien moi truong KHOTRUYEN_PATH truoc khi chay, vi du:
    $env:KHOTRUYEN_PATH = "D:\MyStories"
#>

$RootPath = if ($env:KHOTRUYEN_PATH) { $env:KHOTRUYEN_PATH } else { "$ENV:USERPROFILE\Desktop\KhoTruyen" }

# ------------------------------------------------------------------------------
# BUOC A: doi ten file theo so trang, doc tu dong "url:" SingleFile ghi san

function Rename-ToPageOrder {
    param([string]$FolderPath)

    $htmlFiles = Get-ChildItem -Path $FolderPath -Filter "*.html"
    if ($htmlFiles.Count -eq 0) { return }

    $PageMap = @{}
    foreach ($f in $htmlFiles) {
        $content = Get-Content -Path $f.FullName -Raw
        if ($content -notmatch 'url:\s*(\S+)') {
            Write-Host "   $($f.Name): khong tim thay dong url:, bo qua file nay." -ForegroundColor DarkYellow
            continue
        }
        $sourceUrl = $Matches[1].TrimEnd('/')
        $pageNum = if ($sourceUrl -match '/(\d+)$') { [int]$Matches[1] } else { 1 }

        if ($PageMap.ContainsKey($pageNum)) {
            Write-Error "TRUNG SO TRANG $pageNum giua '$($PageMap[$pageNum].Name)' va '$($f.Name)' trong $FolderPath. Dung lai -- kiem tra 2 file nay truoc khi chay lai."
            exit 1
        }
        $PageMap[$pageNum] = $f
    }

    if ($PageMap.Count -eq 0) { return }

    # Doi qua ten tam thoi (GUID) truoc, tranh dung do khi doi ten cheo nhau
    $tempNames = @{}
    foreach ($pageNum in $PageMap.Keys) {
        $f = $PageMap[$pageNum]
        $tempName = "__tmp_$([guid]::NewGuid().ToString('N')).html"
        Rename-Item -Path $f.FullName -NewName $tempName -ErrorAction Stop
        $tempNames[$pageNum] = $tempName
    }

    foreach ($pageNum in ($tempNames.Keys | Sort-Object)) {
        $tempPath = Join-Path $FolderPath $tempNames[$pageNum]
        $finalName = "Trang_$pageNum.html"
        Rename-Item -Path $tempPath -NewName $finalName -ErrorAction Stop
        Write-Host "   Trang $pageNum -> $finalName" -ForegroundColor Gray
    }
}

# ------------------------------------------------------------------------------
# BUOC B: sua link cheo giua cac trang, cho tro dung vao ten file (doc lai tu dong url:)

function Fix-LinksInFolder {
    param([string]$FolderPath)

    $htmlFiles = Get-ChildItem -Path $FolderPath -Filter "*.html"
    if ($htmlFiles.Count -eq 0) { return 0 }

    $UrlToFile = @{}
    foreach ($f in $htmlFiles) {
        $content = Get-Content -Path $f.FullName -Raw
        if ($content -match 'url:\s*(\S+)') {
            $sourceUrl = $Matches[1].TrimEnd('/')
            $UrlToFile[$sourceUrl] = $f.Name
        }
    }

    $totalFixed = 0
    foreach ($f in $htmlFiles) {
        $content = Get-Content -Path $f.FullName -Raw
        $fixedInFile = 0

        foreach ($url in ($UrlToFile.Keys | Sort-Object -Property Length -Descending)) {
            $targetFile = $UrlToFile[$url]
            if ($targetFile -eq $f.Name) { continue }

            $escapedUrl = [regex]::Escape($url)
            $pattern = "href=[`"']?$escapedUrl/?[`"']?"
            $count = ([regex]::Matches($content, $pattern)).Count
            if ($count -gt 0) {
                $content = [regex]::Replace($content, $pattern, { "href=`"$targetFile`"" })
                $fixedInFile += $count
            }
        }

        if ($fixedInFile -gt 0) {
            Set-Content -Path $f.FullName -Value $content -NoNewline
            $totalFixed += $fixedInFile
        }
    }

    Write-Host "   -> $($htmlFiles.Count) file, sua $totalFixed link." -ForegroundColor Gray
    return $totalFixed
}

# ------------------------------------------------------------------------------

if (-not (Test-Path $RootPath)) {
    Write-Error "Khong tim thay thu muc $RootPath"
    exit 1
}

$storyFolders = Get-ChildItem -Path $RootPath -Directory
if ($storyFolders.Count -eq 0) {
    Write-Error "Khong co thu muc truyen nao ben trong $RootPath"
    exit 1
}

Write-Host "Tim thay $($storyFolders.Count) thu muc truyen trong $RootPath" -ForegroundColor Cyan

$grandTotal = 0
foreach ($folder in $storyFolders) {
    Write-Host "`n[$($folder.Name)]" -ForegroundColor Cyan
    Write-Host "  Doi ten theo so trang:" -ForegroundColor Cyan
    Rename-ToPageOrder -FolderPath $folder.FullName
    Write-Host "  Sua link cheo:" -ForegroundColor Cyan
    $grandTotal += (Fix-LinksInFolder -FolderPath $folder.FullName)
}

Write-Host "`nHoan thanh! Da xu ly $($storyFolders.Count) truyen, tong cong sua $grandTotal link." -ForegroundColor Green
