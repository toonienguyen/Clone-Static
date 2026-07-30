<#
.SYNOPSIS
    3 buoc gop lai, chay tu dong cho MOI thu muc truyen trong 1 thu muc goc (KhoTruyen):
    1) Doi ten file theo dung so trang (doc tu dong "url:" SingleFile tu ghi san) thanh
       Trang_1.html, Trang_2.html...
    2) Sua link cheo giua cac trang, cho tro dung vao ten file moi.
    3) Xoa cac phan khong phai noi dung truyen trong tung file: header (logo), footer
       (ban quyen, huy hieu DMCA), breadcrumb (Home / Doc Truyen), nut chia se mang
       xa hoi, dieu huong bai truoc/bai sau, va widget cung chuyen muc. Ghi de truc
       tiep, KHONG luu ban goc.

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
        $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
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
        $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
        if ($content -match 'url:\s*(\S+)') {
            $sourceUrl = $Matches[1].TrimEnd('/')
            $UrlToFile[$sourceUrl] = $f.Name
        }
    }

    $totalFixed = 0
    foreach ($f in $htmlFiles) {
        $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
        $fixedInFile = 0

        foreach ($url in ($UrlToFile.Keys | Sort-Object -Property Length -Descending)) {
            $targetFile = $UrlToFile[$url]
            if ($targetFile -eq $f.Name) { continue }

            $escapedUrl = [regex]::Escape($url)
            # (?!/?\d) chan truong hop URL ngan (vd .../ten-bai.html) khop nham vao
            # giua mot URL dai hon con nguyen ban (vd .../ten-bai.html/2) khi trang do
            # khong duoc luu cuc bo trong thu muc nay.
            $pattern = "href=[`"']?$escapedUrl(?!/?\d)/?[`"']?"
            $count = ([regex]::Matches($content, $pattern)).Count
            if ($count -gt 0) {
                $content = [regex]::Replace($content, $pattern, { "href=`"$targetFile`"" })
                $fixedInFile += $count
            }
        }

        if ($fixedInFile -gt 0) {
            [System.IO.File]::WriteAllText($f.FullName, $content, (New-Object System.Text.UTF8Encoding($false)))
            $totalFixed += $fixedInFile
        }
    }

    Write-Host "   -> $($htmlFiles.Count) file, sua $totalFixed link." -ForegroundColor Gray
    return $totalFixed
}

# ------------------------------------------------------------------------------
# BUOC C: xoa cac phan khong phai noi dung truyen (header, footer, breadcrumb, nut
# chia se, dieu huong bai truoc/sau, widget cung chuyen muc). Dem cap the <div>/</div>
# de xu ly dung truong hop co div long ben trong, thay vi bat </div> gan nhat.
# GHI DE TRUC TIEP, KHONG luu ban goc -- chay xong la mat, khong hoi phuc duoc.

function Remove-DivByAttr {
    param([string]$Content, [string]$AttrName, [string]$AttrValue)

    $openPattern = "<div\b[^>]*?\b$AttrName\s*=\s*[`"']?$AttrValue\b[`"']?[^>]*>"
    $openMatch = [regex]::Match($Content, $openPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    if (-not $openMatch.Success) { return $Content }

    $startPos = $openMatch.Index
    $scanPos  = $openMatch.Index + $openMatch.Length
    $depth = 1
    $tagMatches = [regex]::Matches($Content.Substring($scanPos), '<div\b|</div\s*>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    $endPos = -1
    foreach ($m in $tagMatches) {
        if ($m.Value -match '^</div') { $depth-- } else { $depth++ }
        if ($depth -eq 0) {
            $endPos = $scanPos + $m.Index + $m.Length
            break
        }
    }

    if ($endPos -eq -1) {
        # Khong dem can bang duoc -- an toan la KHONG xoa, tranh xoa lan sang phan noi dung khac
        Write-Host "   Canh bao: khong xac dinh duoc the dong cua div $AttrName=$AttrValue, bo qua khong xoa." -ForegroundColor DarkYellow
        return $Content
    }

    return $Content.Substring(0, $startPos) + $Content.Substring($endPos)
}

function Remove-Cruft {
    param([string]$FolderPath)

    $htmlFiles = Get-ChildItem -Path $FolderPath -Filter "*.html"
    if ($htmlFiles.Count -eq 0) { return 0 }

    # id=header/footer; 4 khoi con lai dua theo class (xac nhan tu file mau: moi gia
    # tri chi xuat hien dung 1 lan, khong bi trung voi class khac trong cung file)
    $targets = @(
        @{ Attr = "id";    Value = "header" }          # logo dau trang
        @{ Attr = "id";    Value = "footer" }           # ban quyen + huy hieu DMCA
        @{ Attr = "class"; Value = "breadcrumb-nen" }   # Home / Doc Truyen
        @{ Attr = "class"; Value = "chiase" }           # nut chia se mang xa hoi
        @{ Attr = "class"; Value = "navigation" }       # bai truoc / bai sau
        @{ Attr = "class"; Value = "widget" }           # cung chuyen muc
    )

    $totalChanged = 0
    foreach ($f in $htmlFiles) {
        $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
        $original = $content

        foreach ($t in $targets) {
            $content = Remove-DivByAttr -Content $content -AttrName $t.Attr -AttrValue $t.Value
        }

        if ($content -ne $original) {
            [System.IO.File]::WriteAllText($f.FullName, $content, (New-Object System.Text.UTF8Encoding($false)))
            $totalChanged++
        }
    }

    Write-Host "   -> $totalChanged/$($htmlFiles.Count) file da don dep." -ForegroundColor Gray
    return $totalChanged
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
$grandHeaderFooter = 0
foreach ($folder in $storyFolders) {
    Write-Host "`n[$($folder.Name)]" -ForegroundColor Cyan
    Write-Host "  Doi ten theo so trang:" -ForegroundColor Cyan
    Rename-ToPageOrder -FolderPath $folder.FullName
    Write-Host "  Sua link cheo:" -ForegroundColor Cyan
    $grandTotal += (Fix-LinksInFolder -FolderPath $folder.FullName)
    Write-Host "  Xoa header/footer/breadcrumb/chia se/dieu huong/widget:" -ForegroundColor Cyan
    $grandHeaderFooter += (Remove-Cruft -FolderPath $folder.FullName)
}

Write-Host "`nHoan thanh! Da xu ly $($storyFolders.Count) truyen, tong cong sua $grandTotal link, don dep $grandHeaderFooter file." -ForegroundColor Green
