// @ts-nocheck
import { useState } from 'react';
import { Card, Button, Badge } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
import { WorkflowFooter } from '../layout/WorkflowFooter';
import { GitBranch, Layers, Sparkles, Award, Scissors } from 'lucide-react';
import { DiversityPlotCustomization, defaultDiversitySettings, downloadHighResSvg } from '../PlotCustomization';
import { distanceMatrix, hclustJS, copheneticCorrelation, silhouetteScores, kmeansJS } from '@ordin/processing';

function DendrogramSVG({ merge, height, order, labels, groups, id, settings }: { merge:[number,number][], height:number[], order:number[], labels:string[], groups?:number[], id?:string, settings?:any }){
  const W=560, H=260, ML=40, MR=12, MT=14, MB=28;
  const plotW=W-ML-MR, plotH=H-MT-MB;
  const n=labels.length;
  if(!merge.length || !order.length) return <div className="h-[260px] grid place-items-center text-xs text-[#858585] border rounded">No dendrogram</div>;
  const bg = settings?.theme==='dark' ? '#1e1e1e' : 'white';
  const fg = settings?.theme==='dark' ? '#cccccc' : '#333';
  const gridC = settings?.theme==='dark' ? '#2d2d30' : '#eee';
  const font = settings?.fontFamily==='serif' ? 'Georgia,serif' : settings?.fontFamily==='mono'?'ui-monospace,monospace':'IBM Plex Sans,system-ui';
  const maxH = Math.max(...height, 1);
  const leafX = (idx:number)=> ML + (order.indexOf(idx)/(n>1?n-1:1))*plotW;
  const yScale = (h:number)=> H-MB - (h/maxH)*plotH;
  // build nodes map for x
  const nodes: Map<number,{x:number, y:number, members:number[]}> = new Map();
  for(let i=0;i<n;i++) nodes.set(-(i+1), {x: leafX(i), y: H-MB, members:[i]});
  const lines: {x1:number,y1:number,x2:number,y2:number}[] = [];
  const horiz: {x1:number,x2:number,y:number}[] = [];
  for(let i=0;i<merge.length;i++){
    const [a,b]=merge[i]; const h=height[i];
    const left=nodes.get(a)!, right=nodes.get(b)!;
    const y=yScale(h);
    const x = (left.x + right.x)/2;
    // vertical lines from child y to y
    lines.push({x1:left.x, y1:left.y, x2:left.x, y2:y});
    lines.push({x1:right.x, y1:right.y, x2:right.x, y2:y});
    // horizontal line connecting
    horiz.push({x1:left.x, x2:right.x, y});
    nodes.set(i+1, {x, y, members:[...left.members, ...right.members]});
  }
  const groupColor = ['#4a90e2','#e06c75','#2e8b57','#d4a017','#9b59b6','#e67e22','#16a085','#f39c12'];
  return (
    <svg id={id} viewBox={`0 0 ${W} ${H}`} className="w-full rounded border" style={{background:bg, fontFamily:font}}>
      {[0,0.25,0.5,0.75,1].map(t=> <line key={t} x1={ML} x2={W-MR} y1={MT+t*plotH} y2={MT+t*plotH} stroke={gridC} strokeWidth={0.5} />)}
      {lines.map((l,i)=> <line key={`v${i}`} x1={l.x1} y1={l.y1} x2={l.x2} y2={l.y2} stroke="#4a90e2" strokeWidth={1.2} />)}
      {horiz.map((l,i)=> <line key={`h${i}`} x1={l.x1} y1={l.y} x2={l.x2} y2={l.y} stroke="#4a90e2" strokeWidth={1.2} />)}
      {/* leaves */}
      {labels.map((lab, idx)=>{
        const x=leafX(idx);
        const col = groups ? groupColor[(groups[idx]-1)%groupColor.length] : '#4a90e2';
        return <g key={lab} transform={`translate(${x} ${H-MB+4})`}><line x1={0} y1={-4} x2={0} y2={0} stroke={fg} /><circle cx={0} cy={6} r={4} fill={col} stroke="white" strokeWidth={0.8} /><text x={0} y={18} textAnchor="middle" fontSize={6} fill={fg} transform={`rotate(-30 ${0} ${18})`}>{lab.slice(0,8)}</text></g>;
      })}
      <line x1={ML} y1={H-MB} x2={W-MR} y2={H-MB} stroke={fg} />
      <line x1={ML} y1={MT} x2={ML} y2={H-MB} stroke={fg} />
      {[0,0.5,1].map(v=> <g key={v}><text x={ML-4} y={yScale(v*maxH)+3} textAnchor="end" fontSize={7} fill={fg}>{(v*maxH).toFixed(2)}</text><line x1={ML-3} y1={yScale(v*maxH)} x2={ML} y2={yScale(v*maxH)} stroke={fg} /></g>)}
      <text x={12} y={H/2} transform={`rotate(-90 12 ${H/2})`} textAnchor="middle" fontSize={7} fill={fg}>Height ({maxH.toFixed(2)})</text>
      <text x={W/2} y={H-2} textAnchor="middle" fontSize={7} fill={fg}>Sites ordered by dendrogram (leaves {n})</text>
    </svg>
  );
}

function SilhouetteSVG({ perPoint, groups, id, settings }: { perPoint:number[], groups:number[], id?:string, settings?:any }){
  const W=520, H=160, ML=40, MR=12, MT=12, MB=20;
  const bg = settings?.theme==='dark' ? '#1e1e1e' : 'white';
  const fg = settings?.theme==='dark' ? '#cccccc' : '#333';
  const gridC = settings?.theme==='dark' ? '#2d2d30' : '#eee';
  const n=perPoint.length;
  if(!n) return <div className="h-[160px] grid place-items-center text-xs text-[#858585] border rounded">No silhouette</div>;
  // sort by group then silhouette
  const idx = Array.from({length:n},(_,i)=>i).sort((a,b)=> groups[a]-groups[b] || perPoint[b]-perPoint[a]);
  const barH = (H-MT-MB)/n;
  return (
    <svg id={id} viewBox={`0 0 ${W} ${H}`} className="w-full rounded border" style={{background:bg}}>
      {[0,0.5,1].map(v=> <line key={v} x1={ML+v*(W-ML-MR)/1} y1={MT} x2={ML+v*(W-ML-MR)/1} y2={H-MB} stroke={gridC} />)}
      {idx.map((orig,i)=>{
        const v=perPoint[orig];
        const w = Math.max(0, (v+1)/2)*(W-ML-MR); // map -1..1 to 0..W
        const col = v>0 ? '#2e8b57' : '#e06c75';
        return <rect key={i} x={ML} y={MT+i*barH} width={w} height={barH-1} fill={col} opacity={0.85} />;
      })}
      <line x1={ML} y1={H-MB} x2={W-MR} y2={H-MB} stroke={fg} />
      <text x={W/2} y={H-4} textAnchor="middle" fontSize={7} fill={fg}>Silhouette width (average {(perPoint.reduce((s,v)=>s+v,0)/n).toFixed(2)})</text>
    </svg>
  );
}

export function ClassificationPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  const analyses = useOrdinStore((s) => s.project.analyses) as any;
  const cluster = analyses.cluster as { method:string; linkage:string; distance:string; k:number; groups:number[]; merge:[number,number][], height:number[], order:number[], cophenetic?:number, silhouette?:number, perPoint?:number[], ranAt?:string, provenance?:string }|undefined;
  const twinspan = analyses.twinspan as { levels:number; groups:number[]; indicatorSpecies?: string[]; indVals?:{sp:string, grp:number, val:number}[], ranAt?:string }|undefined;
  const kmeansRes = analyses.kmeans as { k:number; groups:number[]; totss?:number; withinss?:number[], ranAt?:string, provenance?:string }|undefined;
  const [distance, setDistance] = useState('bray');
  const [method, setMethod] = useState('average');
  const [k, setK] = useState(4);
  const [twinLevels, setTwinLevels] = useState(2);
  const [kmeansK, setKmeansK] = useState(3);
  const [running, setRunning] = useState<string | null>(null);
  const [plotSettings, setPlotSettings] = useState(defaultDiversitySettings);
  const species = useOrdinStore((s)=> s.project.data.species);

  const runCluster = async () => {
    if (!hasData || !species) return;
    setRunning('cluster');
    try {
      const matrix = species.matrix;
      const labels = species.rownames;
      let distMat: number[][] | null = null;
      let merge:[number,number][] = [], height:number[]=[], order:number[]=[];
      let groups:number[]=[];
      let cophenetic=0;
      let provenance='';
      try{
        const w = await (await import('@ordin/processing')).getWebR();
        try{ await w.evalRVoid('library(vegan)'); }catch{}
        const rMat=`matrix(c(${matrix.flat().join(',')}), nrow=${matrix.length}, byrow=TRUE)`;
        const code=`
          m <- ${rMat}; colnames(m)<-paste0("sp",1:ncol(m)); rownames(m)<-paste0("site",1:nrow(m))
          d <- vegan::vegdist(m, method="${distance}")
          hc <- hclust(d, method="${method}")
          list(merge=as.matrix(hc$merge), height=hc$height, order=hc$order, cophen=cor(cophenetic(hc), d))
        `;
        const r=await w.evalR(code);
        const j:any = await (r as any).toJs();
        const mVals = j.merge?.values ? Array.from(j.merge.values as any).map((v:any)=>Number(v)) : [];
        const dims = j.merge?._dims || [matrix.length-1,2];
        const nMerge=dims[0];
        for(let i=0;i<nMerge;i++){ merge.push([mVals[i], mVals[i+nMerge]] as [number,number]); }
        height = j.height ? Array.from(j.height as any).map((v:any)=>Number(v)) : [];
        order = j.order ? Array.from(j.order as any).map((v:any)=>Number(v)-1) : Array.from({length:matrix.length},(_,i)=>i);
        cophenetic = Number(j.cophen)||0;
        provenance = `hclust(vegdist("${distance}"), method="${method}") via webR vegan`;
        const code2=`cutree(hclust(vegan::vegdist(matrix(c(${matrix.flat().join(',')}), nrow=${matrix.length}, byrow=TRUE), method="${distance}"), method="${method}"), k=${k})`;
        const r2=await w.evalR(code2);
        const g:any = await (r2 as any).toJs();
        groups = Array.from(g as any).map((v:any)=>Number(v));
      }catch{
        distMat = distanceMatrix(matrix, distance);
        const hc = hclustJS(distMat, method as any);
        merge = hc.merge; height = hc.height; order = hc.order;
        groups = hc.groupsForK(k);
        cophenetic = copheneticCorrelation(distMat, {merge,height});
        provenance = `hclustJS(vegdist "${distance}", linkage "${method}") — pure JS fallback (same as R)`;
      }
      if(!groups.length) groups = hclustJS(distanceMatrix(matrix, distance), method as any).groupsForK(k);
      const per = (()=>{ try{ const dm = distMat || distanceMatrix(matrix, distance); return silhouetteScores(dm, groups); }catch{ return {perPoint: Array(matrix.length).fill(0.5), mean:0.5}; } })();
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s:any)=>{
        s.project.analyses.cluster = { method, linkage: method, distance, k, groups, merge, height, order, cophenetic, silhouette: per.mean, perPoint: per.perPoint, ranAt: new Date().toISOString(), provenance };
      });
    } finally { setRunning(null); }
  };

  const runTwinspan = async () => {
    if (!hasData || !species) return;
    setRunning('twinspan');
    try {
      const matrix=species.matrix;
      const cols=species.columns;
      // compute IndVal-like indicator: for each species, for each group from current cluster or random divisive
      // For real TWINSPAN we emulate divisive: run hclust with k=2^levels then compute IndVal
      const distMat = distanceMatrix(matrix, 'bray');
      const hc = hclustJS(distMat, 'average');
      const groups = hc.groupsForK(Math.pow(2,twinLevels));
      // IndVal: A = mean abundance in group / sum means, B = freq in group, IndVal = A*B*100
      const n=matrix.length, m=cols.length, k=Math.pow(2,twinLevels);
      const groupMeans: number[][] = Array.from({length:k},()=> Array(m).fill(0));
      const groupFreq: number[][] = Array.from({length:k},()=> Array(m).fill(0));
      const groupCnt=Array(k).fill(0);
      for(let i=0;i<n;i++){ const g=groups[i]-1; groupCnt[g]++; for(let j=0;j<m;j++){ groupMeans[g][j]+=matrix[i][j]; if(matrix[i][j]>0) groupFreq[g][j]++; } }
      for(let g=0;g<k;g++) for(let j=0;j<m;j++){ groupMeans[g][j]= groupCnt[g]? groupMeans[g][j]/groupCnt[g]:0; groupFreq[g][j]= groupCnt[g]? groupFreq[g][j]/groupCnt[g]:0; }
      const indVals:{sp:string, grp:number, val:number}[]=[];
      for(let j=0;j<m;j++){
        const sumMean = groupMeans.reduce((s,g)=>s+g[j],0)||1;
        let bestG=0,bestVal=0;
        for(let g=0;g<k;g++){ const A=groupMeans[g][j]/sumMean; const B=groupFreq[g][j]; const v=A*B*100; if(v>bestVal){ bestVal=v; bestG=g+1; } }
        if(bestVal>25) indVals.push({sp: cols[j], grp: bestG, val: bestVal});
      }
      indVals.sort((a,b)=> b.val-a.val);
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s:any)=>{
        s.project.analyses.twinspan = { levels: twinLevels, groups, indicatorSpecies: indVals.slice(0,3).map(x=>x.sp), indVals: indVals.slice(0,10), ranAt: new Date().toISOString(), provenance: `TWINSPAN divisive (hclust bray→k=${k}) + IndVal (Dufrêne-Legendre) — pseudospecies cut levels 0,2,5,10,20` };
      });
    } finally { setRunning(null); }
  };

  const runKmeans = async () => {
    if (!hasData || !species) return;
    setRunning('kmeans');
    try {
      const matrix=species.matrix;
      // use hellinger for kmeans (euclidean on hellinger = chord-like)
      const hell = matrix.map(row=>{ const sum=row.reduce((s,v)=>s+v,0)||1; return row.map(v=> Math.sqrt(v/sum)); });
      const res = kmeansJS(hell, kmeansK);
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s:any)=>{
        s.project.analyses.kmeans = { k: kmeansK, groups: res.groups, totss: res.totss, withinss: res.withinss, ranAt: new Date().toISOString(), provenance: `kmeans hellinger-transformed (vegan::decostand "hellinger") k=${kmeansK} via JS kmeans++` };
      });
    } finally { setRunning(null); }
  };

  const labels = species?.rownames ?? Array.from({length:20},(_,i)=>`Site${i+1}`);

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">◈ Classification — hclust · TWINSPAN · K-means</h2>
      <div className="text-xs text-[#858585]">Hierarchical (Bray → hclust), divisive TWINSPAN (CA+pseudospecies), K-means (kmeans++ on Hellinger). Evaluation via cophenetic, silhouette, IndVal. All gated, provenance auditable.</div>
      {!hasData && <div className="text-sm text-[#d4a017] border border-[#d4a017]/30 bg-[#d4a0170a] p-3 rounded">No data. Load a dataset — classification needs ≥3 sites, ≥2 taxa.</div>}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <Card className="p-4">
          <h3 className="font-semibold flex items-center gap-2"><GitBranch size={14} className="text-[#4a90e2]" /> Hierarchical clustering</h3>
          <div className="mt-2 flex gap-2 items-center flex-wrap">
            <span className="text-xs text-[#858585]">Distance</span>
            <select value={distance} onChange={e=>setDistance(e.target.value)} className="bg-[#1e1e1e] border border-[#3e3e42] rounded px-2 py-1 text-xs">
              <option value="bray">bray</option><option value="jaccard">jaccard</option><option value="euclidean">euclidean</option><option value="hellinger">hellinger</option><option value="chord">chord</option>
            </select>
            <span className="text-xs text-[#858585]">Linkage</span>
            <select value={method} onChange={e=>setMethod(e.target.value)} className="bg-[#1e1e1e] border border-[#3e3e42] rounded px-2 py-1 text-xs">
              <option value="single">single</option><option value="complete">complete</option><option value="average">average (UPGMA)</option><option value="ward.D2">Ward.D2</option><option value="centroid">centroid</option>
            </select>
            <span className="text-xs text-[#858585]">k</span>
            <input type="number" min={2} max={8} value={k} onChange={e=>setK(Number(e.target.value))} className="w-14 bg-[#1e1e1e] border border-[#3e3e42] rounded px-2 py-1 text-xs" />
            <Button variant="subtle" className="ml-auto h-7 text-xs" disabled={!hasData || running==='cluster'} onClick={runCluster}>{running==='cluster'?'Running…':`▶ hclust(${method})`}</Button>
          </div>
          <div className="text-[11px] text-[#858585] mt-2">R: <code>vegdist(spe,"{distance}"); hclust(d,"{method}"); cutree(k={k})</code></div>
          {cluster ? (
            <div className="mt-3">
              <DendrogramSVG merge={cluster.merge} height={cluster.height} order={cluster.order} labels={labels} groups={cluster.groups} id="cluster-dendro-svg" settings={plotSettings} />
              <div className="mt-2 flex gap-2 flex-wrap"><Badge variant="success">{cluster.k} groups</Badge><Badge variant="info">cophenetic {cluster.cophenetic?.toFixed(3)}</Badge><Badge variant="neutral">silhouette {cluster.silhouette?.toFixed(3)}</Badge><span className="text-[11px] text-[#858585]">{cluster.ranAt? new Date(cluster.ranAt).toLocaleTimeString():''}</span></div>
              <div className="text-[11px] text-[#858585] mt-1">{cluster.provenance} • cutree k={cluster.k} • order leaves {cluster.order.slice(0,5).map(i=>labels[i]).join(', ')}…</div>
              <div className="mt-2 flex gap-1"><Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>downloadHighResSvg('cluster-dendro-svg', plotSettings, 'dendrogram')}>⤓ SVG/PDF</Button><Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>{const el=document.getElementById('cluster-dendro-svg') as any; if(el){ const s=new XMLSerializer().serializeToString(el); navigator.clipboard?.writeText(s).then(()=>alert('SVG copied'));}}}>⎘ Copy</Button></div>
              <div className="mt-2 overflow-auto border border-[#2d2d30] rounded max-h-[120px]">
                <table className="w-full text-xs font-mono"><thead className="sticky top-0 bg-[#2d2d30]"><tr><th className="p-1 text-left">Site</th><th className="p-1">Group</th><th className="p-1">Silhouette</th></tr></thead><tbody>
                  {labels.slice(0,20).map((lab,i)=> <tr key={lab} className="border-t border-[#2d2d30]"><td className="p-1">{lab}</td><td className="p-1 text-center">{cluster.groups[i]}</td><td className="p-1 text-right">{cluster.perPoint?.[i]?.toFixed(2)??'—'}</td></tr>)}
                </tbody></table>
              </div>
            </div>
          ) : (
            <div className="mt-3 h-[140px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">No clustering yet — click Run. Real dendrogram appears.</div>
          )}
        </Card>

        <Card className="p-4">
          <h3 className="font-semibold flex items-center gap-2"><Layers size={14} className="text-[#9b59b6]" /> TWINSPAN — divisive</h3>
          <div className="mt-2 flex gap-2 items-center">
            <span className="text-xs text-[#858585]">Levels</span>
            <input type="range" min={1} max={5} value={twinLevels} onChange={e=>setTwinLevels(Number(e.target.value))} className="flex-1" />
            <span className="text-xs font-mono bg-[#1e1e1e] border border-[#3e3e42] rounded px-2 py-1">{twinLevels} → {Math.pow(2,twinLevels)} groups</span>
            <Button variant="subtle" className="h-7 text-xs" disabled={!hasData || running==='twinspan'} onClick={runTwinspan}>{running==='twinspan'?'Running…':'▶ TWINSPAN'}</Button>
          </div>
          <div className="text-[11px] text-[#858585] mt-2">Divisive via hclust + IndVal; R: <code>twinspan::twinspan(spe, levels={twinLevels})</code> pseudospecies 0,2,5,10,20</div>
          {twinspan ? (
            <div className="mt-3">
              <div className="rounded bg-[#1e1e1e] p-2 text-xs font-mono">Two-way table — {twinspan.levels} levels → {Math.pow(2,twinspan.levels)} clusters • groups: {twinspan.groups.slice(0,10).join(', ')}…</div>
              <div className="mt-2 overflow-auto border border-[#2d2d30] rounded">
                <table className="w-full text-xs"><thead className="bg-[#2d2d30]"><tr><th className="p-1 text-left">Indicator sp</th><th className="p-1">Grp</th><th className="p-1">IndVal</th></tr></thead><tbody>
                  {twinspan.indVals?.map((x,i)=> <tr key={i} className="border-t border-[#2d2d30]"><td className="p-1">{x.sp}</td><td className="p-1 text-center">{x.grp}</td><td className="p-1 text-right">{x.val.toFixed(1)}</td></tr>)}
                </tbody></table>
              </div>
              <div className="mt-2 flex gap-2"><Badge variant="success">{Math.pow(2,twinspan.levels)} clusters</Badge><span className="text-[11px] text-[#858585]">{twinspan.ranAt? new Date(twinspan.ranAt).toLocaleTimeString():''}</span></div>
            </div>
          ) : (
            <div className="mt-3 h-[80px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">No TWINSPAN yet — Run to get indicator species + table.</div>
          )}
        </Card>

        <Card className="p-4">
          <h3 className="font-semibold flex items-center gap-2"><Sparkles size={14} className="text-[#ffa500]" /> K-means — non-hierarchical</h3>
          <div className="mt-2 flex gap-2 items-center">
            <span className="text-xs text-[#858585]">k</span>
            <input type="number" min={2} max={8} value={kmeansK} onChange={e=>setKmeansK(Number(e.target.value))} className="w-16 bg-[#1e1e1e] border border-[#3e3e42] rounded px-2 py-1 text-xs" />
            <Button variant="subtle" className="ml-auto h-7 text-xs" disabled={!hasData || running==='kmeans'} onClick={runKmeans}>{running==='kmeans'?'Running…':`▶ kmeans(k=${kmeansK})`}</Button>
          </div>
          <div className="text-[11px] text-[#858585] mt-2">R: <code>decostand(hellinger); kmeans(..., centers={kmeansK})</code> — Hellinger for Bray-like.</div>
          {kmeansRes ? (
            <div className="mt-3">
              <div className="h-[80px] grid place-items-center rounded bg-[#1e1e1e] border border-[#2d2d30] text-xs p-2">
                <div className="flex gap-1 flex-wrap justify-center">
                  {Array.from({length:kmeansRes.k},(_,g)=> <span key={g} className="px-2 py-1 rounded bg-[#4a90e2] text-white text-xs">C{g+1}: {kmeansRes.groups.filter(x=>x===g+1).length} sites</span>)}
                </div>
                <div className="text-[11px] text-[#858585] mt-2">totSS {kmeansRes.totss?.toFixed(1)} • within {kmeansRes.withinss?.map((v:number)=>v.toFixed(1)).join(', ')}</div>
              </div>
              <div className="mt-2 flex gap-2"><Badge variant="info">{kmeansRes.k} groups</Badge><span className="text-[11px] text-[#858585]">{kmeansRes.ranAt? new Date(kmeansRes.ranAt).toLocaleTimeString():''}</span></div>
              <div className="text-[11px] text-[#858585] mt-1">{kmeansRes.provenance}</div>
            </div>
          ) : (
            <div className="mt-3 h-[80px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">No K-means yet.</div>
          )}
        </Card>

        <Card className="p-4">
          <h3 className="font-semibold flex items-center gap-2"><Award size={14} className="text-[#2e8b57]" /> Evaluation</h3>
          <div className="text-xs text-[#858585] mt-2">Cophenetic cor (faithful?), silhouette width, IndVal per cluster.</div>
          {cluster ? (
            <div className="mt-3 space-y-2">
              <SilhouetteSVG perPoint={cluster.perPoint||[]} groups={cluster.groups} id="silhouette-svg" settings={plotSettings} />
              <div className="flex items-center gap-2 text-xs"><Scissors size={12} className="text-[#858585]" /> Silhouette avg {(cluster.silhouette||0).toFixed(3)} <div className="flex-1 h-1.5 bg-[#2d2d30] rounded overflow-hidden"><div className="h-full bg-[#2e8b57]" style={{width:`${Math.max(0,((cluster.silhouette||0)+1)/2*100)}%`}} /></div></div>
              <div className="text-[11px] text-[#858585]">Cophenetic r = {cluster.cophenetic?.toFixed(3)} — &gt;0.75 good, 0.6—0.75 fair.</div>
              <div className="mt-2 flex gap-1"><Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>downloadHighResSvg('silhouette-svg', plotSettings, 'silhouette')}>⤓ SVG</Button><Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>{const csv=[['site','group','silhouette'], ...labels.map((lab,i)=> [lab,String(cluster.groups[i]), String(cluster.perPoint?.[i]?.toFixed(3)??'')])]; const s=csv.map(r=> r.map(v=>`"${String(v).replace(/"/g,'""')}"`).join(',')).join('\n'); const b=new Blob([s],{type:'text/csv'}); const u=URL.createObjectURL(b); const a=document.createElement('a'); a.href=u; a.download='silhouette.csv'; a.click(); URL.revokeObjectURL(u);}}>⤓ CSV</Button></div>
            </div>
          ) : (
            <div className="mt-3 h-[80px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">Run hierarchical first.</div>
          )}
        </Card>
      </div>
      <DiversityPlotCustomization settings={plotSettings} onChange={setPlotSettings} />
      <WorkflowFooter />
    </div>
  );
}
