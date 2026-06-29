$dir = "$PSScriptRoot\images"
$client = [System.Net.WebClient]::new()
$client.Headers.Add("User-Agent","Mozilla/5.0")

function Get-Img($url, $file) {
  $path = "$dir\$file"
  if (Test-Path $path) { Write-Host "Exists: $file"; return }
  try { $client.DownloadFile($url, $path); Write-Host "OK: $file" }
  catch { Write-Host "FAIL: $file" }
}

$b = "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is"
$q = "?wid=940&hei=1112&fmt=png-alpha&.v=1"
$qm = "?wid=904&hei=840&fmt=png-alpha&.v=1"

Get-Img "$b/iphone-17-pro-finish-select-202509-6-3inch-blacktitanium$q" "apple-iphone17pro-1.png"
Get-Img "$b/iphone-17-pro-finish-select-202509-6-3inch-naturaltitanium$q" "apple-iphone17pro-2.png"
Get-Img "$b/iphone-17-pro-max-finish-select-202509-6-9inch-blacktitanium$q" "apple-iphone17promax-1.png"
Get-Img "$b/iphone-17-pro-max-finish-select-202509-6-9inch-naturaltitanium$q" "apple-iphone17promax-2.png"
Get-Img "$b/iphone-17-pro-max-finish-select-202509-6-9inch-whitetitanium$q" "apple-iphone17promax-3.png"
Get-Img "$b/iphone-17-finish-select-202509-6-1inch-black$q" "apple-iphone17-1.png"
Get-Img "$b/iphone-17-finish-select-202509-6-1inch-white$q" "apple-iphone17-2.png"
Get-Img "$b/iphone-17-finish-select-202509-6-1inch-ultramarine$q" "apple-iphone17-3.png"
Get-Img "$b/iphone-air-finish-select-202509-6-6inch-skyblue$q" "apple-iphoneair-1.png"
Get-Img "$b/iphone-air-finish-select-202509-6-6inch-starlight$q" "apple-iphoneair-2.png"
Get-Img "$b/iphone-16-pro-max-finish-select-202409-6-9inch-blacktitanium$q" "apple-iphone16promax-1.png"
Get-Img "$b/iphone-16-pro-max-finish-select-202409-6-9inch-naturaltitanium$q" "apple-iphone16promax-2.png"
Get-Img "$b/iphone-16-pro-max-finish-select-202409-6-9inch-desertitanium$q" "apple-iphone16promax-3.png"
Get-Img "$b/iphone-16-pro-finish-select-202409-6-3inch-blacktitanium$q" "apple-iphone16pro-1.png"
Get-Img "$b/iphone-16-pro-finish-select-202409-6-3inch-naturaltitanium$q" "apple-iphone16pro-2.png"
Get-Img "$b/iphone-16-finish-select-202409-6-1inch-black$q" "apple-iphone16-1.png"
Get-Img "$b/iphone-16-finish-select-202409-6-1inch-ultramarine$q" "apple-iphone16-2.png"
Get-Img "$b/iphone-16-finish-select-202409-6-1inch-pink$q" "apple-iphone16-3.png"
Get-Img "$b/mbp16-m4max-spaceb-select-202411$qm" "apple-mbp16-1.png"
Get-Img "$b/mbp16-m4max-silver-select-202411$qm" "apple-mbp16-2.png"
Get-Img "$b/mbp14-m4pro-spaceb-select-202411$qm" "apple-mbp14-1.png"
Get-Img "$b/mbp14-m4pro-silver-select-202411$qm" "apple-mbp14-2.png"
Get-Img "$b/ipad-pro-13-m4-select-wifi-spaceb-202405?wid=820&hei=1032&fmt=png-alpha&.v=1" "ipad-pro-m4.png"
Get-Img "$b/airpods-4-select-202409?wid=572&hei=572&fmt=png-alpha&.v=1" "apple-airpods4-1.png"
Get-Img "$b/mba13-m3-midnight-select-202402$qm" "MacBook_Air_M3_laptop_white_202606281411.jpeg"
Get-Img "$b/mba13-m3-starlight-select-202402$qm" "MacBook_Air_M3_laptop_white_202606281412.jpeg"
Get-Img "$b/mba15-m3-midnight-select-202402$qm" "MacBook_Air_15-inch_M3_laptop_202606281424.jpeg"

$sb = "https://images.samsung.com/is/image/samsung/p6pim/uk"
Get-Img "$sb/2501/gallery/uk-galaxy-s25-ultra-s928-sm-s928bztheub-thumb-545694005?w=940&h=1112&fmt=png-alpha" "samsung-s25ultra-1.jpg"
Get-Img "$sb/2501/gallery/uk-galaxy-s25-s921-sm-s921bzkbeub-thumb-545694003?w=940&h=1112&fmt=png-alpha" "samsung-s25-1.jpg"
Get-Img "$sb/2407/gallery/uk-galaxy-z-fold6-f956-sm-f956bzkbeub-thumb-542385700?w=940&h=1112&fmt=png-alpha" "samsung-zfold6-1.jpg"

Write-Host "Done."
$client.Dispose()
