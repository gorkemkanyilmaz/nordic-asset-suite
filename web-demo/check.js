const fs = require('fs');
let c = fs.readFileSync('app.js', 'utf8');
let lines = c.split('\n');

// Find language block boundaries within I18N_DICTIONARY
const lb = {};
let cur = null, d = 0, st = false, bs = -1;
for (let i = 52; i < 3200; i++) {
  let m = lines[i].trim().match(/^(en|de|fr|it|da|sv|no|tr): \{/);
  if (m) { cur = m[1]; bs = i; d = 1; st = true; }
  else if (st) {
    for (let ch of lines[i]) { if (ch === '{') d++; else if (ch === '}') d--; }
    if (d === 0) { lb[cur] = { s: bs, e: i }; st = false; }
  }
}

// Extract all keys from a block
function getKeys(start, end) {
  let keys = new Set();
  for (let i = start; i <= end; i++) {
    let m = lines[i].match(/^\s+(\w+):\s/);
    if (m) keys.add(m[1]);
  }
  return keys;
}

let enKeys = getKeys(lb.en.s, lb.en.e);
console.log('EN has', enKeys.size, 'keys');

// Check each language for missing keys
for (let lang of ['de', 'fr', 'it', 'da', 'sv', 'no', 'tr']) {
  let langKeys = getKeys(lb[lang].s, lb[lang].e);
  let missing = [...enKeys].filter(k => !langKeys.has(k));
  if (missing.length > 0) {
    console.log('\n' + lang + ': MISSING ' + missing.length + ' keys:');
    missing.forEach(k => console.log('  - ' + k));
  } else {
    console.log(lang + ': OK (all ' + langKeys.size + ' keys present)');
  }
}
