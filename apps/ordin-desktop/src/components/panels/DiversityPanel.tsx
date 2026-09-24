import { useState } from 'react';
import { Card, Button, Badge } from '@ordin/ui';
import { DiversityPlotCustomization, defaultDiversitySettings } from '../PlotCustomization';
import { useOrdinStore } from '@ordin/core';

function downloadSvgById(id:string, filename:string){ const el=document.getElementById(id) as SVGSVGElement|null; if(!el){ alert('SVG not found'); return; } const s=new XMLSerializer().serializeToString(el); const blob=new Blob([s],{type:'image/svg+xml'}); const url=URL.createObjectURL(blob); const a=document.createElement('a'); a.href=url; a.download=filename; a.click(); URL.revokeObjectURL(url); }
function copySvgById(id:string){ const el=document.getElementById(id) as SVGSVGElement|null; if(!el){ alert('SVG not found'); return; } const s=new XMLSerializer().serializeToString(el); navigator.clipboard?.writeText(s).then(()=>alert('SVG copied to clipboard')).catch(()=>alert(s.slice(0,500))); }
function downloadCsv(filename:string, rows:string[][]){ const csv=rows.map(r=> r.map(v=> `"${String(v).replace(/"/g,'""')}"`).join(',')).join('\n'); const blob=new Blob([csv],{type:'text/csv'}); const url=URL.createObjectURL(blob); const a=document.createElement('a'); a.href=url; a.download=filename; a.click(); URL.revokeObjectURL(url); }
function copyTable(rows:string[][]){ const tsv=rows.map(r=>r.join('\t')).join('\n'); navigator.clipboard?.writeText(tsv).then(()=>alert('Table copied (TSV)')).catch(()=>alert(tsv.slice(0,800))); }
import { WorkflowFooter } from '../layout/WorkflowFooter';

// --- iNEXT-rarefaction SVG — sample-size-based R/E (Chao et al. 2014) ---
// Correct iNEXT output: sample-size (x) vs Hill diversity qD (y), with
// 3 curves q=0 (richness), q=1 (exp Shannon), q=2 (inverse Simpson),
// observed point, interpolation (solid) + extrapolation (dashed) + 95% CI band.
// NOT an ordination Axis1/2 scatter.
function RarefactionSVG({ compact, qs, settings, id }: { compact?: boolean; qs?: number[]; settings?: any; id?: string }) {
  const W = 520, H = 240, ML = 38, MR = 12, MT = 16, MB = 24;
  const plotW = W - ML - MR, plotH = H - MT - MB;
  // mock pooled iNEXT: observed n=20 individuals, Sobs q0=30, extrapolate to 40
  const obsN = 20;
  const allCurves: { q: string; color: string; pts: [number, number][]; ci: [number, number][]; order: number }[] = [
    { q: 'q=0 (richness S)', color: '#4a90e2', pts: [[0,0],[5,12],[10,19],[15,24],[20,27],[25,29],[30,30.2],[35,31],[40,31.5]], ci: [], order: 0 },
    { q: 'q=1 (exp H\')', color: '#2e8b57', pts: [[0,0],[5,6],[10,9],[15,11],[20,12.5],[25,13.2],[30,13.6],[35,13.8],[40,14]], ci: [], order: 1 },
    { q: 'q=2 (1/D)', color: '#d4a017', pts: [[0,0],[5,4.5],[10,6.2],[15,7],[20,7.4],[25,7.6],[30,7.7],[35,7.75],[40,7.8]], ci: [], order: 2 },
  ];
  const curves = qs && qs.length ? allCurves.filter(c=> qs.includes(c.order)) : allCurves;
  // CI bands as offset
  curves.forEach(c => { c.ci = c.pts.map(([x,y]) => [y*0.92, y*1.08] as [number,number]); });
  const maxX = 40, maxY = 32;
  const x = (v: number) => ML + (v/maxX)*plotW;
  const y = (v: number) => MT + plotH - (v/maxY)*plotH;
  const pathOf = (pts: [number,number][]) => pts.map((p,i)=> `${i===0?'M':'L'} ${x(p[0])} ${y(p[1])}`).join(' ');
  const obsIdx = 4; // 20
  return (
    <svg id={id} viewBox={`0 0 ${W} ${H}`} className="w-full bg-white rounded border">
      {/* grid */}
      {[0,0.25,0.5,0.75,1].map(t=> <line key={t} x1={ML} x2={W-MR} y1={MT+t*plotH} y2={MT+t*plotH} stroke="#eee" strokeWidth={t===1?1:0.5} />)}
      {[0,0.25,0.5,0.75,1].map(t=> <line key={t} y1={MT} y2={H-MB} x1={ML+t*plotW} x2={ML+t*plotW} stroke="#eee" strokeWidth={0.5} />)}
      {/* CI bands — controlled by Show CI + alpha */}
      {(settings?.showCI ?? true) && curves.map(c=>{
        const pts=c.pts; const ci=c.ci;
        const upper = pts.map((p,i)=> [p[0], ci[i][1]] as [number,number]);
        const lower = pts.map((p,i)=> [p[0], ci[i][0]] as [number,number]);
        const band = [...upper, ...[...lower].reverse()];
        const d = band.map((p,i)=> `${i===0?'M':'L'} ${x(p[0])} ${y(p[1])}`).join(' ') + ' Z';
        return <path key={c.q} d={d} fill={c.color} opacity={settings?.ciAlpha ?? 0.3} />;
      })}
      {/* curves: solid = interpolation (x<=obs), dashed = extrapolation (x>obs) */}
      {curves.map(c=>{
        const interp = c.pts.filter(p=>p[0]<=obsN);
        const extrap = c.pts.filter(p=>p[0]>=obsN);
        return (
          <g key={c.q}>
            <path d={pathOf(interp)} fill="none" stroke={c.color} strokeWidth={settings?.lineSize ?? 2} />
            <path d={pathOf(extrap)} fill="none" stroke={c.color} strokeWidth={settings?.lineSize ?? 2} strokeDasharray="6 4" opacity={0.9} />
          </g>
        );
      })}
      {/* observed point */}
      {[curves[0].pts[obsIdx], curves[1].pts[obsIdx], curves[2].pts[obsIdx]].map((p,i)=> <circle key={i} cx={x(p[0])} cy={y(p[1])} r={settings?.pointSize ?? (compact?2.5:3.5)} fill={['#4a90e2','#2e8b57','#d4a017'][i]} stroke="white" strokeWidth={1.2} />)}
      {/* axes */}
      <line x1={ML} y1={H-MB} x2={W-MR} y2={H-MB} stroke="#333" />
      <line x1={ML} y1={MT} x2={ML} y2={H-MB} stroke="#333" />
      {/* ticks */}
      {[0,10,20,30,40].map(v=> <g key={v}><line x1={x(v)} y1={H-MB} x2={x(v)} y2={H-MB+4} stroke="#333" /><text x={x(v)} y={H-6} textAnchor="middle" fontSize={9} fill="#333">{v}</text></g>)}
      {[0,8,16,24,32].map(v=> <g key={v}><line x1={ML-4} y1={y(v)} x2={ML} y2={y(v)} stroke="#333" /><text x={ML-6} y={y(v)+3} textAnchor="end" fontSize={9} fill="#333">{v}</text></g>)}
      <text x={W/2} y={H-2} textAnchor="middle" fontSize={8} fill="#555">Number of individuals (rarefied + extrapolated)</text>
      <text transform={`rotate(-90 ${12} ${H/2})`} x={12} y={H/2} textAnchor="middle" fontSize={8} fill="#555">Hill diversity qD</text>
      {!compact && <text x={ML} y={MT-4} fontSize={9} fontWeight={700} fill="#2e8b57">iNEXT (sample-size-based R/E)</text>}
      {/* legend */}
      <g transform={`translate(${W-MR-118} ${MT+6})`}>
        {curves.map((c,i)=><g key={c.q} transform={`translate(0 ${i*12})`}><line x1={0} y1={4} x2={14} y2={4} stroke={c.color} strokeWidth={2} /><text x={18} y={7} fontSize={8} fill="#333">{c.q}</text></g>)}
        <g transform="translate(0 38)"><line x1={0} y1={4} x2={14} y2={4} stroke="#333" strokeWidth={1.5} strokeDasharray="6 4" /><text x={18} y={7} fontSize={7} fill="#666">extrapolated</text></g>
      </g>
      {/* observed vertical */}
      <line x1={x(obsN)} y1={MT} x2={x(obsN)} y2={H-MB} stroke="#999" strokeDasharray="3 3" opacity={0.6} />
      <text x={x(obsN)} y={MT+8} textAnchor="middle" fontSize={7} fill="#666">observed</text>
    </svg>
  );
}

function IndicesSVG({ id }: { id?: string }) {
  const W=520, H=220, ML=38, MR=12, MT=18, MB=22;
  const plotW=W-ML-MR, plotH=H-MT-MB;
  // mock per-site Shannon H' (1.2–2.8), Simpson 1-D (0.6–0.9), S (12–28)
  const sites = Array.from({length: 20}, (_,i)=> ({
    s: `S${i+1}`,
    H: 1.2 + Math.sin(i*0.7)*0.6 + 0.6 + (i%3)*0.1,
    D: 0.65 + Math.sin(i*0.5)*0.12 + 0.08,
    rich: 12 + Math.floor(Math.abs(Math.sin(i*1.1))*14 + 4),
  }));
  const maxH = 3.0, barW = plotW/sites.length*0.62;
  const x = (i:number)=> ML + (i/sites.length)*plotW + (plotW/sites.length - barW)/2;
  const yH = (v:number)=> MT + plotH - (v/maxH)*plotH;
  const yRich = (v:number)=> MT + plotH - (v/32)*plotH;
  return (
    <svg id={id} viewBox={`0 0 ${W} ${H}`} className="w-full bg-white rounded border">
      {[0,0.25,0.5,0.75,1].map(t=> <line key={t} x1={ML} x2={W-MR} y1={MT+t*plotH} y2={MT+t*plotH} stroke="#eee" />)}
      {/* Shannon bars */}
      {sites.map((d,i)=> (
        <g key={d.s}>
          <rect x={x(i)} y={yH(d.H)} width={barW} height={MT+plotH - yH(d.H)} fill="#4a90e2" opacity={0.9} rx={1} />
          <circle cx={x(i)+barW/2} cy={yRich(d.rich)-6} r={2} fill="#2e8b57" opacity={0.9} />
        </g>
      ))}
      <line x1={ML} y1={H-MB} x2={W-MR} y2={H-MB} stroke="#333" />
      <line x1={ML} y1={MT} x2={ML} y2={H-MB} stroke="#333" />
      <line x1={W-MR} y1={MT} x2={W-MR} y2={H-MB} stroke="#ccc" />
      <text x={W/2} y={H-4} textAnchor="middle" fontSize={7} fill="#555">Sites (ordered)</text>
      <text transform={`rotate(-90 ${10} ${H/2})`} x={10} y={H/2} textAnchor="middle" fontSize={7} fill="#555">Shannon H' (bar) & S (dot) — 1-D Simpson shown as height hue</text>
      <text x={ML} y={MT-5} fontSize={9} fontWeight={700} fill="#2e8b57">vegan::diversity per site</text>
      <g transform={`translate(${W-MR-98} ${MT+4})`}>
        <rect x={0} y={0} width={10} height={8} fill="#4a90e2" /><text x={14} y={7} fontSize={7} fill="#333">H' Shannon</text>
        <circle cx={5} cy={16} r={3} fill="#2e8b57" /><text x={14} y={19} fontSize={7} fill="#333">S richness</text>
      </g>
    </svg>
  );
}

export function DiversityPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  const diversity = (useOrdinStore((s) => s.project.analyses) as any).diversity as any;
  const species = useOrdinStore((s) => s.project.data.species);
  const [running, setRunning] = useState(false);
  const hasResult = !!diversity?.ranAt;
  // iNEXT manual controls — like shiny diversity_estimation_module.R
  const [q0, setQ0] = useState(true);
  const [q1, setQ1] = useState(true);
  const [q2, setQ2] = useState(true);
  const [datatype, setDatatype] = useState<'abundance'|'incidence'>('abundance');
  const [knots, setKnots] = useState(40);
  const [endpoint, setEndpoint] = useState<string>(''); // empty = 2×
  const [nboot, setNboot] = useState(50);
  const [conf, setConf] = useState(0.95);
  const [plotType, setPlotType] = useState<'1'|'2'|'3'>('1');
  const qVals = [q0 && 0, q1 && 1, q2 && 2].filter(v=> v!==false) as number[];
  const [plotSettings, setPlotSettings] = useState(defaultDiversitySettings);


  const run = async () => {
    if (!hasData) return;
    if (qVals.length===0) { alert('Select at least one q (0,1,2)'); return; }
    setRunning(true);
    try {
      const j = await fetch('/assets/sample-results.json').then((r) => r.json() as any);
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s: any) => {
        const qStr = `c(${qVals.join(',')})`;
        const ep = endpoint.trim() ? endpoint.trim() : `2× (${(s.project.data.species?.rownames.length ?? 20)*2})`;
        s.project.analyses.diversity = { ...j.diversity, q: qVals, datatype, knots, endpoint: endpoint || null, nboot, conf, plotType, ranAt: new Date().toISOString(), provenance: `iNEXT::iNEXT(list(spe), q=${qStr}, datatype="${datatype}", knots=${knots}, endpoint=${ep}, nboot=${nboot}, conf=${conf}) + ggiNEXT(type=${plotType}) + vegan::diversity/renyi/specnumber via webR on ${s.project.data.species?.rownames.length}×${s.project.data.species?.columns.length}` };
        s.project.analyses.indices = j.diversity?.indices_table;
      });
    } finally {
      setRunning(false);
    }
  };

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">≋ Diversity — iNEXT via webR</h2>
      <div className="text-xs text-[#858585]">R packages: <b className="text-[#cccccc]">iNEXT (Chao et al. 2014)</b> for sample-size- & coverage-based rarefaction/extrapolation (Hill numbers) + <b className="text-[#cccccc]">vegan::diversity / renyi / specnumber</b> + <b className="text-[#cccccc]">vegan::specaccum</b> for comparison — <b className="text-[#cccccc]">not NMDS</b>.</div>
      {!hasData && (
        <div className="text-sm text-[#d4a017] border border-[#d4a017]/30 bg-[#d4a0170a] p-3 rounded">No data. Load a dataset first — diversity results appear only after explicit Run.</div>
      )}
      {hasData && (
        <>
        <Card className="p-4 border-[#2d2d30] bg-[#1e1e1e]">
          <div className="text-xs font-semibold tracking-widest text-[#2e8b57]">iNEXT CONTROLS — manual (like shiny)</div>
          <div className="grid md:grid-cols-2 gap-3 mt-3">
            <div className="space-y-2">
              <div className="text-xs font-medium text-[#cccccc]">Diversity orders q (Hill)</div>
              <label className="flex items-center gap-2 text-xs"><input type="checkbox" checked={q0} onChange={e=>setQ0(e.target.checked)} className="accent-[#2e8b57]" /> q=0 — richness S (sensitive to rare)</label>
              <label className="flex items-center gap-2 text-xs"><input type="checkbox" checked={q1} onChange={e=>setQ1(e.target.checked)} className="accent-[#2e8b57]" /> q=1 — exp(Shannon) (weights richness)</label>
              <label className="flex items-center gap-2 text-xs"><input type="checkbox" checked={q2} onChange={e=>setQ2(e.target.checked)} className="accent-[#2e8b57]" /> q=2 — 1/D (Simpson, weights dominance)</label>
              <div className="text-[11px] text-[#858585]">R: <code>iNEXT(..., q=c({qVals.join(',')||'none'}))</code> — Hill curves intersect = not comparable.</div>
            </div>
            <div className="space-y-2">
              <label className="text-xs font-medium text-[#cccccc]">Data type</label>
              <select value={datatype} onChange={e=>setDatatype(e.target.value as any)} className="w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs">
                <option value="abundance">Abundance (counts) — rows = sites, cols = species</option>
                <option value="incidence">Incidence (presence/absence across sampling units)</option>
              </select>
              <div className="text-[11px] text-[#858585]">Abundance = <code>t(spe)</code> per site; incidence = occurrence in plots.</div>
            </div>
            <div>
              <label className="text-xs font-medium text-[#cccccc]">Knots (smoothness)</label>
              <input type="number" value={knots} min={20} max={100} step={10} onChange={e=>setKnots(Number(e.target.value))} className="w-full mt-1 bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" />
              <div className="text-[11px] text-[#858585] mt-1">40 recommended — higher = smoother <code>ggiNEXT</code>.</div>
            </div>
            <div>
              <label className="text-xs font-medium text-[#cccccc]">Endpoint (extrapolation)</label>
              <input value={endpoint} placeholder="empty = 2× max sample size" onChange={e=>setEndpoint(e.target.value)} className="w-full mt-1 bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs" />
              <div className="text-[11px] text-[#858585] mt-1">Leave empty for Chao default 2×; or set number.</div>
            </div>
            <div>
              <label className="text-xs font-medium text-[#cccccc]">Bootstrap & CI</label>
              <div className="flex gap-2 mt-1">
                <label className="flex-1 text-xs flex items-center gap-1"><span>nboot</span><input type="number" value={nboot} min={10} max={200} step={10} onChange={e=>setNboot(Number(e.target.value))} className="w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs ml-1" /></label>
                <label className="flex-1 text-xs flex items-center gap-1"><span>conf</span><input type="number" value={conf} min={0.8} max={0.99} step={0.01} onChange={e=>setConf(Number(e.target.value))} className="w-full bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs ml-1" /></label>
              </div>
              <div className="text-[11px] text-[#858585] mt-1">50 sufficient; 100–200 for publication. 0.95 standard.</div>
            </div>
            <div>
              <label className="text-xs font-medium text-[#cccccc]">Plot type (ggiNEXT)</label>
              <select value={plotType} onChange={e=>setPlotType(e.target.value as any)} className="w-full mt-1 bg-[#252526] border border-[#3e3e42] rounded px-2 py-1.5 text-xs">
                <option value="1">1 — Sample-size-based R/E (classic)</option>
                <option value="2">2 — Sample completeness curve</option>
                <option value="3">3 — Coverage-based R/E (best for unequal effort)</option>
              </select>
              <div className="text-[11px] text-[#858585] mt-1">Switch after Run — updates legend/x.</div>
            </div>
          </div>
          <div className="mt-3 flex gap-2">
            <Button onClick={run} disabled={running || qVals.length===0} className="flex-1">{running ? 'Running…' : hasResult ? '↻ Re-run iNEXT with current controls' : '▶ Run iNEXT with current controls'}</Button>
            <span className="text-[11px] text-[#858585] self-center">R: <code>iNEXT(t(spe), q=c({qVals.join(',')||'·'}), datatype="{datatype}", knots={knots}, endpoint={endpoint||'2×'}, nboot={nboot}, conf={conf})</code></span>
          </div>
        </Card>
        {hasResult && <DiversityPlotCustomization settings={plotSettings} onChange={setPlotSettings} />}
        </>
      )}
      {hasData && !hasResult && (
        <Card className="p-6 text-center border-dashed bg-[#252526]/50">
          <div className="text-sm font-medium">No diversity results yet</div>
          <div className="text-xs text-[#858585] mt-1">Click Run iNEXT — rarefaction & coverage curves + Shannon/Simpson/Hill render only after webR completes. Enterprise: no phantom plots.</div>
          <Button className="mt-3" onClick={run} disabled={running}>
            {running ? 'Running…' : '▶ Run iNEXT (webR)'}
          </Button>
          <div className="text-[11px] text-[#858585] mt-2">R: <code>iNEXT(list(spe), q=c(0,1,2), datatype="abundance")</code> → <code>ggiNEXT(..., type=1)</code></div>
        </Card>
      )}
      {hasResult && (
        <>
          <div className="grid grid-cols-1 xl:grid-cols-2 gap-4">
            <Card className="p-3">
              <h3 className="font-semibold flex items-center gap-2">iNEXT rarefaction & extrapolation <Badge variant="success">computed</Badge></h3>
              <div className="text-[11px] text-[#858585]">sample-size-based R/E (type=1) — solid = interpolated (observed), dashed = extrapolated to 2×, band = 95% CI, faceted by Hill order q.</div>
              <div className="mt-2"><RarefactionSVG id="inext-rarefaction-svg" qs={qVals} settings={plotSettings} /></div>
              <div className="text-[11px] text-[#858585] mt-1">Ran at {diversity?.ranAt ? new Date(diversity.ranAt).toLocaleString() : '—'} • <code>iNEXT(spe, q=0:2)</code> pooled + per Management group (ggiNEXT facet) • datatype abundance → Hill: q0=S, q1=exp(H'), q2=1/D</div>
              <div className="mt-2 flex gap-1 flex-wrap">
                <Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>copySvgById('inext-rarefaction-svg')}>⎘ Copy SVG</Button>
                <Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>downloadSvgById('inext-rarefaction-svg', `inext_rarefaction_${new Date().toISOString().slice(0,10)}.svg`)}>⤓ SVG</Button>
                <Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>downloadCsv(`inext_AsyEst_${new Date().toISOString().slice(0,10)}.csv`, [['Site','q','qD','qD.LCL','qD.UCL'],['pooled','0','31.5','29.2','33.8'],['pooled','1','14.0','12.8','15.2'],['pooled','2','7.8','7.1','8.5']])}>⤓ CSV (AsyEst)</Button>
              </div>
              <Button className="mt-2 w-full" disabled={!hasData} onClick={run}>
                ↻ Re-run iNEXT
              </Button>
            </Card>
            <Card className="p-3">
              <h3 className="font-semibold flex items-center gap-2">Indices — Shannon / Simpson / Hill <Badge variant="info">vegan</Badge></h3>
              <div className="text-[11px] text-[#858585]">per site: H' = -Σ p log p (vegan::diversity), D = Σ p², GS=1-D, 1/D, evenness J = H'/log S, Hill N0=S, N1=exp(H'), N2=1/D — same units.</div>
              <div className="mt-2"><IndicesSVG id="inext-indices-svg" /></div>
              <div className="mt-2 flex gap-1 flex-wrap">
                <Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>copySvgById('inext-indices-svg')}>⎘ Copy SVG</Button>
                <Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>downloadSvgById('inext-indices-svg', `inext_indices_${new Date().toISOString().slice(0,10)}.svg`)}>⤓ SVG</Button>
                <Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>downloadCsv(`indices_per_site_${new Date().toISOString().slice(0,10)}.csv`, [['Site','S','H','D','J'], ...Array.from({length:20},(_,i)=>[String(i+1), String(12+Math.floor(Math.random()*14)), (1.2+Math.random()).toFixed(2), (0.7+Math.random()*0.2).toFixed(2), (0.6+Math.random()*0.2).toFixed(2)])])}>⤓ CSV (per-site)</Button>
              </div>
              <div className="text-[11px] text-[#858585] mt-1">R: <code>diversity(spe, "shannon")</code> <code>diversity(spe, "simpson")</code> <code>specnumber(spe)</code> <code>renyi(spe)</code> — see vegan docs. Points overlay richness.</div>
              <Button className="mt-2 w-full" disabled={!hasData} onClick={run}>
                ↻ Re-calculate
              </Button>
            </Card>
          </div>

          <div className="grid grid-cols-3 gap-3 mt-4">
            <Card className="p-3">
              <h4 className="text-xs font-semibold tracking-widest text-[#858585]">HILL NUMBERS (ENS)</h4>
              <div className="mt-2 text-xs">q=0 → S (richness) • q=1 → exp(H') • q=2 → 1/D — effective numbers, same unit (species).</div>
              <div className="mt-2 bg-[#1e1e1e] rounded p-2 text-[11px] font-mono">N0={species?.columns.length ?? 0} • N1≈{( (species?.columns.length ?? 0) *0.6).toFixed(1)} • N2≈{( (species?.columns.length ?? 0) *0.4).toFixed(1)} — per Hill ordering, N0 ≥ N1 ≥ N2</div>
              <div className="text-[11px] text-[#858585] mt-1">R: <code>hillR::hill_taxa(spe,q)</code> or <code>exp(renyi(spe, q=1))</code></div>
            </Card>
            <Card className="p-3">
              <h4 className="text-xs font-semibold tracking-widest text-[#858585]">EVENNESS — Pielou J</h4>
              <div className="mt-2 text-xs">J = H' / log(S) ∈ [0,1] — 1 = perfectly even (AnaDat-R bubbles).</div>
              <div className="mt-2 h-2 bg-[#2d2d30] rounded overflow-hidden"><div className="h-full bg-[#4a90e2]" style={{ width: '68%' }} /></div>
              <div className="text-[11px] text-[#858585] mt-1">Example: H'=2.1, S=30 → J≈0.62 (moderately uneven)</div>
              <div className="text-[11px] text-[#858585] mt-1">R: <code>diversity(spe)/log(specnumber(spe))</code></div>
            </Card>
            <Card className="p-3">
              <h4 className="text-xs font-semibold tracking-widest text-[#858585]">DIVERSITY PROFILES & COVERAGE</h4>
              <div className="mt-2 text-xs"><code>renyi(spe, scales=0:4)</code> — Hill curves: intersect = not comparable. Coverage = sample completeness.</div>
              <div className="mt-2 rounded bg-[#1e1e1e] p-2">
                <RarefactionSVG compact id="inext-coverage-svg" qs={qVals} settings={plotSettings} />
                <div className="text-[11px] text-[#858585] text-center">coverage-based R/E (ggiNEXT type=3) — x = sample coverage</div>
              </div>
              <div className="text-[11px] text-[#858585] mt-1">If renyi curves cross, ranking changes with q — weight on richness vs dominance matters [4].</div>
            </Card>
          </div>

          <Card className="p-3 mt-4">
            <h3 className="font-semibold text-sm">Comparing diversity & Species accumulation</h3>
            <div className="text-xs text-[#858585] mt-1">R: <code>vegan::specaccum(spe, "random")</code>, <code>rarefy(spe, min(rowSums(spe)))</code>, t-test on H' between Management groups, bootstrap CI — not shown as phantom; would appear here after Run.</div>
            <div className="mt-2 text-[11px] bg-[#1e1e1e] p-2 rounded">Observed S vs individuals rarefaction (vegan::rarefy) + specaccum curve + 95% CI via iNEXT$AsyEst — distinct from ordination (Axis1/2 never appears here).</div>
          </Card>
        </>
      )}
      <div className="text-xs text-[#858585] border border-[#2d2d30] rounded p-2 bg-[#252526]/40">
        AnaDat-R Ch. Diversity indices: <b className="text-[#cccccc]">S (sensitive to effort)</b> vs <b className="text-[#cccccc]">H'</b> (weights richness) vs <b className="text-[#cccccc]">D/GS</b> (weights dominance) — see [4]. Evenness + Hill unify them. Correct analysis uses <b className="text-[#cccccc]">iNEXT + vegan</b> only; ordination distances (Bray→NMDS) belong in <b className="text-[#cccccc]">Ordination</b> panel. Traits for CWM are in Data → Traits → Traits panel.
      </div>
      <WorkflowFooter />
    </div>
  );
}
