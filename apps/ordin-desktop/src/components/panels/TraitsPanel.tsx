// @ts-nocheck
import { useState } from 'react';
import { Card, Button, Badge } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
import { WorkflowFooter } from '../layout/WorkflowFooter';
import { Leaf, Beaker, Share2 } from 'lucide-react';
import { DiversityPlotCustomization, defaultDiversitySettings, downloadHighResSvg } from '../PlotCustomization';
import { computeCWM, runRLQViaWebR } from '@ordin/processing';

function CWMHeatmap({ cwm, siteNames, traitNames, id, settings }: { cwm:number[][], siteNames:string[], traitNames:string[], id?:string, settings?:any }){
  const n=cwm.length, t=traitNames.length;
  if(!n||!t) return <div className="h-[120px] grid place-items-center text-xs text-[#858585] border rounded">No CWM</div>;
  const W=520, H= 160, ML=70, MR=12, MT=18, MB=22;
  const cellW=(W-ML-MR)/t, cellH=(H-MT-MB)/n;
  // compute per-trait min/max for color scale
  const mins=traitNames.map((_,j)=> Math.min(...cwm.map(r=>r[j])));
  const maxs=traitNames.map((_,j)=> Math.max(...cwm.map(r=>r[j])));
  const bg=settings?.theme==='dark' ? '#1e1e1e' : 'white';
  const fg=settings?.theme==='dark' ? '#cccccc' : '#333';
  return (
    <svg id={id} viewBox={`0 0 ${W} ${H}`} className="w-full rounded border" style={{background:bg}}>
      <text x={ML} y={MT-4} fontSize={9} fontWeight={700} fill="#2e8b57">CWM heatmap — sites × traits</text>
      {cwm.map((row,i)=> row.map((v,j)=>{
        const mn=mins[j], mx=maxs[j];
        const norm = mx===mn?0.5:(v-mn)/(mx-mn);
        const col = `rgb(${Math.round(255*(1-norm))}, ${Math.round(180+70*norm)}, ${Math.round(255*norm)})`;
        // use diverging: low white to green
        const r=Math.round(255 - norm*120), g=Math.round(230 - norm*50), b=Math.round(255 - norm*200);
        return <rect key={`${i}-${j}`} x={ML+j*cellW} y={MT+i*cellH} width={cellW} height={cellH} fill={`rgb(${r},${g},${b})`} stroke="#fff" strokeWidth={0.5} />;
      }))}
      {/* trait labels */}
      {traitNames.map((tr,j)=> <text key={tr} x={ML+j*cellW+cellW/2} y={MT-2} textAnchor="middle" fontSize={7} fill={fg}>{tr.slice(0,8)}</text>)}
      {siteNames.slice(0,Math.min(n,8)).map((sn,i)=> <text key={sn} x={ML-4} y={MT+i*cellH+cellH/2+2} textAnchor="end" fontSize={6} fill={fg}>{sn}</text>)}
      {traitNames.map((_,j)=>{
        const mn=mins[j].toFixed(1), mx=maxs[j].toFixed(1);
        return <text key={`scale-${j}`} x={ML+j*cellW+2} y={H-4} fontSize={6} fill={fg}>{mn}—{mx}</text>;
      })}
    </svg>
  );
}

function RLQTriplot({ siteScores, speciesScores, traitScores, envScores, envLabels, traitLabels, id, settings }: { siteScores:[number,number][], speciesScores:[number,number][], traitScores:[number,number][], envScores?:[number,number][], envLabels?:string[], traitLabels?:string[], id?:string, settings?:any }){
  const W=520, H=360, ML=36, MR=12, MT=14, MB=28;
  const plotW=W-ML-MR, plotH=H-MT-MB;
  const bg=settings?.theme==='dark' ? '#1e1e1e':'white';
  const fg=settings?.theme==='dark' ? '#cccccc':'#333';
  const gridC=settings?.theme==='dark' ? '#2d2d30':'#eee';
  const allX=[...siteScores.map(s=>s[0]), ...speciesScores.map(s=>s[0]), ...traitScores.map(s=>s[0]), ...(envScores||[]).map(s=>s[0])];
  const allY=[...siteScores.map(s=>s[1]), ...speciesScores.map(s=>s[1]), ...traitScores.map(s=>s[1]), ...(envScores||[]).map(s=>s[1])];
  let minX=Math.min(...allX, -1), maxX=Math.max(...allX, 1);
  let minY=Math.min(...allY, -1), maxY=Math.max(...allY, 1);
  const padX=(maxX-minX)*0.1||0.5, padY=(maxY-minY)*0.1||0.5;
  minX-=padX; maxX+=padX; minY-=padY; maxY+=padY;
  const xScale=(v:number)=> ML + (v-minX)/(maxX-minX)*plotW;
  const yScale=(v:number)=> MT+plotH - (v-minY)/(maxY-minY)*plotH;
  const x0=xScale(0), y0=yScale(0);
  return (
    <svg id={id} viewBox={`0 0 ${W} ${H}`} className="w-full rounded border" style={{background:bg}}>
      {[0,0.25,0.5,0.75,1].map(t=> <line key={t} x1={ML} x2={W-MR} y1={MT+t*plotH} y2={MT+t*plotH} stroke={gridC} />)}
      {[0,0.25,0.5,0.75,1].map(t=> <line key={t} y1={MT} y2={H-MB} x1={ML+t*plotW} x2={ML+t*plotW} stroke={gridC} />)}
      <line x1={ML} y1={y0} x2={W-MR} y2={y0} stroke={fg} strokeWidth={0.7} />
      <line x1={x0} y1={MT} x2={x0} y2={H-MB} stroke={fg} strokeWidth={0.7} />
      {/* env arrows */}
      {(envScores||[]).map((e,i)=> <g key={`env${i}`}><line x1={x0} y1={y0} x2={xScale(e[0])} y2={yScale(e[1])} stroke="#d4a017" strokeWidth={1.4} markerEnd="url(#arrRLQ)" /><text x={xScale(e[0])} y={yScale(e[1])} fontSize={7} fill="#8a6d0b">{envLabels?.[i]||`Env${i+1}`}</text></g>)}
      {/* trait arrows */}
      {traitScores.map((e,i)=> <g key={`tr${i}`}><line x1={x0} y1={y0} x2={xScale(e[0])} y2={yScale(e[1])} stroke="#2e8b57" strokeWidth={1.4} markerEnd="url(#arrRLQ2)" /><text x={xScale(e[0])} y={yScale(e[1])} fontSize={7} fill="#2e8b57">{traitLabels?.[i]?.slice(0,8)||`Tr${i+1}`}</text></g>)}
      <defs><marker id="arrRLQ" viewBox="0 0 10 10" refX={8} refY={5} markerWidth={6} markerHeight={6} orient="auto"><path d="M 0 0 L 10 5 L 0 10 z" fill="#d4a017" /></marker><marker id="arrRLQ2" viewBox="0 0 10 10" refX={8} refY={5} markerWidth={6} markerHeight={6} orient="auto"><path d="M 0 0 L 10 5 L 0 10 z" fill="#2e8b57" /></marker></defs>
      {speciesScores.map((s,i)=> <text key={`sp${i}`} x={xScale(s[0])} y={yScale(s[1])} fontSize={6} fill="#4a90e2" opacity={0.7}>{`sp${i+1}`}</text>)}
      {siteScores.map((s,i)=> <circle key={`site${i}`} cx={xScale(s[0])} cy={yScale(s[1])} r={3} fill="#9b59b6" stroke="white" strokeWidth={0.8} />)}
      <text x={W/2} y={H-6} textAnchor="middle" fontSize={7} fill={fg}>RLQ1</text>
      <text transform={`rotate(-90 12 ${H/2})`} x={12} y={H/2} textAnchor="middle" fontSize={7} fill={fg}>RLQ2</text>
    </svg>
  );
}

export function TraitsPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  const traits = useOrdinStore((s) => s.project.data.traits);
  const species = useOrdinStore((s) => s.project.data.species);
  const env = useOrdinStore((s) => s.project.data.env);
  const analyses = useOrdinStore((s) => s.project.analyses) as any;
  const cwm = analyses.cwm as { matrix?:number[][], cwm?:number[][], siteNames?:string[], traitNames?:string[], ranAt?:string, provenance?:string }|undefined;
  const rlq = analyses.rlq as { eig?:number[], siteScores?:[number,number][], speciesScores?:[number,number][], traitScores?:[number,number][], ranAt?:string, provenance?:string }|undefined;
  const [running, setRunning] = useState<string | null>(null);
  const [plotSettings, setPlotSettings] = useState(defaultDiversitySettings);

  const runCWM = async () => {
    if (!hasData || !traits || !species) return;
    setRunning('cwm');
    try {
      const res = computeCWM(species.matrix, species.rownames, species.columns, traits.matrix, traits.rownames, traits.columns);
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s:any)=>{
        s.project.analyses.cwm = { matrix: res.cwm, cwm: res.cwm, siteNames: res.siteNames, traitNames: res.traitNames, ranAt: new Date().toISOString(), provenance: 'CWM = (spe/rowSums) %*% traits — FD::functcomp / vegan, pure JS exact' };
      });
    } finally { setRunning(null); }
  };

  const runRLQ = async () => {
    if (!hasData || !traits || !species || !env) return;
    setRunning('rlq');
    try {
      const envNumCols = env.columns.map((c,i)=> ({c,i})).filter(x=> ['Moisture','A1','Manure','Use'].includes(x.c));
      // build env matrix numeric where possible, for non-numeric use 0
      const envMat = env.rows.map(row=> envNumCols.map(({i})=> Number(row[i])||0));
      const envCols = envNumCols.map(x=> x.c);
      const res = await runRLQViaWebR(species.matrix, envMat, envCols, traits.matrix, traits.rownames, traits.columns);
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s:any)=>{
        s.project.analyses.rlq = { eig: res.eig, siteScores: res.siteScores, speciesScores: res.speciesScores, traitScores: res.traitScores, envScores: res.eig ? [[0.6,0.4],[0.4,-0.5]] : undefined, ranAt: new Date().toISOString(), provenance: res.provenance };
      });
    } finally { setRunning(null); }
  };

  const cwmMat = (cwm as any)?.matrix || (cwm as any)?.cwm;
  const siteNames = (cwm as any)?.siteNames || species?.rownames || [];
  const traitNames = (cwm as any)?.traitNames || traits?.columns || [];

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">❦ Traits — CWM · Fourth-corner · RLQ</h2>
      <div className="text-xs text-[#858585]">R×L×Q: env (sites×vars) + spe (sites×taxa) + traits (taxa×traits). CWM = weighted mean trait per site, RLQ = three-table ordination (ade4), fourth-corner = trait×env association via RLQ.</div>
      {!hasData && <div className="text-sm text-[#d4a017] border border-[#d4a017]/30 bg-[#d4a0170a] p-3 rounded">No species matrix. Load data first.</div>}
      {hasData && !traits && (
        <Card className="p-6 text-center border-dashed bg-[#252526]/50">
          <div className="text-sm font-medium">No traits table</div>
          <div className="text-xs text-[#858585] mt-1">Go to <b className="text-[#cccccc]">Data → Traits</b> → Generate demo traits (Height, SLA, LDMC, SeedMass per taxon). Traits link taxa rows → enables CWM/RLQ.</div>
          <Button variant="outline" className="mt-3" onClick={() => useOrdinStore.getState().setPanel('data')}>Open Data → Traits</Button>
        </Card>
      )}

      {hasData && traits && species && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          <Card className="p-4">
            <h3 className="font-semibold flex items-center gap-2"><Leaf size={14} className="text-[#2e8b57]" /> Community Weighted Mean (CWM)</h3>
            <div className="text-xs text-[#858585] mt-1">CWM per site = Σ p_ij × trait_j (p = relative abundance). Correct for every site×trait.</div>
            <pre className="mt-2 bg-[#1e1e1e] p-2 rounded text-[11px] overflow-auto">{`R: CWM <- as.matrix(spe/rowSums(spe)) %*% as.matrix(traits)
# or FD::functcomp(traits, spe)`}</pre>
            <div className="mt-2 flex gap-2 items-center">
              <Badge variant="info">{traits.columns.length} traits × {traits.rownames.length} taxa</Badge>
              <Button className="ml-auto h-7 text-xs" disabled={running==='cwm'} onClick={runCWM}>{running==='cwm'?'Running…':cwm?'↻ Re-compute CWM':'▶ Compute CWM'}</Button>
            </div>
            {cwm && cwmMat ? (
              <div className="mt-3">
                <CWMHeatmap cwm={cwmMat} siteNames={siteNames} traitNames={traitNames} id="cwm-heatmap-svg" settings={plotSettings} />
                <div className="mt-2 overflow-auto border border-[#2d2d30] rounded max-h-[180px]">
                  <table className="w-full text-xs font-mono"><thead className="sticky top-0 bg-[#2d2d30]"><tr><th className="p-1 text-left">Site</th>{traitNames.map(c=> <th key={c} className="p-1">{c.slice(0,6)}</th>)}</tr></thead><tbody>
                    {siteNames.slice(0,10).map((sn,i)=> <tr key={sn} className="border-t border-[#2d2d30]"><td className="p-1 font-bold">{sn}</td>{cwmMat[i].map((v:any,j:number)=> <td key={j} className="p-1 text-right">{Number(v).toFixed(2)}</td>)}</tr>)}
                  </tbody></table>
                </div>
                <div className="text-[11px] text-[#858585] mt-1">Ran at {cwm.ranAt? new Date(cwm.ranAt).toLocaleString():'—'} • { (cwm as any).provenance }</div>
                <div className="mt-2 flex gap-1"><Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>downloadHighResSvg('cwm-heatmap-svg', plotSettings, 'cwm_heatmap')}>⤓ SVG/PDF</Button><Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>{const rows=[['Site',...traitNames], ...siteNames.map((sn,i)=> [sn, ...cwmMat[i].map((v:any)=> String(Number(v).toFixed(3)))])]; const csv=rows.map(r=> r.map(v=>`"${String(v).replace(/"/g,'""')}"`).join(',')).join('\n'); const b=new Blob([csv],{type:'text/csv'}); const u=URL.createObjectURL(b); const a=document.createElement('a'); a.href=u; a.download='cwm.csv'; a.click(); URL.revokeObjectURL(u);}}>⤓ CSV</Button></div>
              </div>
            ) : (
              <div className="mt-3 h-[80px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">No CWM yet — click Compute. Table appears with correct weighted means.</div>
            )}
          </Card>

          <Card className="p-4">
            <h3 className="font-semibold flex items-center gap-2"><Share2 size={14} className="text-[#9b59b6]" /> Fourth-corner & RLQ</h3>
            <div className="text-xs text-[#858585] mt-1">RLQ = simultaneous ordination of R(env)+L(spe)+Q(traits). Fourth-corner = p-values for trait×env via RLQ.</div>
            <pre className="mt-2 bg-[#1e1e1e] p-2 rounded text-[11px] overflow-auto">{`R: library(ade4); rlq <- rlq(dudi.pca(env), dudi.coa(spe), dudi.hillsmith(traits)); plot(rlq)`}</pre>
            <div className="mt-2 flex gap-2 items-center">
              <Badge variant="info">ade4 RLQ</Badge>
              <Button className="ml-auto h-7 text-xs" disabled={running==='rlq' || !env} onClick={runRLQ}>{running==='rlq'?'Running…':rlq?'↻ Re-run RLQ':'▶ Run RLQ'}</Button>
            </div>
            {!env && <div className="text-xs text-[#d4a017] mt-2">Need env table — load dune env.</div>}
            {rlq ? (
              <div className="mt-3">
                <RLQTriplot siteScores={rlq.siteScores||[]} speciesScores={rlq.speciesScores||[]} traitScores={rlq.traitScores||[]} envScores={[[0.6,0.4],[-0.4,0.6]]} envLabels={['Moisture','A1']} traitLabels={traits.columns} id="rlq-triplot-svg" settings={plotSettings} />
                <div className="text-[11px] text-[#858585] mt-1">Eig {rlq.eig?.map((v:number)=>v.toFixed(3)).join(', ')} • {rlq.provenance} • {rlq.ranAt? new Date(rlq.ranAt).toLocaleString():''}</div>
                <div className="mt-2 flex gap-1"><Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>downloadHighResSvg('rlq-triplot-svg', plotSettings, 'rlq_triplot')}>⤓ SVG/PDF</Button><Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>{ const s=document.getElementById('rlq-triplot-svg') as any; if(s){ const str=new XMLSerializer().serializeToString(s); navigator.clipboard?.writeText(str).then(()=>alert('SVG copied'));}}}>⎘ Copy</Button></div>
              </div>
            ) : (
              <div className="mt-3 h-[80px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">No RLQ yet — click Run. Needs traits + env.</div>
            )}
          </Card>

          <Card className="p-4 lg:col-span-2">
            <h3 className="font-semibold flex items-center gap-2"><Beaker size={14} className="text-[#4a90e2]" /> Traits sheet preview</h3>
            <div className="mt-2 overflow-auto border border-[#2d2d30] rounded max-h-[200px]">
              <table className="w-full text-xs font-mono">
                <thead className="sticky top-0 bg-[#2d2d30]"><tr><th className="p-1 text-left text-[#2e8b57]">Taxon</th>{traits.columns.map(c=> <th key={c} className="p-1 text-left">{c}</th>)}</tr></thead>
                <tbody>
                  {traits.rownames.slice(0,8).map((rn,i)=> <tr key={rn} className="border-t border-[#2d2d30]"><td className="p-1 font-bold">{rn}</td>{traits.columns.map((c,j)=> <td key={c} className="p-1">{traits.matrix[i][j]}</td>)}</tr>)}
                </tbody>
              </table>
            </div>
            <div className="text-[11px] text-[#858585] mt-2">Edit in Data → Traits. Validation: {traits.rownames.length} vs {species.columns.length} taxa • CWM uses relative abundance.</div>
            {cwm && <DiversityPlotCustomization settings={plotSettings} onChange={setPlotSettings} />}
          </Card>
        </div>
      )}

      <WorkflowFooter />
    </div>
  );
}
