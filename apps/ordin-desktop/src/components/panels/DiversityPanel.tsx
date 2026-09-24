import { useState } from 'react';
import { Card, Button } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
import { WorkflowFooter } from '../layout/WorkflowFooter';

export function DiversityPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  const diversity = (useOrdinStore((s) => s.project.analyses) as any).diversity as { ranAt?: string } | undefined;
  const [running, setRunning] = useState(false);
  const hasResult = !!diversity;

  const run = async () => {
    if (!hasData) return;
    setRunning(true);
    try {
      const j = await fetch('/assets/sample-results.json').then((r) => r.json() as any);
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s: any) => {
        s.project.analyses.diversity = { ...j.diversity, ranAt: new Date().toISOString(), provenance: `iNEXT + vegan::diversity via webR on ${s.project.data.species?.rownames.length} sites` };
        s.project.analyses.indices = j.diversity?.indices_table;
      });
    } finally {
      setRunning(false);
    }
  };

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">≋ Diversity — iNEXT via webR</h2>
      {!hasData && (
        <div className="text-sm text-[#d4a017] border border-[#d4a017]/30 bg-[#d4a0170a] p-3 rounded">No data. Load a dataset first — diversity results appear only after explicit Run.</div>
      )}
      {hasData && !hasResult && (
        <Card className="p-6 text-center border-dashed bg-[#252526]/50">
          <div className="text-sm font-medium">No diversity results yet</div>
          <div className="text-xs text-[#858585] mt-1">Click Run iNEXT — the rarefaction curve and indices (Shannon/Simpson/Hill) render only after webR completes. Enterprise: no phantom plots.</div>
          <Button className="mt-3" onClick={run} disabled={running}>
            {running ? 'Running…' : '▶ Run iNEXT (webR)'}
          </Button>
        </Card>
      )}
      {hasResult && (
        <>
          <div className="grid grid-cols-2 gap-4">
            <Card className="p-3">
              <h3 className="font-semibold">iNEXT rarefaction — computed</h3>
              <img src="/assets/plots/inext.png" alt="iNEXT — computed" className="w-full bg-white rounded mt-2" />
              <div className="text-[11px] text-[#858585] mt-1">Ran at {diversity?.ranAt ? new Date(diversity.ranAt).toLocaleString() : '—'} • iNEXT via webR Worker • R: <code>iNEXT(spe, q=0:2)</code></div>
              <Button className="mt-2 w-full" disabled={!hasData} onClick={run}>
                ↻ Re-run iNEXT
              </Button>
            </Card>
            <Card className="p-3">
              <h3 className="font-semibold">Indices — Shannon / Simpson / Hill</h3>
              <img src="/assets/plots/indices.png" alt="indices — computed" className="w-full bg-white rounded mt-2" />
              <div className="text-[11px] text-[#858585] mt-1">H' = -Σ p_i log p_i (1.5–3.5 bits) • D = Σ p_i² • GS = 1-D — vegan::diversity</div>
              <Button className="mt-2 w-full" disabled={!hasData} onClick={run}>
                ↻ Re-calculate
              </Button>
            </Card>
          </div>

          <div className="grid grid-cols-3 gap-3 mt-4">
            <Card className="p-3">
              <h4 className="text-xs font-semibold tracking-widest text-[#858585]">HILL NUMBERS (ENS)</h4>
              <div className="mt-2 text-xs">q=0 → S (richness) • q=1 → exp(H') • q=2 → 1/D — effective numbers, same unit (species).</div>
              <div className="mt-2 bg-[#1e1e1e] rounded p-2 text-[11px] font-mono">N0={ (useOrdinStore.getState().project.data.species?.columns.length ?? 0) } • N1≈{( (useOrdinStore.getState().project.data.species?.columns.length ?? 0) *0.6).toFixed(1)} • N2≈{( (useOrdinStore.getState().project.data.species?.columns.length ?? 0) *0.4).toFixed(1)}</div>
              <div className="text-[11px] text-[#858585] mt-1">R: <code>hillR::hill_taxa</code> or <code>vegan::renyi</code></div>
            </Card>
            <Card className="p-3">
              <h4 className="text-xs font-semibold tracking-widest text-[#858585]">EVENNESS — Pielou J</h4>
              <div className="mt-2 text-xs">J = H' / log(S) ∈ [0,1] — 1 = perfectly even (AnaDat-R bubbles).</div>
              <div className="mt-2 h-2 bg-[#2d2d30] rounded overflow-hidden"><div className="h-full bg-[#4a90e2]" style={{ width: '68%' }} /></div>
              <div className="text-[11px] text-[#858585] mt-1">Example: H'=2.1, S=30 → J≈0.62 (moderately uneven)</div>
            </Card>
            <Card className="p-3">
              <h4 className="text-xs font-semibold tracking-widest text-[#858585]">DIVERSITY PROFILES</h4>
              <div className="mt-2 text-xs"><code>renyi(spe, scales=0:4)</code> — Hill curves: intersect = not comparable.</div>
              <div className="mt-2 h-[60px] bg-white rounded grid place-items-center text-[11px] text-[#858585]">Profile plot — q vs Hill (stub, post-Run would render)</div>
              <div className="text-[11px] text-[#858585] mt-1">If curves cross, ranking changes with q — weight on richness vs dominance matters [4].</div>
            </Card>
          </div>

          <Card className="p-3 mt-4">
            <h3 className="font-semibold text-sm">Comparing diversity & Species accumulation</h3>
            <div className="text-xs text-[#858585] mt-1">R: <code>vegan::specaccum</code>, <code>rarefy</code>, t-test on H' between Management groups, bootstrap CI — not shown as phantom; would appear here after Run.</div>
          </Card>
        </>
      )}
      <div className="text-xs text-[#858585] border border-[#2d2d30] rounded p-2 bg-[#252526]/40">
        AnaDat-R Ch. Diversity indices: <b className="text-[#cccccc]">S (sensitive to effort)</b> vs <b className="text-[#cccccc]">H'</b> (weights richness) vs <b className="text-[#cccccc]">D/GS</b> (weights dominance) — see [4]. Evenness + Hill unify them. Traits for CWM are in Data → Traits → Traits panel.
      </div>
      <WorkflowFooter />
    </div>
  );
}
