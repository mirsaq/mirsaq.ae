import sharp from 'sharp';
import { readdirSync, statSync, readFileSync, writeFileSync } from 'fs';

const dir = 'C:/Users/MUHAMMAD/OneDrive/Desktop/MIRSAQ/website/images';
const files = readdirSync(dir).filter(f => /\.(jpe?g|png)$/i.test(f));

let before = 0, after = 0, done = 0, errors = 0;

for (const f of files) {
  const p = `${dir}/${f}`;
  let inputBuf;
  try { inputBuf = readFileSync(p); } catch(e) { console.log('read-err:', f); errors++; continue; }
  const sizeBefore = inputBuf.length;
  before += sizeBefore;
  try {
    const buf = await sharp(inputBuf)
      .resize({ width: 1200, withoutEnlargement: true })
      .jpeg({ quality: 78, mozjpeg: true })
      .toBuffer();
    if (buf.length < sizeBefore) {
      writeFileSync(p, buf);
      after += buf.length;
      done++;
    } else {
      after += sizeBefore;
    }
  } catch (e) {
    after += sizeBefore;
    errors++;
    console.log('compress-err:', f, e.message.slice(0,60));
  }
}

console.log(`\nDone: ${done}/${files.length} compressed, ${errors} errors`);
console.log(`Before: ${(before/1024/1024).toFixed(1)}MB`);
console.log(`After:  ${(after/1024/1024).toFixed(1)}MB`);
console.log(`Saved:  ${((before-after)/1024/1024).toFixed(1)}MB (${Math.round((before-after)/before*100)}%)`);
