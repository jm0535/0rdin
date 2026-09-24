// @ordin/processing — Client-side ecology kernels (mirrors @geolibre/processing)
// Primary: webR (vegan/iNEXT) in a Worker. Fallback: pure-JS for simple indices.

export function brayCurtis(a: number[], b: number[]): number {
  let num = 0, den = 0;
  for (let i = 0; i < a.length; i++) { num += Math.abs(a[i] - b[i]); den += a[i] + b[i]; }
  return den === 0 ? 0 : num / den;
}
export function shannon(row: number[]): number {
  const n = row.reduce((s, v) => s + v, 0);
  if (n === 0) return 0;
  let h = 0;
  for (const v of row) if (v > 0) { const p = v / n; h -= p * Math.log(p); }
  return h;
}
export function simpson(row: number[]): number {
  const n = row.reduce((s, v) => s + v, 0);
  if (n < 2) return 0;
  let s = 0; for (const v of row) s += v * (v - 1);
  return 1 - s / (n * (n - 1));
}

// webR bridge — mirrors GeoLibre's Whitebox WASM bridge
export type WebRStatus = 'idle' | 'loading' | 'ready' | 'error';

let webr: any = null;
let webrLoading: Promise<any> | null = null;

export async function getWebR(): Promise<any> {
  if (webr) return webr;
  if (webrLoading) return webrLoading;
  webrLoading = (async () => {
    const { WebR } = await import('webr');
    webr = new WebR();
    await webr.init();
    // Install R packages is no-op in preview; in production we mount wasm repo
    return webr;
  })();
  webr = await webrLoading;
  return webr;
}

// Example: vegan::metaMDS via webR — returns {stress, points, grade}
export async function runNMDSViaWebR(matrix: number[][], opts: { k: number; distance: string; trymax?: number }) {
  const w = await getWebR();
  // Serialize matrix as R code (small 20×30 demo)
  const rMatrix = `matrix(c(${matrix.flat().join(',')}), nrow=${matrix.length}, byrow=TRUE)`;
  const r = await w.evalR(`
    library(vegan)
    m <- ${rMatrix}
    colnames(m) <- paste0("sp", 1:ncol(m))
    rownames(m) <- paste0("site", 1:nrow(m))
    res <- metaMDS(m, distance="${opts.distance}", k=${opts.k}, trymax=${opts.trymax ?? 20}, trace=0, autotransform=FALSE)
    list(stress=res$stress, points=as.matrix(res$points))
  `);
  const j = await r.toJs();
  return j;
}

// iNEXT via webR — real R package, not mock
export async function runInextViaWebR(
  matrix: number[][],
  opts: { q: number[]; datatype: 'abundance'|'incidence'; knots: number; endpoint?: number | null; nboot: number; conf: number }
): Promise<{ iNextEst: any[]; AsyEst: any[]; DataInfo: any[] }> {
  const w = await getWebR();
  // Ensure iNEXT is available in webR (first run installs from repo, ~10s)
  try { await w.evalRVoid('library(iNEXT)'); } catch {
    // try install then library — in production webR mounts repo
    try { await (w as any).installPackages(['iNEXT']); await w.evalRVoid('library(iNEXT)'); } catch {}
  }
  const rMatrix = `matrix(c(${matrix.flat().join(',')}), nrow=${matrix.length}, byrow=TRUE)`;
  const qStr = `c(${opts.q.join(',')})`;
  const endpointR = opts.endpoint ? String(opts.endpoint) : 'NULL';
  const rCode = `
    m <- ${rMatrix}
    colnames(m) <- paste0("sp", 1:ncol(m))
    rownames(m) <- paste0("site", 1:nrow(m))
    # iNEXT expects species x sites (t) — each column is an assemblage
    out <- iNEXT(x = t(m), q = ${qStr}, datatype = "${opts.datatype}", knots = ${opts.knots}, se = TRUE, conf = ${opts.conf}, nboot = ${opts.nboot}, endpoint = ${endpointR})
    # simplify to JS-friendly: capture DataInfo, AsyEst, iNextEst head
    list(
      DataInfo = as.data.frame(out$DataInfo),
      AsyEst = as.data.frame(out$AsyEst),
      iNextEst = head(as.data.frame(out$iNextEst), 20)
    )
  `;
  const r = await w.evalR(rCode);
  const j = await (r as any).toJs();
  return j as any;
}
