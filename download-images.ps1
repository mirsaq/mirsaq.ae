# MIRSAQ Image Downloader
# Downloads all product + hero images from external CDNs and updates index.html to use local paths

$root    = $PSScriptRoot
$html    = Get-Content "$root\index.html" -Raw -Encoding UTF8
$imgDir  = Join-Path $root "images"
New-Item -ItemType Directory -Force -Path $imgDir | Out-Null

# ── Derive a safe local filename from a URL ──────────────────────────────────
function Get-LocalName($url) {
    # Strip query string for the ID
    $bare = ($url -split '\?')[0]
    # Last path segment
    $seg  = $bare.Split('/')[-1]
    # Determine extension
    if ($url -match 'fmt=png') { $ext = '.png' }
    elseif ($bare -match '\.(png|jpg|jpeg|webp)$') { $ext = ".$($Matches[1])" }
    else { $ext = '.jpg' }
    # Clean the segment (remove URL-encoded chars)
    $name = $seg -replace '[^a-zA-Z0-9_\-]', '-'
    return "$name$ext"
}

# ── Find every external image URL in the HTML ────────────────────────────────
$pattern = 'https://[^\s"''<>]+(?:wid=\d|hei=\d|\$[^$]+\$|\.(?:jpg|jpeg|png|webp))(?:[^\s"''<>]*)'
$matches  = [regex]::Matches($html, $pattern) | Select-Object -ExpandProperty Value | Sort-Object -Unique

Write-Host "Found $($matches.Count) unique image URLs" -ForegroundColor Cyan

$mapping  = @{}
$success  = 0
$fail     = 0

$headers = @{
    'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120'
    'Accept'     = 'image/avif,image/webp,image/apng,image/*,*/*;q=0.8'
    'Referer'    = 'https://mirsaq.com/'
}

foreach ($url in $matches) {
    $localName = Get-LocalName $url
    $localPath = Join-Path $imgDir $localName
    $relPath   = "images/$localName"

    if (Test-Path $localPath) {
        Write-Host "  SKIP (exists)  $localName" -ForegroundColor DarkGray
        $mapping[$url] = $relPath
        $success++
        continue
    }

    try {
        Invoke-WebRequest -Uri $url -OutFile $localPath -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        $size = [math]::Round((Get-Item $localPath).Length / 1KB, 1)
        Write-Host "  OK  [$size KB]  $localName" -ForegroundColor Green
        $mapping[$url] = $relPath
        $success++
    } catch {
        Write-Host "  FAIL           $localName  ($($_.Exception.Message.Split([char]10)[0]))" -ForegroundColor Red
        # Remove empty file if created
        if ((Test-Path $localPath) -and (Get-Item $localPath).Length -eq 0) { Remove-Item $localPath }
        $fail++
    }
}

Write-Host "`nDownloaded: $success  Failed: $fail" -ForegroundColor Cyan

# ── Rewrite HTML: replace every URL with its local path ─────────────────────
$updatedHtml = $html
foreach ($url in ($mapping.Keys | Sort-Object { $_.Length } -Descending)) {
    # Replace both quoted and unquoted occurrences
    $updatedHtml = $updatedHtml.Replace($url, $mapping[$url])
}

# Write updated HTML
Set-Content -Path "$root\index.html" -Value $updatedHtml -Encoding UTF8
Write-Host "`nindex.html updated with local image paths." -ForegroundColor Green
Write-Host "Run the site at http://localhost:3000 to verify." -ForegroundColor Yellow
