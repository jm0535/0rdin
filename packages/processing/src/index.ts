// @ordin/processing — Client-side ecology kernels
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

// webR bridge — WASM bridge
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
// Ordination via webR — supports all 11 methods, returns site/species/env scores + stats
export async function runOrdinationViaWebR(
  matrix: number[][],
  envMatrix: number[][] | null,
  envColNames: string[] | null,
  opts: { method: string; distance: string; k: number }
): Promise<{ sites: [number,number][]; species: [number,number][]; env: [number,number][]; envLabels: string[]; stress?: number; eigenvalues?: number[]; variance?: number[]; grade?: string }> {
  const w = await getWebR();
  try { await w.evalRVoid('library(vegan)'); } catch { try { await (w as any).installPackages(['vegan']); await w.evalRVoid('library(vegan)'); } catch {} }
  const rMatrix = `matrix(c(${matrix.flat().join(',')}), nrow=${matrix.length}, byrow=TRUE)`;
  const rEnv = envMatrix && envColNames ? `env <- matrix(c(${envMatrix.flat().join(',')}), nrow=${envMatrix.length}, byrow=TRUE); colnames(env) <- c(${envColNames.map(c=>`"${c}"`).join(',')}); rownames(env) <- paste0("site",1:nrow(env))` : `env <- NULL`;
  const k = opts.k; const dist = opts.distance; const m = opts.method;
  let rCode = "";
  if (m === 'nmds') {
    rCode = `
    m <- ${rMatrix}; colnames(m) <- paste0("sp",1:ncol(m)); rownames(m) <- paste0("site",1:nrow(m))
    ${rEnv}
    res <- vegan::metaMDS(m, distance="${dist}", k=${k}, trymax=20, trace=0, autotransform=FALSE)
    s <- as.matrix(res$points); sp <- tryCatch(as.matrix(vegan::scores(res, display="species")), error=function(e) matrix(0, nrow=0,ncol=2))
    ef <- if (!is.null(env)) tryCatch({ ef <- vegan::envfit(res, env, perm=0); as.matrix(ef$vectors$arrows) }, error=function(e) matrix(0,nrow=0,ncol=2)) else matrix(0,nrow=0,ncol=2)
    list(sites=s, species=sp, env=ef, envLabels=if(nrow(ef)>0) rownames(ef) else character(0), stress=res$stress, grade=NA)
    `;
  } else if (m === 'pca' || m === 'tb-pca') {
    const trans = m==='tb-pca' ? 'm <- vegan::decostand(m, "hellinger")' : ''
    rCode = `
    m <- ${rMatrix}; colnames(m) <- paste0("sp",1:ncol(m)); rownames(m) <- paste0("site",1:nrow(m))
    ${trans}
    res <- vegan::rda(m)
    s <- as.matrix(vegan::scores(res, display="sites", choices=1:2))
    sp <- as.matrix(vegan::scores(res, display="species", choices=1:2))
    ev <- vegan::eigenvals(res); va <- 100*ev/sum(ev)
    list(sites=s, species=sp, env=matrix(0,nrow=0,ncol=2), envLabels=character(0), eigenvalues=as.numeric(ev[1:2]), variance=as.numeric(va[1:2]))
    `;
  } else if (m === 'ca') {
    rCode = `
    m <- ${rMatrix}; colnames(m) <- paste0("sp",1:ncol(m)); rownames(m) <- paste0("site",1:nrow(m))
    res <- vegan::cca(m)
    s <- as.matrix(vegan::scores(res, display="sites", choices=1:2))
    sp <- as.matrix(vegan::scores(res, display="species", choices=1:2))
    list(sites=s, species=sp, env=matrix(0,nrow=0,ncol=2), envLabels=character(0))
    `;
  } else if (m === 'dca') {
    rCode = `
    m <- ${rMatrix}; colnames(m) <- paste0("sp",1:ncol(m)); rownames(m) <- paste0("site",1:nrow(m))
    res <- vegan::decorana(m)
    s <- as.matrix(vegan::scores(res, display="sites", choices=1:2))
    sp <- as.matrix(vegan::scores(res, display="species", choices=1:2))
    list(sites=s, species=sp, env=matrix(0,nrow=0,ncol=2), envLabels=character(0))
    `;
  } else if (m === 'pcoa') {
    rCode = `
    m <- ${rMatrix}; colnames(m) <- paste0("sp",1:ncol(m)); rownames(m) <- paste0("site",1:nrow(m))
    d <- vegan::vegdist(m, method="${dist}")
    res <- vegan::wcmdscale(d, eig=TRUE)
    s <- as.matrix(res$points[,1:2])
    list(sites=s, species=matrix(0,nrow=0,ncol=2), env=matrix(0,nrow=0,ncol=2), envLabels=character(0), eigenvalues=as.numeric(res$eig[1:2]))
    `;
  } else if (m === 'rda' || m === 'tb-rda') {
    const trans2 = m==='tb-rda' ? 'm <- vegan::decostand(m, "hellinger");' : ''
    rCode = `
    m <- ${rMatrix}; colnames(m) <- paste0("sp",1:ncol(m)); rownames(m) <- paste0("site",1:nrow(m))
    ${rEnv}
    ${trans2}
    df <- as.data.frame(env)
    res <- vegan::rda(m ~ ., data=df)
    s <- as.matrix(vegan::scores(res, display="sites", choices=1:2))
    sp <- as.matrix(vegan::scores(res, display="species", choices=1:2))
    bp <- as.matrix(vegan::scores(res, display="bp", choices=1:2))
    list(sites=s, species=sp, env=bp, envLabels=rownames(bp), eigenvalues=as.numeric(vegan::eigenvals(res)[1:2]))
    `;
  } else if (m === 'cca') {
    rCode = `
    m <- ${rMatrix}; colnames(m) <- paste0("sp",1:ncol(m)); rownames(m) <- paste0("site",1:nrow(m))
    ${rEnv}
    df <- as.data.frame(env)
    res <- vegan::cca(m ~ ., data=df)
    s <- as.matrix(vegan::scores(res, display="sites", choices=1:2))
    sp <- as.matrix(vegan::scores(res, display="species", choices=1:2))
    bp <- as.matrix(vegan::scores(res, display="bp", choices=1:2))
    list(sites=s, species=sp, env=bp, envLabels=rownames(bp))
    `;
  } else if (m === 'dbrda' || m === 'cap') {
    rCode = `
    m <- ${rMatrix}; colnames(m) <- paste0("sp",1:ncol(m)); rownames(m) <- paste0("site",1:nrow(m))
    ${rEnv}
    df <- as.data.frame(env)
    res <- vegan::capscale(m ~ ., data=df, distance="${dist}")
    s <- as.matrix(vegan::scores(res, display="sites", choices=1:2))
    sp <- tryCatch(as.matrix(vegan::scores(res, display="species", choices=1:2)), error=function(e) matrix(0,nrow=0,ncol=2))
    bp <- as.matrix(vegan::scores(res, display="bp", choices=1:2))
    list(sites=s, species=sp, env=bp, envLabels=rownames(bp))
    `;
  } else {
    rCode = `list(sites=matrix(0,nrow=0,ncol=2), species=matrix(0,nrow=0,ncol=2), env=matrix(0,nrow=0,ncol=2), envLabels=character(0))`
  }
  const r = await w.evalR(rCode);
  const j = await (r as any).toJs();
  // normalize to JS arrays
  const toArr = (x:any): [number,number][] => {
    if (!x || !x.values) return [];
    // x is R matrix as object with values
    try {
      const v = x.values ? Array.from(x.values as any) : [];
      const dims = x._dims || [v.length/2,2];
      const n = dims[0];
      const arr: [number,number][] = [];
      for (let i=0;i<n;i++) arr.push([Number(v[i])||0, Number(v[i+n])||0]);
      return arr;
    } catch { return []; }
  };
  // fallback if already array
  const sites = Array.isArray(j.sites) ? j.sites as [number,number][] : toArr(j.sites);
  const species = Array.isArray(j.species) ? j.species as [number,number][] : toArr(j.species);
  const env = Array.isArray(j.env) ? j.env as [number,number][] : toArr(j.env);
  const envLabels = j.envLabels ? Array.from(j.envLabels as any).map(String) : [];
  return { sites, species, env, envLabels, stress: j.stress, eigenvalues: j.eigenvalues, variance: j.variance, grade: j.grade };
}

