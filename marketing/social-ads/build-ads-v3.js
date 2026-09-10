const path = require('path');
const sharp = require('sharp');
const { fitProduct, fitTransparent } = require('./lib');

const IMAGES_DIR = path.join(__dirname, '..', '..', 'images');
const OUT_DIR = __dirname;
const W = 1080, H = 1350;
const WA = '+971 55 296 9386';
const TAGLINE = 'EXPECT EXCELLENCE EVERY TIME';
const LOGO_PATH = path.join(__dirname, '..', '..', 'logo-p-transparent.png');
const ICON_SIZE = 54;

function esc(s) {
  return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

let logoPromise;
function logoIcon() {
  if (!logoPromise) logoPromise = sharp(LOGO_PATH).trim().resize({ height: ICON_SIZE }).png().toBuffer();
  return logoPromise;
}

// Diagonal two-tone split background with soft radial flares for energy —
// a punchier promo look vs. the minimal single-glow premium template.
function splitBackgroundSvg({ colorA, colorB, seam = 50 }) {
  return `
  <svg width="${W}" height="${H}" xmlns="http://www.w3.org/2000/svg">
    <defs>
      <linearGradient id="a" x1="0" y1="0" x2="1" y2="1">
        <stop offset="0%" stop-color="${colorA.light}"/>
        <stop offset="100%" stop-color="${colorA.dark}"/>
      </linearGradient>
      <linearGradient id="b" x1="0" y1="0" x2="1" y2="1">
        <stop offset="0%" stop-color="${colorB.light}"/>
        <stop offset="100%" stop-color="${colorB.dark}"/>
      </linearGradient>
      <radialGradient id="flareA" cx="50%" cy="50%" r="60%">
        <stop offset="0%" stop-color="#ffffff" stop-opacity="0.22"/>
        <stop offset="100%" stop-color="#ffffff" stop-opacity="0"/>
      </radialGradient>
      <radialGradient id="flareB" cx="50%" cy="50%" r="60%">
        <stop offset="0%" stop-color="#ffffff" stop-opacity="0.22"/>
        <stop offset="100%" stop-color="#ffffff" stop-opacity="0"/>
      </radialGradient>
      <linearGradient id="seamBlur" x1="0" y1="0" x2="1" y2="0">
        <stop offset="0%" stop-color="#000" stop-opacity="0"/>
        <stop offset="50%" stop-color="#000" stop-opacity="0.28"/>
        <stop offset="100%" stop-color="#000" stop-opacity="0"/>
      </linearGradient>
    </defs>
    <rect width="${seam}%" height="${H}" fill="url(#a)"/>
    <rect x="${seam}%" width="${100 - seam}%" height="${H}" fill="url(#b)"/>
    <rect x="${seam - 6}%" width="12%" height="${H}" fill="url(#seamBlur)"/>
    <circle cx="${W * 0.25}" cy="${H * 0.32}" r="${W * 0.42}" fill="url(#flareA)"/>
    <circle cx="${W * 0.75}" cy="${H * 0.62}" r="${W * 0.42}" fill="url(#flareB)"/>
  </svg>`;
}

function vsOverlaySvg({ leftLabel, leftColor, rightLabel, rightColor, question, leftCaption, rightCaption }) {
  const headY = 210;
  const ctaY = 1205;
  const brandX = 70 + ICON_SIZE + 14;
  return `
  <svg width="${W}" height="${H}" xmlns="http://www.w3.org/2000/svg">
    <text x="${brandX}" y="76" font-family="Segoe UI, Arial, sans-serif" font-size="26" font-weight="800" letter-spacing="1" fill="#ffffff">MIRSAQ</text>
    <text x="${brandX}" y="98" font-family="Segoe UI, Arial, sans-serif" font-size="11" font-weight="600" letter-spacing="3" fill="rgba(255,255,255,0.65)">GENERAL TRADING</text>

    <text x="${W/2}" y="${headY}" text-anchor="middle" xml:space="preserve" font-family="Segoe UI, Arial, sans-serif" font-size="58" font-weight="800" letter-spacing="-1">
      <tspan fill="${leftColor}">${esc(leftLabel)}</tspan><tspan fill="#ffffff" font-size="42">&#160;VS&#160;</tspan><tspan fill="${rightColor}">${esc(rightLabel)}</tspan>
    </text>
    <text x="${W/2}" y="${headY + 46}" text-anchor="middle" font-family="Segoe UI, Arial, sans-serif" font-size="25" font-weight="400" fill="#eef0f5">${esc(question)}</text>

    <text x="${W * 0.27}" y="1080" text-anchor="middle" font-family="Segoe UI, Arial, sans-serif" font-size="21" font-weight="700" letter-spacing="1" fill="#ffffff">${esc(leftCaption)}</text>
    <text x="${W * 0.73}" y="1080" text-anchor="middle" font-family="Segoe UI, Arial, sans-serif" font-size="21" font-weight="700" letter-spacing="1" fill="#ffffff">${esc(rightCaption)}</text>

    <rect x="${W/2 - 260}" y="${ctaY}" width="520" height="78" rx="39" fill="#111318"/>
    <text x="${W/2}" y="${ctaY + 49}" text-anchor="middle" font-family="Segoe UI, Arial, sans-serif" font-size="26" font-weight="700" fill="#ffffff">WhatsApp <tspan fill="#25d366">${esc(WA)}</tspan></text>
    <text x="${W/2}" y="${ctaY + 112}" text-anchor="middle" font-family="Segoe UI, Arial, sans-serif" font-size="12" font-weight="600" letter-spacing="3" fill="rgba(255,255,255,0.45)">${esc(TAGLINE)}</text>
  </svg>`;
}

async function buildVsAd({ name, colorA, colorB, leftLabel, leftColor, rightLabel, rightColor, question,
  leftCaption, rightCaption, leftImg, rightImg, leftRender3d = false, rightRender3d = false }) {
  const [bg, overlay, logo] = await Promise.all([
    sharp(Buffer.from(splitBackgroundSvg({ colorA, colorB }))).png().toBuffer(),
    sharp(Buffer.from(vsOverlaySvg({ leftLabel, leftColor, rightLabel, rightColor, question, leftCaption, rightCaption }))).png().toBuffer(),
    logoIcon(),
  ]);
  const logoMeta = await sharp(logo).metadata();

  const fitLeft = leftRender3d ? fitTransparent : fitProduct;
  const fitRight = rightRender3d ? fitTransparent : fitProduct;
  let [left, right] = await Promise.all([
    fitLeft(path.join(IMAGES_DIR, leftImg), { maxWidth: 460, maxHeight: 620 }),
    fitRight(path.join(IMAGES_DIR, rightImg), { maxWidth: 460, maxHeight: 620 }),
  ]);

  // Normalize both products to the same visual height so a naturally
  // higher-res or wider-framed product photo doesn't dwarf the other.
  const resizeToHeight = async (p, h) => {
    if (p.height === h) return p;
    const w = Math.round(p.width * (h / p.height));
    const buf = await sharp(p.buffer).resize(w, h).png().toBuffer();
    return { buffer: buf, width: w, height: h };
  };
  const matchHeight = Math.max(left.height, right.height) > 560 ? 560 : Math.max(left.height, right.height);
  [left, right] = await Promise.all([resizeToHeight(left, matchHeight), resizeToHeight(right, matchHeight)]);

  const composites = [
    { input: left.buffer, left: Math.round(W * 0.27 - left.width / 2), top: Math.round(650 - left.height / 2) },
    { input: right.buffer, left: Math.round(W * 0.73 - right.width / 2), top: Math.round(650 - right.height / 2) },
    { input: logo, left: 70, top: 74 - Math.round(logoMeta.height / 2) },
    { input: overlay, left: 0, top: 0 },
  ];

  const pngPath = path.join(OUT_DIR, `${name}.png`);
  await sharp(bg).composite(composites).png().toFile(pngPath);
  console.log('built', pngPath);
}

const VS_ADS = [
  {
    name: 'vs-samsung-apple',
    colorA: { light: '#2d63ff', dark: '#0a1550' },
    colorB: { light: '#3a3a42', dark: '#000000' },
    leftLabel: 'SAMSUNG', leftColor: '#8fb2ff',
    rightLabel: 'APPLE', rightColor: '#e8e8ee',
    question: 'Which One Fits You?',
    leftCaption: 'ANDROID FLEXIBILITY',
    rightCaption: 'iOS SIMPLICITY',
    leftImg: 'Samsung_Galaxy_S26_Ultra_smartphone_202606291805.jpeg',
    rightImg: 'iPhone_17_Pro_Max_isolated_202606291918.jpeg',
  },
  {
    name: 'vs-playstation-xbox',
    colorA: { light: '#2d63ff', dark: '#050a24' },
    colorB: { light: '#3ba642', dark: '#06170a' },
    leftLabel: 'PLAYSTATION', leftColor: '#8fb2ff',
    rightLabel: 'XBOX', rightColor: '#8fe89a',
    question: 'Which One Fits You?',
    leftCaption: 'EXCLUSIVE PLAYSTATION TITLES',
    rightCaption: 'GAME PASS LIBRARY',
    leftImg: 'PlayStation_5_Slim_(Digital)_on_202606291916.jpeg',
    rightImg: 'Xbox_Series_X_console_white_202606291817.jpeg',
  },
];

module.exports = { buildVsAd, VS_ADS };

if (require.main === module) {
  (async () => {
    for (const ad of VS_ADS) await buildVsAd(ad);
  })().catch(e => { console.error(e); process.exit(1); });
}
