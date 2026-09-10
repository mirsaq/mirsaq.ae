# Social Ad Captions

Pair each image with its caption below. Post as a normal feed image on Instagram + Facebook (cross-post natively to both, don't just share the IG link into FB). Tone is consumer-facing: product intros and comparisons, not a wholesale/B2B pitch — no "wholesale," "bulk," or "container load" anywhere.

---

## Product Intros (Premium Style)

### day1-samsung-galaxy-s26-ultra.png
**Caption:**
Meet the new Samsung Galaxy S26 Ultra — now at MIRSAQ.
Questions? Message us on WhatsApp: +971 55 296 9386

**Hashtags:** #SamsungGalaxy #GalaxyS26Ultra #TechNews #SmartphoneLaunch

---

### day2-iphone-17-pro-max.png
**Caption:**
Introducing the iPhone 17 Pro Max — Apple's most advanced iPhone yet, now at MIRSAQ.
WhatsApp: +971 55 296 9386

**Hashtags:** #iPhone17ProMax #Apple #TechNews #NewLaunch

---

### day3-apple-watch-ultra-2.png
**Caption:**
Built for every adventure — the Apple Watch Ultra 2. Titanium strength meets everyday performance.
WhatsApp: +971 55 296 9386

**Hashtags:** #AppleWatchUltra #AppleWatch #WearableTech #TechTalk

---

### day4-garmin-fenix-8.png
**Caption:**
The Garmin Fenix 8 — Garmin's toughest flagship adventure watch, built for the outdoors.
WhatsApp: +971 55 296 9386

**Hashtags:** #GarminFenix8 #Garmin #AdventureWatch #OutdoorTech

---

### day5-dyson-supersonic.png
**Caption:**
Engineered for the perfect dry — the Dyson Supersonic HD15, Dyson's fastest, smartest hair dryer yet.
WhatsApp: +971 55 296 9386

**Hashtags:** #DysonSupersonic #Dyson #HairTech #TechTalk

---

### day6-playstation-5-slim.png
**Caption:**
Next-gen gaming, reimagined — the PlayStation 5 Slim. Faster load times, stunning visuals.
WhatsApp: +971 55 296 9386

**Hashtags:** #PS5 #PlayStation5 #GamingLife #NextGenGaming

---

### day7-xbox-series-x.png
**Caption:**
Power meets performance — the Xbox Series X. Explore every console at MIRSAQ.
WhatsApp: +971 55 296 9386

**Hashtags:** #XboxSeriesX #Xbox #GamingLife #TechTalk

---

## Product Intros (3D Creative Style)

### 3d-macbook.png
**Caption:**
Designed to do more — the MacBook. Power, portability, and Apple precision in one.
WhatsApp: +971 55 296 9386

**Hashtags:** #MacBook #Apple #TechTalk #LaptopLife

---

### 3d-airpods-max.png
**Caption:**
Sound, reimagined — AirPods Max. Immersive audio meets iconic design.
WhatsApp: +971 55 296 9386

**Hashtags:** #AirPodsMax #Apple #AudioGear #TechTalk

---

### 3d-ipad.png
**Caption:**
Work. Create. Explore. The all-new iPad is ready for anything.
WhatsApp: +971 55 296 9386

**Hashtags:** #iPad #Apple #TechTalk #CreativeTech

---

### 3d-dyson-cordless.png
**Caption:**
Cordless. Powerful. Smart. Dyson engineering, reimagined for everyday use.
WhatsApp: +971 55 296 9386

**Hashtags:** #Dyson #CordlessVacuum #HomeTech #TechTalk

---

### 3d-ps5-console.png
**Caption:**
Next-gen gaming starts here. Meet the PlayStation 5.
WhatsApp: +971 55 296 9386

**Hashtags:** #PS5 #PlayStation #GamingLife #NextGenGaming

---

### 3d-dualsense-controller.png
**Caption:**
Feel every moment — the DualSense controller's haptic feedback and adaptive triggers change how you play.
WhatsApp: +971 55 296 9386

**Hashtags:** #DualSense #PlayStation #GamingGear #TechTalk

---

### 3d-nintendo-switch.png
**Caption:**
Play your way, anywhere. Handheld or docked — gaming without limits.
WhatsApp: +971 55 296 9386

**Hashtags:** #NintendoSwitch #Nintendo #GamingLife #TechTalk

---

## Comparisons (VS Style)

### vs-samsung-apple.png
**Caption:**
Samsung vs Apple — which one fits you? Android flexibility or iOS simplicity, we've got both at MIRSAQ.
WhatsApp: +971 55 296 9386

**Hashtags:** #SamsungVsApple #TechCompare #Android #iOS

---

### vs-playstation-xbox.png
**Caption:**
PlayStation vs Xbox — which one fits you? Exclusive titles or the Game Pass library, the choice is yours.
WhatsApp: +971 55 296 9386

**Hashtags:** #PS5VsXbox #GamingLife #PlayStationVsXbox #TechCompare

---

## Posting notes
- Post 1 per day, or rotate to match your calendar.
- Best times to post for this audience (Middle East / general tech audience): 9–11am and 6–8pm Gulf Standard Time.
- Purpose: introduce and compare products for a general audience — not a wholesale/B2B pitch. Keep captions informative and neutral in tone; let the product speak for itself.

## Design notes
- **Style:** premium/minimal, Apple & Garmin inspired — near-black gradient background with a single brand-tinted glow, product cut cleanly out of its studio photo (no visible white box), large bold headline, thin CTA line. No emojis, matches the site's dark, understated tone.
- **3D Creative wave:** same brand system, built from glossy pre-rendered 3D product assets instead of flat studio photos — more dynamic/angled, good for varying the feed.
- **VS Comparison style:** bold diagonal color-split background, two-tone headline, feature captions under each product, pill CTA — for side-by-side product comparisons.
- **Brand color per category:** Apple = blue glow, Samsung = purple/violet, Garmin = cyan/blue, Dyson = magenta, Gaming = blue/green split for VS.
- **Size:** 1080×1350 (4:5) — correct for Instagram/Facebook feed posts.

## How to make more
Everything is generated by code in this folder — no design tool needed:
- `lib.js` — background removal (flood-fill cutout from studio photos, with a guarded second pass that clears soft shadow gradients without eating into light-colored products) + fitting helpers.
- `build-ads-v2.js` — product-intro template (`ADS` for studio photos, `ADS_3D` for pre-rendered 3D assets). Add a new entry (kicker, headline, sub, `imgFile` from `images/`, `theme`) and run:

```bash
node build-ads-v2.js
```

- `build-ads-v3.js` — the VS comparison template (`VS_ADS`). Add a new entry (two labels/colors/images, a question, two feature captions) and run:

```bash
node build-ads-v3.js
```

Existing themes: `apple`, `samsung`, `garmin`, `dyson`, `gaming`. Add a new one to the `THEMES` object in `build-ads-v2.js` for a different brand/color.

For a 3D-render creative instead of a flat studio photo, add `render3d: true` and point `imgFile` at one of the pre-rendered transparent assets in `images/` (filenames starting `3D_render_of_...`) — these skip the background-cutout step entirely since they're already transparent.

**Copy rule:** no "wholesale," "bulk," or B2B-pitch language in social captions — this channel is for introducing and comparing products to a general audience, not the export/wholesale pitch the website makes.
