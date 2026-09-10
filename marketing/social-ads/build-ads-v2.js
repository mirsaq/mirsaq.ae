const fs = require('fs');
const path = require('path');
const sharp = require('sharp');
const { fitProduct, fitTransparent } = require('./lib');

const IMAGES_DIR = path.join(__dirname, '..', '..', 'images');
const LOGO_PATH = path.join(__dirname, '..', '..', 'logo-p-transparent.png');
const OUT_DIR = __dirname;
const W = 1080, H = 1350;
const WA = '+971 55 296 9386';
const TAGLINE = 'EXPECT EXCELLENCE EVERY TIME'; // logo-tag-transparent.png misspells this "Exellence" — render it correctly here instead of using that raster
const ICON_SIZE = 58;
const BRAND_X = 70 + ICON_SIZE + 16;

let logoPromise;
function logoIcon() {
  if (!logoPromise) {
    logoPromise = sharp(LOGO_PATH).trim().resize({ height: ICON_SIZE }).png().toBuffer();
  }
  return logoPromise;
}

function esc(s) {
  return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

// Brand-matched dark gradient themes — Apple/Garmin style: near-black base, single accent glow.
const THEMES = {
  apple: { top: '#0b0b0d', bottom: '#000000', glow: '#4d6bff', glowOpacity: 0.30, accent: '#e8ecff' },
  samsung: { top: '#0c0620', bottom: '#000000', glow: '#7c4dff', glowOpacity: 0.34, accent: '#c9b8ff' },
  garmin: { top: '#04141c', bottom: '#000000', glow: '#00a3e0', glowOpacity: 0.32, accent: '#a9e6ff' },
  dyson: { top: '#160616', bottom: '#000000', glow: '#e0339c', glowOpacity: 0.28, accent: '#ffb8e6' },
  gaming: { top: '#050a1c', bottom: '#000000', glow: '#3a6bff', glowOpacity: 0.34, accent: '#aecbff' },
};

async function backgroundPng(theme) {
  const svg = `
    <svg width="${W}" height="${H}" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="bg" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stop-color="${theme.top}"/>
          <stop offset="100%" stop-color="${theme.bottom}"/>
        </linearGradient>
        <radialGradient id="glow" cx="50%" cy="42%" r="46%">
          <stop offset="0%" stop-color="${theme.glow}" stop-opacity="${theme.glowOpacity}"/>
          <stop offset="100%" stop-color="${theme.glow}" stop-opacity="0"/>
        </radialGradient>
      </defs>
      <rect width="${W}" height="${H}" fill="url(#bg)"/>
      <rect width="${W}" height="${H}" fill="url(#glow)"/>
    </svg>`;
  return sharp(Buffer.from(svg)).png().toBuffer();
}

function overlaySvg({ kicker, headline, sub, theme, cta = true }) {
  const headlineY = 920;
  const lineH = 70;
  const headLines = headline.map((l, i) =>
    `<tspan x="${W/2}" y="${headlineY + i*lineH}">${esc(l)}</tspan>`).join('');
  const subY = headlineY + headline.length*lineH + 44;
  const subLines = sub.map((l, i) =>
    `<tspan x="${W/2}" y="${subY + i*32}">${esc(l)}</tspan>`).join('');

  const ctaY = 1230;
  const ctaSvg = cta ? `
    <circle cx="${W/2-152}" cy="${ctaY}" r="5" fill="#25d366"/>
    <text x="${W/2-134}" y="${ctaY+7}" font-family="Segoe UI, Arial, sans-serif" font-size="24" font-weight="600" fill="#f2f4f8">WhatsApp ${esc(WA)}</text>
  ` : '';

  return `
  <svg width="${W}" height="${H}" xmlns="http://www.w3.org/2000/svg">
    <text x="${BRAND_X}" y="76" font-family="Segoe UI, Arial, sans-serif" font-size="26" font-weight="800" letter-spacing="1" fill="#ffffff">MIRSAQ</text>
    <text x="${BRAND_X}" y="98" font-family="Segoe UI, Arial, sans-serif" font-size="11" font-weight="600" letter-spacing="3" fill="#6b7280">GENERAL TRADING</text>
    <text x="${W-70}" y="86" text-anchor="end" font-family="Segoe UI, Arial, sans-serif" font-size="12" font-weight="700" letter-spacing="3" fill="${theme.accent}">${esc(kicker)}</text>

    <text text-anchor="middle" font-family="Segoe UI, Arial, sans-serif" font-size="64" font-weight="800" letter-spacing="-1" fill="#ffffff">
      ${headLines}
    </text>
    <text text-anchor="middle" font-family="Segoe UI, Arial, sans-serif" font-size="24" font-weight="400" fill="#9aa0ac">
      ${subLines}
    </text>
    ${ctaSvg}
    <text x="${W/2}" y="${ctaY+58}" text-anchor="middle" font-family="Segoe UI, Arial, sans-serif" font-size="13" font-weight="600" letter-spacing="4" fill="#565d6b">${esc(TAGLINE)}</text>
  </svg>`;
}

async function buildAd({ name, kicker, headline, sub, imgFile, theme, maxWidth = 760, maxHeight = 610, productTop = 175, cta = true, render3d = false }) {
  const th = THEMES[theme];
  const [bg, overlay, logo] = await Promise.all([
    backgroundPng(th),
    sharp(Buffer.from(overlaySvg({ kicker, headline, sub, theme: th, cta }))).png().toBuffer(),
    logoIcon(),
  ]);

  const logoMeta = await sharp(logo).metadata();
  const composites = [
    { input: logo, left: 70, top: 82 - Math.round(logoMeta.height / 2) },
    { input: overlay, left: 0, top: 0 },
  ];

  if (imgFile) {
    const fit = render3d ? fitTransparent : fitProduct;
    const product = await fit(path.join(IMAGES_DIR, imgFile), { maxWidth, maxHeight });
    const top = productTop + Math.round((maxHeight - product.height) / 2);
    composites.unshift({ input: product.buffer, left: Math.round((W - product.width) / 2), top });
  }

  const pngPath = path.join(OUT_DIR, `${name}.png`);
  await sharp(bg).composite(composites).png().toFile(pngPath);
  console.log('built', pngPath);
}

module.exports = { buildAd, THEMES };

const ADS = [
  {
    name: 'day1-samsung-galaxy-s26-ultra',
    kicker: 'SAMSUNG · GALAXY S26 ULTRA',
    headline: ['MEET THE NEW', 'GALAXY S26 ULTRA.'],
    sub: ['Samsung’s latest flagship', 'has arrived at MIRSAQ.'],
    imgFile: 'Samsung_Galaxy_S26_Ultra_smartphone_202606291805.jpeg',
    theme: 'samsung',
  },
  {
    name: 'day2-iphone-17-pro-max',
    kicker: 'APPLE · IPHONE 17 PRO MAX',
    headline: ['INTRODUCING', 'IPHONE 17 PRO MAX.'],
    sub: ['Apple’s most advanced iPhone', 'yet, now at MIRSAQ.'],
    imgFile: 'iPhone_17_Pro_Max_isolated_202606291918.jpeg',
    theme: 'apple',
  },
  {
    name: 'day3-apple-watch-ultra-2',
    kicker: 'APPLE · WATCH ULTRA 2',
    headline: ['BUILT FOR', 'EVERY ADVENTURE.'],
    sub: ['Titanium strength meets', 'everyday performance.'],
    imgFile: 'Apple_Watch_Ultra_2_white_202606291818.jpeg',
    theme: 'apple',
  },
  {
    name: 'day4-garmin-fenix-8',
    kicker: 'GARMIN · FENIX 8',
    headline: ['THE FLAGSHIP', 'ADVENTURE WATCH.'],
    sub: ['Garmin’s toughest watch yet,', 'built for the outdoors.'],
    imgFile: 'Garmin_Fenix_8_Sapphire_watch_202606291920.jpeg',
    theme: 'garmin',
  },
  {
    name: 'day5-dyson-supersonic',
    kicker: 'DYSON · SUPERSONIC HD15',
    headline: ['ENGINEERED FOR', 'THE PERFECT DRY.'],
    sub: ['Dyson’s fastest, smartest', 'hair dryer yet.'],
    imgFile: 'Dyson_Supersonic_HD15_white_back…_202606291920.jpeg',
    theme: 'dyson',
  },
  {
    name: 'day6-playstation-5-slim',
    kicker: 'PLAYSTATION 5 SLIM',
    headline: ['NEXT-GEN GAMING,', 'REIMAGINED.'],
    sub: ['Faster load times,', 'stunning visuals.'],
    imgFile: 'PlayStation_5_Slim_(Digital)_on_202606291916.jpeg',
    theme: 'gaming',
  },
  {
    name: 'day7-xbox-series-x',
    kicker: 'XBOX SERIES X',
    headline: ['POWER MEETS', 'PERFORMANCE.'],
    sub: ['Xbox, PlayStation & Nintendo —', 'explore every console at MIRSAQ.'],
    imgFile: 'Xbox_Series_X_console_white_202606291817.jpeg',
    theme: 'gaming',
  },
];

// Second wave — pre-rendered 3D product creatives (already transparent, no
// cutout needed). More dynamic/angled than the flat studio photos.
const ADS_3D = [
  {
    name: '3d-macbook',
    kicker: 'APPLE · MACBOOK',
    headline: ['DESIGNED TO', 'DO MORE.'],
    sub: ['Power, portability,', 'and Apple precision.'],
    imgFile: '3D_render_of_a_MacBook_202606281810-transparent.png',
    theme: 'apple', render3d: true,
    maxWidth: 780, maxHeight: 560,
  },
  {
    name: '3d-airpods-max',
    kicker: 'APPLE · AIRPODS MAX',
    headline: ['SOUND,', 'REIMAGINED.'],
    sub: ['Immersive audio,', 'iconic design.'],
    imgFile: '3D_render_of_AirPods_Max,_202606281808 (1)-transparent.png',
    theme: 'apple', render3d: true,
    maxWidth: 520, maxHeight: 620,
  },
  {
    name: '3d-ipad',
    kicker: 'APPLE · IPAD',
    headline: ['WORK. CREATE.', 'EXPLORE.'],
    sub: ['The all-new iPad,', 'ready for anything.'],
    imgFile: '3D_render_of_an_iPad_202606281809 (1)-transparent.png',
    theme: 'apple', render3d: true,
    maxWidth: 720, maxHeight: 560,
  },
  {
    name: '3d-dyson-cordless',
    kicker: 'DYSON · CORDLESS VACUUM',
    headline: ['CORDLESS.', 'POWERFUL. SMART.'],
    sub: ['Dyson engineering,', 'reimagined for everyday use.'],
    imgFile: '3D_render_of_a_Dyson_202606281808 (2)-transparent.png',
    theme: 'dyson', render3d: true,
    maxWidth: 640, maxHeight: 640,
  },
  {
    name: '3d-ps5-console',
    kicker: 'PLAYSTATION 5',
    headline: ['NEXT-GEN GAMING', 'STARTS HERE.'],
    sub: ['Meet the PlayStation 5.'],
    imgFile: '3D_render_of_a_PlayStation_202606281809 (1)-transparent.png',
    theme: 'gaming', render3d: true,
    maxWidth: 520, maxHeight: 620,
  },
  {
    name: '3d-dualsense-controller',
    kicker: 'PS5 · DUALSENSE',
    headline: ['FEEL EVERY', 'MOMENT.'],
    sub: ['Haptic feedback.', 'Adaptive triggers.'],
    imgFile: '3D_render_of_a_PS5_202606281808-transparent.png',
    theme: 'gaming', render3d: true,
    maxWidth: 680, maxHeight: 560,
  },
  {
    name: '3d-nintendo-switch',
    kicker: 'NINTENDO SWITCH',
    headline: ['PLAY YOUR WAY.', 'ANYWHERE.'],
    sub: ['Handheld or docked —', 'gaming without limits.'],
    imgFile: '3D_render_of_a_Nintendo_202606281808-transparent.png',
    theme: 'gaming', render3d: true,
    maxWidth: 780, maxHeight: 560,
  },
];

if (require.main === module) {
  (async () => {
    for (const ad of ADS) await buildAd(ad);
    for (const ad of ADS_3D) await buildAd(ad);
  })().catch(e => { console.error(e); process.exit(1); });
}
