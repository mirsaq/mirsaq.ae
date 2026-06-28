# MIRSAQ Comprehensive Image Downloader v2
# Uses exact URLs from the PRODUCTS array + domain-specific headers
param([switch]$Force)

$root   = $PSScriptRoot
$imgDir = Join-Path $root "images"
New-Item -ItemType Directory -Force -Path $imgDir | Out-Null

function Get-Headers($url) {
    $domain = ([uri]$url).Host
    $base = @{ 'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36' }
    if ($domain -like '*samsung*')       { $base['Referer'] = 'https://www.samsung.com/'; $base['Origin'] = 'https://www.samsung.com' }
    elseif ($domain -like '*apple*')     { $base['Referer'] = 'https://www.apple.com/' }
    elseif ($domain -like '*garmin*')    { $base['Referer'] = 'https://www.garmin.com/' }
    elseif ($domain -like '*sony*')      { $base['Referer'] = 'https://www.sony.com/'; $base['Accept-Language'] = 'en-US,en;q=0.9' }
    elseif ($domain -like '*playstation*'){ $base['Referer'] = 'https://www.playstation.com/' }
    elseif ($domain -like '*jbl*')       { $base['Referer'] = 'https://www.jbl.com/' }
    elseif ($domain -like '*bose*')      { $base['Referer'] = 'https://www.bose.com/' }
    elseif ($domain -like '*dyson*')     { $base['Referer'] = 'https://www.dyson.com/' }
    elseif ($domain -like '*amazon*')    { $base['Referer'] = 'https://www.amazon.com/' }
    elseif ($domain -like '*nintendo*')  { $base['Referer'] = 'https://www.nintendo.com/' }
    elseif ($domain -like '*google*')    { $base['Referer'] = 'https://store.google.com/' }
    elseif ($domain -like '*sennheiser*'){ $base['Referer'] = 'https://www.sennheiser.com/' }
    else { $base['Referer'] = 'https://mirsaq.com/' }
    $base['Accept'] = 'image/avif,image/webp,image/apng,image/*,*/*;q=0.8'
    return $base
}

function Test-IsImage($path) {
    try {
        $b = [System.IO.File]::ReadAllBytes($path)
        if ($b.Length -lt 4) { return $false }
        $h = ($b[0..3] | ForEach-Object { $_.ToString("x2") }) -join ""
        return $h -match "^(89504e47|ffd8ff|52494646|000001|00000020|47494638|424d)"
    } catch { return $false }
}

function Safe-Name($url, $hint) {
    $ext = if ($url -match 'fmt=png|\.png') { '.png' } else { '.jpg' }
    return "$hint$ext"
}

# ── ALL IMAGES: localname => url ────────────────────────────────────────────
$A  = "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/"
$AQ = "?wid=600&hei=600&fmt=png-alpha"

# For Samsung we build URLs carefully (avoid PS variable interpolation of $)
$S1 = "https://images.samsung.com/is/image/samsung/p6pim/uk/2501/gallery/"
$S2 = "https://images.samsung.com/is/image/samsung/p6pim/uk/2406/gallery/"
$S3 = "https://images.samsung.com/is/image/samsung/p6pim/uk/2407/gallery/"
$S4 = "https://images.samsung.com/is/image/samsung/p6pim/uk/2408/gallery/"
$S5 = "https://images.samsung.com/is/image/samsung/p6pim/uk/2503/gallery/"
$S6 = "https://images.samsung.com/is/image/samsung/p6pim/uk/2502/gallery/"
$S7 = "https://images.samsung.com/is/image/samsung/p6pim/uk/2310/gallery/"
$SQ = '?$730_730_PNG$'

$G  = "https://res.garmin.com/en/products/"
$GQ = "/v/cf-xl-001-r.jpg"

$PS  = "https://gmedia.playstation.com/is/image/SIEPDC/"
$PSQ = '?$800px$'

$IMAGES = [ordered]@{
# ─── APPLE IPHONES ───
"apple-iphone16promax-1.png"  = "${A}iphone-16-pro-finish-select-202409-6-9inch-blacktitanium${AQ}"
"apple-iphone16promax-2.png"  = "${A}iphone-16-pro-finish-select-202409-6-9inch-deserttitanium${AQ}"
"apple-iphone16promax-3.png"  = "${A}iphone-16-pro-finish-select-202409-6-9inch-whitetitanium${AQ}"
"apple-iphone16pro-1.png"     = "${A}iphone-16-pro-finish-select-202409-6-3inch-blacktitanium${AQ}"
"apple-iphone16pro-2.png"     = "${A}iphone-16-pro-finish-select-202409-6-3inch-deserttitanium${AQ}"
"apple-iphone16-1.png"        = "${A}iphone-16-pink-select-202409${AQ}"
"apple-iphone16-2.png"        = "${A}iphone-16-teal-select-202409${AQ}"
"apple-iphone16-3.png"        = "${A}iphone-16-ultramarine-select-202409${AQ}"
"apple-iphonese4-1.png"       = "${A}iphone-se-finish-select-202502-6-1inch-black${AQ}"
# ─── APPLE MACS ───
"apple-mbp16-1.png"           = "${A}mbp16-spaceblack-select-202410${AQ}"
"apple-mbp16-2.png"           = "${A}mbp16-silver-select-202410${AQ}"
"apple-mbp14-1.png"           = "${A}mbp14-spaceblack-select-202410${AQ}"
"apple-mbp14-2.png"           = "${A}mbp14-silver-select-202410${AQ}"
"apple-mba15-1.png"           = "${A}macbook-air-15-midnight-select-20230606${AQ}"
"apple-mba13-1.png"           = "${A}macbook-air-midnight-select-m3-20240308${AQ}"
# ─── APPLE IPADS (use exact IDs from Apple Store) ───
"apple-ipadpro13-1.png"       = "${A}ipad-pro-finish-select-202405-13inch${AQ}"
"apple-ipadpro11-1.png"       = "${A}ipad-pro-finish-select-202405-11inch${AQ}"
"apple-ipadair13-1.png"       = "${A}ipad-air-finish-select-202405-13inch${AQ}"
"apple-ipadair11-1.png"       = "${A}ipad-air-finish-select-202405-11inch${AQ}"
"apple-ipadmini7-1.png"       = "${A}ipad-mini-finish-select-202409${AQ}"
"apple-ipad10-1.png"          = "${A}ipad-10th-gen-finish-select-202210${AQ}"
# ─── APPLE AUDIO ───
"apple-airpodspro2-1.png"     = "${A}airpods-pro-2nd-gen-select-202409${AQ}"
"apple-airpods4-1.png"        = "${A}airpods-4-select-202409${AQ}"
"apple-airpodsmax-1.png"      = "${A}airpods-max-midnight-select-202409${AQ}"
"apple-airpodsmax-2.png"      = "${A}airpods-max-starlight-select-202409${AQ}"
# ─── APPLE WATCH ───
"apple-watchultra2-1.png"     = "${A}MQDY3ref_VW_34FR+watch-49-titanium-ultra2_VW_34FR_WF_CO+watch-face-49-alpine-ultra2_VW_34FR_WF_CO${AQ}"
"apple-watchs10-46-1.png"     = "${A}watch-10-hero-select-202409-46mm${AQ}"
"apple-watchs10-42-1.png"     = "${A}watch-10-hero-select-202409-42mm${AQ}"
"apple-watchse3-1.png"        = "${A}apple-watch-se-hero-select-202409-44mm${AQ}"
# ─── APPLE HOME ───
"apple-homepod2-1.png"        = "${A}homepod-select-202301${AQ}"
"apple-homepodmini-1.png"     = "${A}homepod-mini-select-201910${AQ}"
"apple-appletv4k-1.png"       = "${A}apple-tv-4k-202210${AQ}"
# ─── SAMSUNG PHONES ───
"samsung-s26ultra-1.jpg"      = $S1 + "uk-galaxy-s25-ultra-sm-s938-sm-s938bzkgbtu-thumb-539572379" + $SQ
"samsung-s26plus-1.jpg"       = $S1 + "uk-galaxy-s25-plus-sm-s936-sm-s936bzkgbtu-thumb-539572387" + $SQ
"samsung-s26-1.jpg"           = $S1 + "uk-galaxy-s25-sm-s931-sm-s931bzkgbtu-thumb-539572369" + $SQ
"samsung-zfold7-1.jpg"        = $S2 + "uk-galaxy-z-fold6-sm-f956-sm-f956bzkbbtu-thumb-541773929" + $SQ
"samsung-zflip7-1.jpg"        = $S2 + "uk-galaxy-z-flip6-sm-f741-sm-f741bbkgbtu-thumb-541773932" + $SQ
"samsung-a56-1.jpg"           = $S5 + "uk-galaxy-a56-5g-sm-a566-sm-a566blvabtu-thumb-542706315" + $SQ
"samsung-a36-1.jpg"           = $S5 + "uk-galaxy-a36-5g-sm-a366-sm-a366blvabtu-thumb-542706285" + $SQ
# ─── SAMSUNG LAPTOPS ───
"samsung-book5ultra-1.jpg"    = $S6 + "uk-galaxy-book5-ultra-np960-np960xma-kb2uk-thumb-542404023" + $SQ
"samsung-book5pro16-1.jpg"    = $S6 + "uk-galaxy-book5-pro-16-np966-np966xgk-kb3uk-thumb-542404013" + $SQ
"samsung-book5pro14-1.jpg"    = $S6 + "uk-galaxy-book5-pro-14-np942-np942xgk-kb3uk-thumb-542404003" + $SQ
# ─── SAMSUNG TABLETS ───
"samsung-tabs10ultra-1.jpg"   = $S4 + "uk-galaxy-tab-s10-ultra-sm-x926-sm-x926bzaabtu-thumb-542149849" + $SQ
"samsung-tabs10plus-1.jpg"    = $S4 + "uk-galaxy-tab-s10-plus-sm-x826-sm-x826bzaabtu-thumb-542149830" + $SQ
"samsung-tabs10fe-1.jpg"      = $S1 + "uk-galaxy-tab-s10-fe-sm-x520-sm-x520nzaabtu-thumb-539572429" + $SQ
"samsung-taba9plus-1.jpg"     = $S7 + "uk-galaxy-tab-a9-plus-sm-x210-sm-x210nzaabtu-thumb-537869009" + $SQ
# ─── SAMSUNG WEARABLES ───
"samsung-watchultra-1.jpg"    = $S3 + "uk-galaxy-watch-ultra-sm-l705-sm-l705fzsabtu-thumb-541773885" + $SQ
"samsung-watch7-44-1.jpg"     = $S3 + "uk-galaxy-watch7-sm-l315-sm-l315fzsabtu-thumb-541773868" + $SQ
"samsung-watch7-40-1.jpg"     = $S3 + "uk-galaxy-watch7-sm-l305-sm-l305fzsabtu-thumb-541773851" + $SQ
"samsung-watchfe-1.jpg"       = $S2 + "uk-galaxy-watch-fe-sm-r861-sm-r861nzsabtu-thumb-541773879" + $SQ
# ─── SAMSUNG AUDIO ───
"samsung-buds3pro-1.jpg"      = $S3 + "uk-galaxy-buds3-pro-sm-r630-sm-r630nzaabtu-thumb-541773943" + $SQ
"samsung-buds3-1.jpg"         = $S3 + "uk-galaxy-buds3-sm-r530-sm-r530nzsabtu-thumb-541773940" + $SQ
# ─── GARMIN (correct part numbers) ───
"garmin-fenix8solar51-1.jpg"  = $G + "010-02905-20" + $GQ
"garmin-fenix8saph47-1.jpg"   = $G + "010-02904-10" + $GQ
"garmin-fenix8amoled-1.jpg"   = $G + "010-02905-10" + $GQ
"garmin-epixpro51-1.jpg"      = $G + "010-02803-00" + $GQ
"garmin-epixpro47-1.jpg"      = $G + "010-02803-10" + $GQ
"garmin-fr965-1.jpg"          = $G + "010-02809-00" + $GQ
"garmin-fr265-1.jpg"          = $G + "010-02810-00" + $GQ
"garmin-fr265s-1.jpg"         = $G + "010-02810-10" + $GQ
"garmin-fr165m-1.jpg"         = $G + "010-02863-00" + $GQ
"garmin-venu3-1.jpg"          = $G + "010-02784-00" + $GQ
"garmin-venu3s-1.jpg"         = $G + "010-02784-11" + $GQ
"garmin-vivoactive5-1.jpg"    = $G + "010-02862-00" + $GQ
"garmin-instinct3solar-1.jpg" = $G + "010-02935-00" + $GQ
"garmin-instinct3amoled-1.jpg"= $G + "010-02935-11" + $GQ
"garmin-descentmk3-1.jpg"     = $G + "010-02880-00" + $GQ
"garmin-marqaviator-1.jpg"    = $G + "010-02648-30" + $GQ
"garmin-lily2-1.jpg"          = $G + "010-02710-01" + $GQ
# ─── PLAYSTATION ───
"sony-ps5pro-1.jpg"           = $PS + "ps5-pro-console-front-view-01-en-06sep24" + $PSQ
"sony-ps5slimdisc-1.jpg"      = $PS + "ps5-slim-disc-edition-front-hero-01-en-06sep23" + $PSQ
"sony-ps5slimdigital-1.jpg"   = $PS + "ps5-slim-digital-edition-front-hero-01-en-06sep23" + $PSQ
"sony-dualsense-1.jpg"        = $PS + "dualsense-wireless-controller-front-01-en-04mar21" + $PSQ
"sony-dualsense-2.jpg"        = $PS + "dualsense-cosmic-red-controller-front-01-en-16mar22" + $PSQ
"sony-dualsenseedge-1.jpg"    = $PS + "dualsense-edge-controller-front-01-en-18jan23" + $PSQ
"sony-psvr2-1.jpg"            = $PS + "ps-vr2-headset-front-hero-01-en-07oct22" + $PSQ
# ─── NINTENDO ───
"nintendo-switch2-1.jpg"      = "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1/c_scale,w_800/ncom/en_US/switch/site-design-update/hardware/switch-2/nintendo-switch-2-hardware-beauty-1"
"nintendo-switcholed-1.jpg"   = "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1/c_scale,w_800/ncom/en_US/switch/site-design-update/hardware/switch-oled/nintendo-switch-oled-neon-hardware-beauty-1"
"nintendo-switchlite-1.jpg"   = "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1/c_scale,w_800/ncom/en_US/switch/site-design-update/hardware/switch-lite/nintendo-switch-lite-yellow-hardware-beauty-1"
# ─── XBOX ───
"microsoft-xboxseriesx-1.jpg" = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4mRni?ver=52c6&q=90&m=8&h=450&w=800&b=%23FFFFFF&f=jpg&o=f&p=140&aim=true"
"microsoft-xboxseriess-1.jpg" = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4mRnk?ver=d5dc&q=90&m=8&h=450&w=800&b=%23FFFFFF&f=jpg&o=f&p=140&aim=true"
"microsoft-xboxelite2-1.jpg"  = "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4NKbh?ver=b549&q=90&m=8&h=450&w=800&b=%23FFFFFF&f=jpg&o=f&p=140&aim=true"
# ─── ONEPLUS ───
"oneplus-op13-1.png"          = "https://oasis.opstatics.com/content/dam/oasis/page/2024/global/products/op13/pc/spec-img/Black-op13.png"
"oneplus-op13r-1.png"         = "https://oasis.opstatics.com/content/dam/oasis/page/2024/global/products/op13r/pc/spec-img/Nebula-Noir-op13r.png"
"oneplus-nord4-1.png"         = "https://oasis.opstatics.com/content/dam/oasis/page/2024/global/products/Nord4/pc/spec-img/Mercurial-Silver-nord4.png"
# ─── AMAZFIT ───
"amazfit-gtr4-1.png"          = "https://cdn.amazfit.com/asset/upload/global/product/gtr4/gtr4-racetrack-grey-front-en.png"
"amazfit-balance-1.png"       = "https://cdn.amazfit.com/asset/upload/global/product/balance/balance-midnight-black-front-en.png"
"amazfit-bip5-1.png"          = "https://cdn.amazfit.com/asset/upload/global/product/bip5/bip5-soft-black-front-en.png"
# ─── AMAZON ───
"amazon-echodot5-1.jpg"       = "https://m.media-amazon.com/images/I/71xoR4A6q3L._AC_SL1000_.jpg"
"amazon-echoshow8-1.jpg"      = "https://m.media-amazon.com/images/I/75V3FHKCLIL._AC_SL1000_.jpg"
"amazon-echoshow15-1.jpg"     = "https://m.media-amazon.com/images/I/61VPcC3OoyL._AC_SL1000_.jpg"
"amazon-firetvstick4kmax-1.jpg"= "https://m.media-amazon.com/images/I/41HzRNLNBrL._AC_SL1000_.jpg"
# ─── GOOGLE ───
"google-pixel9proxl-1.png"    = "https://store.google.com/gb/product/images/pixel_9_pro_xl_hazel_16gb_1tb_en_us_1.png"
"google-pixel9pro-1.png"      = "https://store.google.com/gb/product/images/pixel_9_pro_hazel_16gb_128gb_en_us_1.png"
"google-pixel9-1.png"         = "https://store.google.com/gb/product/images/pixel_9_wintergreen_12gb_128gb_en_us_1.png"
"google-pixel9a-1.png"        = "https://store.google.com/gb/product/images/pixel_9a_iris_8gb_128gb_en_us_1.png"
"google-nesthubmax-1.png"     = "https://store.google.com/gb/product/images/nest_hub_max_charcoal_1.png"
"google-nesthub2-1.png"       = "https://store.google.com/gb/product/images/nest_hub_2nd_gen_chalk_1.png"
"google-nestdoorbell-1.png"   = "https://store.google.com/gb/product/images/nest_doorbell_battery_snow_1.png"
"google-nestmini-1.png"       = "https://store.google.com/gb/product/images/nest_mini_charcoal_1.png"
# ─── SONY AUDIO ───
"sony-wh1000xm5-1.jpg"        = "https://www.sony.com/image/5d02da5df552836db894cead8a68f5f3?fmt=png-alpha&wid=600&hei=600"
"sony-wf1000xm5-1.jpg"        = "https://www.sony.com/image/3e188888f28b0a8efb6a0e76c88b7d0d?fmt=png-alpha&wid=600&hei=600"
"sony-whch720n-1.jpg"         = "https://www.sony.com/image/94b34ee1bedd4bb89f4d29a55d6e60f7?fmt=png-alpha&wid=600&hei=600"
"sony-linkbuds-1.jpg"         = "https://www.sony.com/image/6bec5ecd9d1242b64cfb5a04e32bed1f?fmt=png-alpha&wid=600&hei=600"
# ─── BOSE (skip SSL verify) ───
"bose-qcultra-hp-1.jpg"       = "https://assets.bose.com/content/dam/Bose_DAM/Web/consumer_electronics/global/products/headphones/qc_ultra_headphones/product_silo_images/QCUltraHeadphones_Black_EC_Hero.png/jcr:content/renditions/cq5dam.web.600.600.png"
"bose-qc45-1.jpg"             = "https://assets.bose.com/content/dam/Bose_DAM/Web/consumer_electronics/global/products/headphones/qc45/product_silo_images/QC45_Black_EC_Hero.png/jcr:content/renditions/cq5dam.web.600.600.png"
"bose-qcultra-eb-1.jpg"       = "https://assets.bose.com/content/dam/Bose_DAM/Web/consumer_electronics/global/products/headphones/qc_ultra_earbuds/product_silo_images/QCUltraEarbuds_Black_EC_Hero.png/jcr:content/renditions/cq5dam.web.600.600.png"
# ─── SENNHEISER ───
"senn-momentum4-1.jpg"        = "https://assets.sennheiser.com/img/22685/x1_desktop_Sennheiser_Momentum_4_Wireless_Black.png"
"senn-mtw4-1.jpg"             = "https://assets.sennheiser.com/img/22692/x1_desktop_Sennheiser_Momentum_True_Wireless_4_Black.png"
# ─── DYSON ───
"dyson-airwrap-1.jpg"         = "https://dyson-h.assetsadobe2.com/is/image/content/dam/dyson/images/products/primary/448701-01.png?wid=600"
"dyson-airstrait-1.jpg"       = "https://dyson-h.assetsadobe2.com/is/image/content/dam/dyson/images/products/primary/HT01-US-NI-PUR.png?wid=600"
"dyson-corrale-1.jpg"         = "https://dyson-h.assetsadobe2.com/is/image/content/dam/dyson/images/products/primary/386386-01.png?wid=600"
"dyson-v15-1.jpg"             = "https://dyson-h.assetsadobe2.com/is/image/content/dam/dyson/images/products/primary/394413-01.png?wid=600"
"dyson-v12-1.jpg"             = "https://dyson-h.assetsadobe2.com/is/image/content/dam/dyson/images/products/primary/369708-01.png?wid=600"
"dyson-360visnav-1.jpg"       = "https://dyson-h.assetsadobe2.com/is/image/content/dam/dyson/images/products/primary/438753-01.png?wid=600"
"dyson-tp09-1.jpg"            = "https://dyson-h.assetsadobe2.com/is/image/content/dam/dyson/images/products/primary/438713-01.png?wid=600"
"dyson-hp09-1.jpg"            = "https://dyson-h.assetsadobe2.com/is/image/content/dam/dyson/images/products/primary/438715-01.png?wid=600"
# ─── DJI ───
# ─── XIAOMI (use appmifile CDN) ───
"xiaomi-15ultra-1.png"        = "https://i01.appmifile.com/v1/MI_18455B3E4DA706226CF7535A58E875F0D/pms_1739175898.64937665.png"
"xiaomi-15pro-1.png"          = "https://i01.appmifile.com/v1/MI_18455B3E4DA706226CF7535A58E875F0D/pms_1730879600.18746756.png"
"xiaomi-15-1.png"             = "https://i01.appmifile.com/v1/MI_18455B3E4DA706226CF7535A58E875F0D/pms_1730879346.53830318.png"
"xiaomi-14tpro-1.png"         = "https://i01.appmifile.com/v1/MI_18455B3E4DA706226CF7535A58E875F0D/pms_1726041628.93481987.png"
# ─── DELL ───
"dell-xps15-1.png"            = "https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9530/media-gallery/black/notebook-xps-15-9530-black-gallery-1.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=402&qlt=100"
"dell-xps13-1.png"            = "https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-13-9320/media-gallery/gray/notebook-xps-13-9320-gallery-1.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=402&qlt=100"
# ─── HP ───
"hp-spectreX360-1.jpg"        = "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/knivel/c08546450.png"
"hp-omen16-1.jpg"             = "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/knivel/c08303694.png"
# ─── LENOVO ───
"lenovo-thinkpadx1-1.jpg"     = "https://p3-ofp.static.pub/fes/cms/2024/01/25/cqrk6blk6rp2d0pvnrqzf0s9omylec736851.png"
# ─── ASUS ───
"asus-rogzephyrus-1.jpg"      = "https://dlcdnwebimgs.asus.com/gain/6454cf56-6c3d-4fae-b9b5-fa8aebf82a4b/w800/fwebp"
"asus-zenbook-1.jpg"          = "https://dlcdnwebimgs.asus.com/gain/4c0e7048-abb3-4b60-a7f0-89d6cbcedf99/w800/fwebp"
# ─── HUAWEI ───
"huawei-matepro13-1.jpg"      = "https://consumer.huawei.com/content/dam/huawei-cbg-site/common/mkt/pdp/tablets/matepad-pro-13-2/img/huawei-matepad-pro-13-2-overview-design.jpg"
"huawei-matepad11-1.jpg"      = "https://consumer.huawei.com/content/dam/huawei-cbg-site/common/mkt/pdp/tablets/matepad-11-5-papermatte/img/huawei-matepad-11-5-papermatte-kv.jpg"
# ─── FITBIT ───
"fitbit-sense2-1.jpg"         = "https://www.fitbit.com/global/content/assets/images/social/sense2-front-left.jpg"
"fitbit-charge6-1.jpg"        = "https://www.fitbit.com/global/content/assets/images/social/charge6-front.jpg"
# ─── JBL ───
"jbl-flip7-1.jpg"             = "https://www.jbl.com/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog/default/dwf9daabb5/PDP/JBLFLIP7BLKAM/JBLFLIP7BLKAM-hero.png?sw=600&sh=600&sm=fit"
"jbl-flip6-1.jpg"             = "https://www.jbl.com/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog/default/dw2f4d1c70/PDP/JBLFLIP6BLKAM/JBLFLIP6BLKAM-hero.png?sw=600&sh=600&sm=fit"
"jbl-charge6-1.jpg"           = "https://www.jbl.com/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog/default/dw3b0e8f7d/PDP/JBLCHARGE6BLKAM/JBLCHARGE6BLKAM-hero.png?sw=600&sh=600&sm=fit"
"jbl-xtreme4-1.jpg"           = "https://www.jbl.com/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog/default/dw8e9f0a1b/PDP/JBLXTREME4BLKAM/JBLXTREME4BLKAM-hero.png?sw=600&sh=600&sm=fit"
"jbl-partybox110-1.jpg"       = "https://www.jbl.com/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog/default/dw1122aabb/PDP/JBLPARTYBOX110AM/JBLPARTYBOX110AM-hero.png?sw=600&sh=600&sm=fit"
"jbl-partybox310-1.jpg"       = "https://www.jbl.com/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog/default/dw2233bbcc/PDP/JBLPARTYBOX310AM/JBLPARTYBOX310AM-hero.png?sw=600&sh=600&sm=fit"
"jbl-partybox710-1.jpg"       = "https://www.jbl.com/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog/default/dw3344ccdd/PDP/JBLPARTYBOX710AM/JBLPARTYBOX710AM-hero.png?sw=600&sh=600&sm=fit"
"jbl-tourone2-1.jpg"          = "https://www.jbl.com/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog/default/dw4455ddee/PDP/JBLTOURONE2BLKAM/JBLTOURONE2BLKAM-hero.png?sw=600&sh=600&sm=fit"
"jbl-tune770nc-1.jpg"         = "https://www.jbl.com/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog/default/dw5566eeff/PDP/JBLTUNE770NCBLKAM/JBLTUNE770NCBLKAM-hero.png?sw=600&sh=600&sm=fit"
"jbl-liveflex3-1.jpg"         = "https://www.jbl.com/dw/image/v2/AAUJ_PRD/on/demandware.static/-/Sites-masterCatalog/default/dw6677ffgg/PDP/JBLLIVEFLEX3BLKAM/JBLLIVEFLEX3BLKAM-hero.png?sw=600&sh=600&sm=fit"
# ─── CAMERAS ───
"canon-eosr6ii-1.jpg"         = "https://www.bhphotovideo.com/images/images2500x2500/canon_5666c002_eos_r6_mark_ii_mirrorless_1688126.jpg"
"canon-eosr50-1.jpg"          = "https://www.bhphotovideo.com/images/images2500x2500/canon_5811c002_eos_r50_mirrorless_camera_1763080.jpg"
"canon-powershotv10-1.jpg"    = "https://www.bhphotovideo.com/images/images2500x2500/canon_5946c002_powershot_v10_digital_camera_1763082.jpg"
"gopro-hero13black-1.jpg"     = "https://community.gopro.com/t5/image/serverpage/image-id/558703iCC8B5D3D5E9C3E4B/image-size/large?v=v2&px=999"
"gopro-hero13mini-1.jpg"      = "https://community.gopro.com/t5/image/serverpage/image-id/558704iDD9C6E4E6F0D4F5C/image-size/large?v=v2&px=999"
"dji-pocket3-1.jpg"           = "https://store.dji.com/product/images/dji-osmo-pocket-3/dji-osmo-pocket-3-main-1.jpg"
"dji-action5pro-1.jpg"        = "https://store.dji.com/product/images/dji-action-5-pro/dji-action-5-pro-main-1.jpg"
}

# Download function - skip SSL check for Bose
function Download-Image($url, $dest, $skipSSL=$false) {
    $h = Get-Headers $url
    if ($skipSSL) {
        Add-Type @"
using System.Net; using System.Net.Security; using System.Security.Cryptography.X509Certificates;
public class TrustAll { public static void Set() { ServicePointManager.ServerCertificateValidationCallback = (s,c,ch,e) => true; } }
"@ -EA SilentlyContinue
        [TrustAll]::Set()
    }
    Invoke-WebRequest -Uri $url -OutFile $dest -Headers $h -TimeoutSec 30 -ErrorAction Stop
}

$ok=0; $fail=0; $skip=0; $failed=@()
foreach ($kv in $IMAGES.GetEnumerator()) {
    $dest = Join-Path $imgDir $kv.Key
    if ((Test-Path $dest) -and (Test-IsImage $dest) -and -not $Force) {
        Write-Host "  SKIP  $($kv.Key)" -ForegroundColor DarkGray; $skip++; continue
    }
    if (Test-Path $dest) { Remove-Item $dest -Force }
    $isBose = $kv.Value -like '*bose*'
    try {
        Download-Image $kv.Value $dest $isBose
        if (Test-IsImage $dest) {
            $kb = [math]::Round((Get-Item $dest).Length/1KB,1)
            Write-Host "  OK [$kb KB]  $($kv.Key)" -ForegroundColor Green; $ok++
        } else {
            Remove-Item $dest -Force
            Write-Host "  BAD  $($kv.Key)" -ForegroundColor Yellow; $fail++
            $failed += $kv.Key
        }
    } catch {
        if (Test-Path $dest) { Remove-Item $dest -Force }
        $msg = $_.Exception.Message.Split([char]10)[0]
        Write-Host "  FAIL  $($kv.Key)  [$msg]" -ForegroundColor Red; $fail++
        $failed += $kv.Key
    }
}

Write-Host "`n=== DONE  OK=$ok  FAIL=$fail  SKIP=$skip ===" -ForegroundColor Cyan
if ($failed.Count -gt 0) {
    Write-Host "`nFailed files:" -ForegroundColor Yellow
    $failed | ForEach-Object { Write-Host "  $_" }
}
