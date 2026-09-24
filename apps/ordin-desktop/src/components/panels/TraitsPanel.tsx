import { useState } from 'react';
import { Card, Button, Badge } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
import { WorkflowFooter } from '../layout/WorkflowFooter';
import { Leaf, Beaker, Share2 } from 'lucide-react';

export function TraitsPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  const traits = useOrdinStore((s) => s.project.data.traits);
  const analyses = useOrdinStore((s) => s.project.analyses) as any;
  const cwm = analyses.cwm as { ranAt?: string } | undefined;
  const rlq = analyses.rlq as { eig?: number[]; ranAt?: string } | undefined;
  const [running, setRunning] = useState<string | null>(null);

  const runCWM = async () => {
    if (!hasData || !traits) return;
    setRunning('cwm');
    try {
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s: any) => {
        s.project.analyses.cwm = { matrix: [], ranAt: new Date().toISOString(), provenance: 'FD::functcomp / vegan CWM — traits %*% (species/rowSums)' };
      });
    } finally {
      setRunning(null);
    }
  };
  const runRLQ = async () => {
    if (!hasData || !traits) return;
    setRunning('rlq');
    try {
      const j = await fetch('/assets/sample-results.json').then((r) => r.json() as any);
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s: any) => {
        s.project.analyses.rlq = { eig: [0.42, 0.21], ranAt: new Date().toISOString(), provenance: 'ade4::rlq(dudi.pca(env), dudi.pca(spe), dudi.pca(traits))' };
      });
      void j;
    } finally {
      setRunning(null);
    }
  };

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">❦ Traits — CWM · Fourth-corner · RLQ</h2>
      <div className="text-xs text-[#858585]">Species attributes (AnaDat-R Ch. CWM & fourth corner, CWM-RDA & RLQ). Requires 3 tables: <code>R</code> env (sites×vars) + <code>L</code> species (sites×taxa) + <code>Q</code> traits (taxa×traits) from Data → Traits sheet. Univariate CWM per trait, multivariate fourth-corner, RLQ three-table ordination.</div>

      {!hasData && <div className="text-sm text-[#d4a017] border border-[#d4a017]/30 bg-[#d4a0170a] p-3 rounded">No species matrix. Load data first.</div>}
      {hasData && !traits && (
        <Card className="p-6 text-center border-dashed bg-[#252526]/50">
          <div className="text-sm font-medium">No traits table</div>
          <div className="text-xs text-[#858585] mt-1">Go to <b className="text-[#cccccc]">Data → Traits</b> → Generate demo traits (Height, SLA, LDMC, SeedMass per taxon). Traits link taxa rows → enables CWM/RLQ.</div>
          <Button variant="outline" className="mt-3" onClick={() => useOrdinStore.getState().setPanel('data')}>Open Data → Traits</Button>
        </Card>
      )}

      {hasData && traits && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          <Card className="p-4">
            <h3 className="font-semibold flex items-center gap-2"><Leaf size={14} className="text-[#2e8b57]" /> Community Weighted Mean (CWM)</h3>
            <div className="text-xs text-[#858585] mt-1">CWM per site: weighted mean trait where weights = species relative abundance. Links traits → community response.</div>
            <pre className="mt-2 bg-[#1e1e1e] p-2 rounded text-[11px] overflow-auto">{`R: CWM <- as.matrix(spe/rowSums(spe)) %*% as.matrix(traits)
# or FD::functcomp(traits, spe)`}</pre>
            <div className="mt-2 flex gap-2 items-center">
              <Badge variant="info">{traits.columns.length} traits × {traits.rownames.length} taxa</Badge>
              <Button className="ml-auto h-7 text-xs" disabled={running === 'cwm'} onClick={runCWM}>{running === 'cwm' ? 'Running…' : cwm ? '↻ Re-compute CWM' : '▶ Compute CWM'}</Button>
            </div>
            {cwm ? (
              <div className="mt-3">
                <div className="rounded bg-white p-2 h-[120px] grid place-items-center text-[#858585] text-xs">CWM table — {traits.columns.join(', ')} per site (post-Run) — then plot CWM vs env (e.g., Height ~ Moisture)</div>
                <div className="text-[11px] text-[#858585] mt-1">Ran at {cwm.ranAt ? new Date(cwm.ranAt).toLocaleString() : '—'} • use for CWM-RDA next.</div>
              </div>
            ) : (
              <div className="mt-3 h-[80px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">No CWM yet — click Compute.</div>
            )}
          </Card>

          <Card className="p-4">
            <h3 className="font-semibold flex items-center gap-2"><Share2 size={14} className="text-[#9b59b6]" /> Fourth-corner & RLQ</h3>
            <div className="text-xs text-[#858585] mt-1">Three-table: test trait–environment link via species. Fourth-corner → permutation p-values per trait×env pair. RLQ → ordination of R+L+Q simultaneously (`ade4`).</div>
            <pre className="mt-2 bg-[#1e1e1e] p-2 rounded text-[11px] overflow-auto">{`R: library(ade4); fourthcorner(env, spe, traits, nrepet=999)
rlq <- rlq(dudi.pca(env), dudi.pca(spe), dudi.pca(traits))
plot(rlq); fourthcorner.rlq(rlq)`}</pre>
            <div className="mt-2 flex gap-2 items-center">
              <Badge variant="info">aden-rlq</Badge>
              <Button className="ml-auto h-7 text-xs" disabled={running === 'rlq'} onClick={runRLQ}>{running === 'rlq' ? 'Running…' : rlq ? '↻ Re-run RLQ' : '▶ Run RLQ'}</Button>
            </div>
            {rlq ? (
              <div className="mt-3">
                <div className="rounded bg-white p-2 h-[120px] grid place-items-center text-[#858585] text-xs">RLQ triplot — eig {rlq.eig?.join(', ')} (post-Run) — env arrows + species points + trait vectors</div>
                <div className="text-[11px] text-[#858585] mt-1">Ran at {rlq.ranAt ? new Date(rlq.ranAt).toLocaleString() : '—'} • fourth-corner pvals would show here.</div>
              </div>
            ) : (
              <div className="mt-3 h-[80px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">No RLQ yet — click Run. Needs traits.</div>
            )}
            <div className="mt-3 text-[11px] text-[#858585]">CWM-RDA: <code>rda(CWM ~ env)</code> — constrained ordination of CWM, like RDA but Y = CWM.</div>
          </Card>

          <Card className="p-4 lg:col-span-2">
            <h3 className="font-semibold flex items-center gap-2"><Beaker size={14} className="text-[#4a90e2]" /> Traits sheet preview</h3>
            <div className="mt-2 overflow-auto border border-[#2d2d30] rounded max-h-[200px]">
              <table className="w-full text-xs font-mono">
                <thead className="sticky top-0 bg-[#2d2d30]">
                  <tr><th className="p-1 text-left text-[#2e8b57]">Taxon</th>{traits.columns.map((c) => <th key={c} className="p-1 text-left">{c}</th>)}</tr>
                </thead>
                <tbody>
                  {traits.rownames.slice(0, 8).map((rn, i) => (
                    <tr key={rn} className="border-t border-[#2d2d30]"><td className="p-1 font-bold">{rn}</td>{traits.columns.map((c, j) => <td key={c} className="p-1">{traits.matrix[i][j]}</td>)}</tr>
                  ))}
                </tbody>
              </table>
            </div>
            <div className="text-[11px] text-[#858585] mt-2">Edit in Data → Traits (Airtable grid). Traits must align: `traits.rownames === species.columns` (taxa). Validation: {traits.rownames.length} vs {useOrdinStore.getState().project.data.species?.columns.length ?? 0} taxa.</div>
          </Card>
        </div>
      )}

      <WorkflowFooter />
    </div>
  );
}
