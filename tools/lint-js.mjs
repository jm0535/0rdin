// Ördin JS lint — dependency-free checks for the repo's JavaScript sources.
//
// Checks (in order of importance):
//   1. Encoding guard: files must be UTF-8 without BOM. This exists because
//      shiny/www/shiny-ui.js was once committed as UTF-16LE, which browsers
//      and bundlers silently mangle.
//   2. Syntax: every file must pass `node --check` (parse only, never runs).
//
// Why not `standard`/eslint? The historical `npm run lint` invoked `standard`,
// which was never in devDependencies (CI could not pass) and whose style rules
// conflict with the semicolon/browser-global style of shiny/www. This tool
// enforces the properties that actually caused bugs, with zero dependencies.
//
// Usage: node tools/lint-js.mjs        (or: npm run lint)

import fs from 'fs';
import path from 'path';
import { execFileSync } from 'child_process';

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname), '..');
const SCAN_DIRS = ['src', 'build', 'shiny/www', 'tools'];
const SCAN_ROOT_FILES = ['forge.config.js'];
const EXCLUDE = new Set(['node_modules', '.git', 'dist', 'out', '.venv']);

function collect(dir, out = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (EXCLUDE.has(entry.name)) continue;
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) collect(full, out);
    else if (entry.name.endsWith('.js')) out.push(full);
  }
  return out;
}

const files = [];
for (const d of SCAN_DIRS) {
  const full = path.join(ROOT, d);
  if (fs.existsSync(full)) collect(full, files);
}
for (const f of SCAN_ROOT_FILES) {
  const full = path.join(ROOT, f);
  if (fs.existsSync(full)) files.push(full);
}

let failures = 0;
for (const file of files) {
  const rel = path.relative(ROOT, file);
  const buf = fs.readFileSync(file);

  // 1. Encoding guard
  if (buf[0] === 0xff && buf[1] === 0xfe) {
    console.log(`FAIL ${rel}: UTF-16LE encoded (must be UTF-8, no BOM)`);
    failures++;
    continue;
  }
  if (buf[0] === 0xfe && buf[1] === 0xff) {
    console.log(`FAIL ${rel}: UTF-16BE encoded (must be UTF-8, no BOM)`);
    failures++;
    continue;
  }
  if (buf[0] === 0xef && buf[1] === 0xbb && buf[2] === 0xbf) {
    console.log(`FAIL ${rel}: UTF-8 BOM present (must be plain UTF-8)`);
    failures++;
    continue;
  }
  if (buf.includes(0x00)) {
    console.log(`FAIL ${rel}: contains NUL bytes (binary/wrong encoding?)`);
    failures++;
    continue;
  }

  // 2. Syntax check (parse only)
  try {
    execFileSync(process.execPath, ['--check', file], { stdio: 'pipe' });
  } catch (e) {
    console.log(`FAIL ${rel}: syntax error\n${String(e.stderr || e.message).split('\n').slice(0, 5).join('\n')}`);
    failures++;
    continue;
  }
  console.log(`OK   ${rel}`);
}

console.log(`\n${files.length} file(s) checked, ${failures} failure(s)`);
process.exit(failures ? 1 : 0);
