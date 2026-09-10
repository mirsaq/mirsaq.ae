const sharp = require('sharp');

// Keep only the largest connected "foreground" blob; convert every other
// speck (unreached vignette corners, detached shadow smudges) to background.
function keepLargestComponent(isBg, width, height) {
  const n = width * height;
  const label = new Int32Array(n).fill(-1);
  const stack = new Int32Array(n);
  let bestLabel = -1, bestSize = 0, current = 0;

  for (let start = 0; start < n; start++) {
    if (isBg[start] || label[start] !== -1) continue;
    let sp = 0;
    stack[sp++] = start;
    label[start] = current;
    let size = 0;
    while (sp > 0) {
      const idx = stack[--sp];
      size++;
      const x = idx % width, y = (idx / width) | 0;
      if (x + 1 < width) { const ni = idx + 1; if (!isBg[ni] && label[ni] === -1) { label[ni] = current; stack[sp++] = ni; } }
      if (x - 1 >= 0) { const ni = idx - 1; if (!isBg[ni] && label[ni] === -1) { label[ni] = current; stack[sp++] = ni; } }
      if (y + 1 < height) { const ni = idx + width; if (!isBg[ni] && label[ni] === -1) { label[ni] = current; stack[sp++] = ni; } }
      if (y - 1 >= 0) { const ni = idx - width; if (!isBg[ni] && label[ni] === -1) { label[ni] = current; stack[sp++] = ni; } }
    }
    if (size > bestSize) { bestSize = size; bestLabel = current; }
    current++;
  }

  const cleaned = new Uint8Array(n);
  for (let i = 0; i < n; i++) cleaned[i] = label[i] === bestLabel ? 0 : 1;
  return cleaned;
}

// Remove a studio background from a product photo via border flood-fill
// (only removes background pixels connected to the frame edge, so light/white
// parts of the product itself are never touched), then feathers the alpha
// edge for a clean anti-aliased cutout.
async function cutoutProduct(imgPath, { tolerance = 26, feather = 2, trimThreshold = 8 } = {}) {
  const trimmed = sharp(imgPath).trim({ threshold: trimThreshold }).ensureAlpha();
  const { data, info } = await trimmed.raw().toBuffer({ resolveWithObject: true });
  const { width, height, channels } = info;
  const n = width * height;

  // Reference background color: average a strip along each edge.
  let rSum = 0, gSum = 0, bSum = 0, cnt = 0;
  const sampleEdge = (x, y) => {
    const i = (y * width + x) * channels;
    rSum += data[i]; gSum += data[i + 1]; bSum += data[i + 2]; cnt++;
  };
  for (let x = 0; x < width; x += 4) { sampleEdge(x, 0); sampleEdge(x, height - 1); }
  for (let y = 0; y < height; y += 4) { sampleEdge(0, y); sampleEdge(width - 1, y); }
  const refR = rSum / cnt, refG = gSum / cnt, refB = bSum / cnt;
  const tol2 = tolerance * tolerance;

  const isBg = new Uint8Array(n); // 1 = background
  const visited = new Uint8Array(n);
  const stack = new Int32Array(n);
  let sp = 0;

  const tryPush = (x, y) => {
    if (x < 0 || x >= width || y < 0 || y >= height) return;
    const idx = y * width + x;
    if (visited[idx]) return;
    const i = idx * channels;
    const dr = data[i] - refR, dg = data[i + 1] - refG, db = data[i + 2] - refB;
    if (dr * dr + dg * dg + db * db <= tol2) {
      visited[idx] = 1;
      isBg[idx] = 1;
      stack[sp++] = idx;
    } else {
      visited[idx] = 1; // checked, not background — do not expand past it
    }
  };

  for (let x = 0; x < width; x++) { tryPush(x, 0); tryPush(x, height - 1); }
  for (let y = 0; y < height; y++) { tryPush(0, y); tryPush(width - 1, y); }

  while (sp > 0) {
    const idx = stack[--sp];
    const x = idx % width, y = (idx / width) | 0;
    tryPush(x + 1, y); tryPush(x - 1, y); tryPush(x, y + 1); tryPush(x, y - 1);
  }

  const cleanedIsBg = keepLargestComponent(isBg, width, height);
  for (let i = 0; i < n; i++) isBg[i] = cleanedIsBg[i];

  // Second pass: grow the background region into any softly-graded shadow
  // still attached to the product (e.g. a floor shadow/reflection under it).
  // Compares each candidate pixel to its immediate already-background
  // neighbor (not the fixed reference), so it tunnels through gradual
  // gradients but stops dead at the product's hard edge. Guarded: if this
  // ends up eating a big chunk of the product itself (e.g. a smoothly-lit
  // white/glossy product body), the result is discarded and the pre-growth
  // cutout is used instead.
  {
    const sizeBefore = isBg.reduce((s, v) => s + (v ? 0 : 1), 0);
    const grown = Uint8Array.from(isBg);
    const localTol2 = 16 * 16;
    const stack2 = new Int32Array(n);
    let sp2 = 0;
    for (let i = 0; i < n; i++) if (grown[i]) stack2[sp2++] = i;
    const tryGrow = (fromIdx, x, y) => {
      if (x < 0 || x >= width || y < 0 || y >= height) return;
      const idx = y * width + x;
      if (grown[idx]) return;
      const i = idx * channels, fi = fromIdx * channels;
      const dr = data[i] - data[fi], dg = data[i + 1] - data[fi + 1], db = data[i + 2] - data[fi + 2];
      if (dr * dr + dg * dg + db * db <= localTol2) {
        grown[idx] = 1;
        stack2[sp2++] = idx;
      }
    };
    while (sp2 > 0) {
      const idx = stack2[--sp2];
      const x = idx % width, y = (idx / width) | 0;
      tryGrow(idx, x + 1, y); tryGrow(idx, x - 1, y); tryGrow(idx, x, y + 1); tryGrow(idx, x, y - 1);
    }
    const cleanedGrown = keepLargestComponent(grown, width, height);
    const sizeAfter = cleanedGrown.reduce((s, v) => s + (v ? 0 : 1), 0);
    if (sizeAfter >= sizeBefore * 0.7) {
      for (let i = 0; i < n; i++) isBg[i] = cleanedGrown[i];
    }
  }

  for (let idx = 0; idx < n; idx++) {
    data[idx * channels + 3] = isBg[idx] ? 0 : 255;
  }

  const rgba = sharp(data, { raw: { width, height, channels } });
  if (feather > 0) {
    // Feather only the alpha channel so product edges stay crisp.
    const alphaOnly = Buffer.alloc(n);
    for (let idx = 0; idx < n; idx++) alphaOnly[idx] = isBg[idx] ? 0 : 255;
    const blurredAlpha = await sharp(alphaOnly, { raw: { width, height, channels: 1 } })
      .toColourspace('b-w')
      .blur(feather)
      .raw()
      .toBuffer();
    for (let idx = 0; idx < n; idx++) data[idx * channels + 3] = blurredAlpha[idx];
    return sharp(data, { raw: { width, height, channels } }).png().toBuffer();
  }
  return rgba.png().toBuffer();
}

// Fit a cutout product into a bounding box (no cropping, preserves aspect).
async function fitProduct(imgPath, { maxWidth = 760, maxHeight = 640 } = {}) {
  const cutout = await cutoutProduct(imgPath);
  const meta = await sharp(cutout).metadata();
  const scale = Math.min(maxWidth / meta.width, maxHeight / meta.height, 1);
  const w = Math.round(meta.width * scale), h = Math.round(meta.height * scale);
  const resized = await sharp(cutout).resize(w, h).png().toBuffer();
  return { buffer: resized, width: w, height: h };
}

// Fit an already-transparent image (e.g. a pre-rendered 3D product asset)
// into a bounding box — no background removal needed, just scale to fit.
// Never upscales past 1.15x native size so small source renders stay crisp.
async function fitTransparent(imgPath, { maxWidth = 760, maxHeight = 640 } = {}) {
  const meta = await sharp(imgPath).metadata();
  const scale = Math.min(maxWidth / meta.width, maxHeight / meta.height, 1.15);
  const w = Math.round(meta.width * scale), h = Math.round(meta.height * scale);
  const resized = await sharp(imgPath).resize(w, h).png().toBuffer();
  return { buffer: resized, width: w, height: h };
}

module.exports = { cutoutProduct, fitProduct, fitTransparent };
