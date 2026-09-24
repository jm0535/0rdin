// Ördin dev tool: validate R syntax of .R files without a system R installation.
// Uses webR (R compiled to WebAssembly) fetched from npm.
//
//   npm install            # once (installs webr devDependency)
//   npm run check-r-syntax -- shiny/app.R shiny/R/performance.R
//
// In CI (which has real R) prefer `Rscript -e 'parse("file.R")'`; this tool
// exists for environments where R cannot be installed.
//
// If `webr` cannot be installed into the repo tree (e.g. restricted network),
// install it anywhere and point WEBR_MODULE at it:
//   WEBR_MODULE=/path/to/node_modules/webr node tools/r-syntax-check.mjs ...
import fs from 'fs';
import { createRequire } from 'node:module';

const spec = process.env.WEBR_MODULE || 'webr';
let WebR;
try {
  ({ WebR } = await import(spec));
} catch (err) {
  // Directory path given (ESM cannot import directories): resolve its entry point.
  try {
    ({ WebR } = await import(spec.replace(/\/+$/, '') + '/dist/webr.mjs'));
  } catch {
    ({ WebR } = createRequire(import.meta.url)(spec));
  }
}

const files = process.argv.slice(2);
if (!files.length) {
  console.error('usage: node tools/r-syntax-check.mjs <file.R> [more.R ...]');
  process.exit(2);
}

const webR = new WebR();
await webR.init();
let failed = 0;
for (const f of files) {
  const code = fs.readFileSync(f, 'utf8');
  const escaped = JSON.stringify(code);
  try {
    await webR.evalR(`invisible(parse(text = ${escaped}))`);
    console.log('OK   ', f);
  } catch (e) {
    failed++;
    console.log('FAIL ', f, '\n      ', String(e.message || e).split('\n').slice(0, 4).join('\n       '));
  }
}
if (typeof webR.shutdown === 'function') await webR.shutdown();
process.exit(failed ? 1 : 0);
