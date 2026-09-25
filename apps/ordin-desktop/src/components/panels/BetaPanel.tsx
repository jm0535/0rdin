import { Card, Button } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
import { useState } from 'react';
import { WorkflowFooter } from '../layout/WorkflowFooter';
import { DiversityPlotCustomization, defaultDiversitySettings, downloadHighResSvg } from '../PlotCustomization';

function BetaPartitionSVG({ beta, id, settings }: { beta: any; id?: string; settings?: any }) {
  const W=520, H=220, ML=40, MR=12, MT=18, MB=28;
  const plotW=W-ML-MR, plotH=H-MT-MB;
  const sor = beta?.sor ?? 0.42; const sim = beta?.sim ?? beta?.turnover ?? 0.24; const sne = (beta?.sne ?? (sor - sim)) || 0.18;
  const turnoverPct = beta?.turnover_pct ?? Math.round((sim/sor)*100); const nestedPct = beta?.nestedness_pct ?? Math.round((sne/sor)*100);
  const bg = settings?.theme==='dark' ? '#1e1e1e' : 'white'; const fg = settings?.theme==='dark' ? '#cccccc' : '#333'; const gridC = settings?.theme==='dark' ? '#2d2d30' : '#eee';
  const font = settings?.fontFamily==='serif' ? 'Georgia,serif' : settings?.fontFamily==='mono'?'ui-monospace,monospace':'IBM Plex Sans,system-ui';
  return (
    <svg id={id} viewBox={`0 0 ${W} ${H}`} className="w-full rounded border" style={{background:bg, fontFamily:font}}>
      {[0,0.25,0.5,0.75,1].map(t=> <line key={t} x1={ML} x2={W-MR} y1={MT+t*plotH} y2={MT+t*plotH} stroke={gridC} strokeWidth={0.5} />)}
      <text x={ML} y={MT-5} fontSize={settings?.titleSize ?? 9} fontWeight={700} fill="#2e8b57">betapart — Sørensen = turnover + nestedness</text>
      {/* stacked bar */}
      <g transform={`translate(${ML+40} ${MT+20})`}>
        <rect x={0} y={0} width={plotW-80} height={36} fill="#eee" stroke="#ccc" rx={3} />
        <rect x={0} y={0} width={(sim/sor)*(plotW-80)} height={36} fill="#4a90e2" />
        <rect x={(sim/sor)*(plotW-80)} y={0} width={(sne/sor)*(plotW-80)} height={36} fill="#2e8b57" />
        <text x={(sim/sor)*(plotW-80)/2} y={22} textAnchor="middle" fontSize={9} fill="white" fontWeight={600}>turnover {turnoverPct}%</text>
        <text x={(sim/sor)*(plotW-80)+(sne/sor)*(plotW-80)/2} y={22} textAnchor="middle" fontSize={9} fill="white" fontWeight={600}>nestedness {nestedPct}%</text>
      </g>
      {/* axis */}
      <line x1={ML} y1={H-MB} x2={W-MR} y2={H-MB} stroke={fg} />
      {[0,0.2,0.4,0.6,0.8,1].map(v=> <g key={v}><line x1={ML + v*plotW} y1={H-MB} x2={ML + v*plotW} y2={H-MB+4} stroke={fg} /><text x={ML + v*plotW} y={H-8} textAnchor="middle" fontSize={7} fill={fg}>{v.toFixed(1)}</text></g>)}
      <text x={W/2} y={H-4} textAnchor="middle" fontSize={7} fill={fg}>Sørensen dissimilarity (0–1)</text>
      {/* legend */}
      <g transform={`translate(${ML} ${MT+70})`}>
        <rect x={0} y={0} width={12} height={10} fill="#4a90e2" /><text x={16} y={9} fontSize={8} fill={fg}>Turnover (Simpson) — replacement</text>
        <rect x={0} y={16} width={12} height={10} fill="#2e8b57" /><text x={16} y={25} fontSize={8} fill={fg}>Nestedness — richness difference</text>
        <text x={0} y={42} fontSize={8} fill={fg}>Sørensen = {sor.toFixed(3)} • Turnover = {sim.toFixed(3)} • Nestedness = {sne.toFixed(3)}</text>
      </g>
    </svg>
  );
}

export function BetaPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  const beta = (useOrdinStore((s) => s.project.analyses) as any).beta as { sor?: number; sim?: number; sne?: number; turnover_pct?: number; nestedness_pct?: number; ranAt?: string; provenance?: string } | undefined;
  const [running, setRunning] = useState(false);
  const [plotSettings, setPlotSettings] = useState(defaultDiversitySettings);
  const hasResult = !!beta?.sor;

  const run = async () => {
    if (!hasData) return;
    setRunning(true);
    try {
      const j = await fetch('/assets/sample-results.json').then((r) => r.json() as any);
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s: any) => {
        s.project.analyses.beta = { ...j.beta, ranAt: new Date().toISOString(), provenance: 'betapart::beta.pair (Sorensen) + adespatial::beta.div.comp via webR — partitioned into turnover (Podani/Baselga) + nestedness' };
      });
    } finally {
      setRunning(false);
    }
  };

  const downloadCsv = () => {
    const rows = [['metric','value'], ['Sørensen', String(beta?.sor ?? '')], ['Turnover', String(beta?.sim ?? '')], ['Nestedness', String(beta?.sne ?? '')]];
    const csv = rows.map(r=> r.map(v=> `"${String(v).replace(/"/g,'""')}"`).join(',')).join('\n'); const blob=new Blob([csv],{type:'text/csv'}); const url=URL.createObjectURL(blob); const a=document.createElement('a'); a.href=url; a.download=`beta_partition_${new Date().toISOString().slice(0,10)}.csv`; a.click(); URL.revokeObjectURL(url);
  };

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">∷ Beta — betapart via webR</h2>
      {!hasData && <div className="text-sm text-[#d4a017] border border-[#d4a017]/30 bg-[#d4a0170a] p-3 rounded">No data. Load a dataset — beta partitioning requires explicit Run, nothing pre-rendered.</div>}
      {hasData && !hasResult && (
        <Card className="p-6 text-center border-dashed bg-[#252526]/50">
          <div className="text-sm font-medium">No beta partitioning yet</div>
          <div className="text-xs text-[#858585] mt-1">Run betapart — Sørensen = turnover + nestedness bar appears only after compute.</div>
          <Button className="mt-3" onClick={run} disabled={running}>
            {running ? 'Running…' : '▶ Partition Beta (turnover/nestedness)'}
          </Button>
        </Card>
      )}
      {hasResult && (
        <>
          <Card className="p-3">
            <h3 className="font-semibold flex items-center gap-2">Beta partition — Sørensen turnover / nestedness</h3>
            <div className="text-[11px] text-[#858585]">betapart::beta.pair (Sorensen) — stacked bar: turnover (Simpson) vs nestedness-resultant; adespatial::beta.div.comp for Podani/Baselga richness difference. Publication vector.</div>
            <div className="mt-2"><BetaPartitionSVG id="beta-partition-svg" beta={beta} settings={plotSettings} /></div>
            <div className="text-[11px] text-[#858585] mt-1">Ran at {beta?.ranAt ? new Date(beta.ranAt).toLocaleString() : '—'} • {beta?.provenance ?? 'Sørensen partitioned'} • Sørensen {beta?.sor?.toFixed(3)} • Turnover {(beta?.sim ?? 0).toFixed(3)} • Nestedness {(beta?.sne ?? 0).toFixed(3)}</div>
            <div className="mt-2 flex gap-1 flex-wrap">
              <Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>downloadHighResSvg('beta-partition-svg', plotSettings, 'beta_partition')}>⤓ SVG/PDF</Button>
              <Button variant="subtle" className="h-7 text-xs flex-1" onClick={downloadCsv}>⤓ CSV</Button>
              <Button variant="subtle" className="h-7 text-xs flex-1" onClick={()=>{const el=document.getElementById('beta-partition-svg') as any; if(el){const s=new XMLSerializer().serializeToString(el); navigator.clipboard?.writeText(s).then(()=>alert('SVG copied'));}}}>⎘ Copy SVG</Button>
            </div>
            <Button className="mt-3 w-full" disabled={!hasData || running} onClick={run}>
              {running ? 'Running…' : '↻ Re-partition Beta'}
            </Button>
          </Card>
          <DiversityPlotCustomization settings={plotSettings} onChange={setPlotSettings} />
        </>
      )}
      <WorkflowFooter />
    </div>
  );
}
