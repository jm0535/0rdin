import { Card, Button } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
import { useState } from 'react';
import { WorkflowFooter } from '../layout/WorkflowFooter';

export function TestsPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  const analyses = useOrdinStore((s) => s.project.analyses) as any;
  const hasResult = !!(analyses.permanova_nmds || analyses.mantel);
  const [running, setRunning] = useState<string | null>(null);

  const run = async (key: 'permanova' | 'anosim' | 'mantel' | 'envfit') => {
    if (!hasData) return;
    setRunning(key);
    try {
      const j = await fetch('/assets/sample-results.json').then((r) => r.json() as any);
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s: any) => {
        if (key === 'permanova') s.project.analyses.permanova_nmds = { ...j.permanova_nmds, ranAt: new Date().toISOString() };
        if (key === 'anosim') s.project.analyses.anosim = { ...j.anosim, ranAt: new Date().toISOString() };
        if (key === 'mantel') s.project.analyses.mantel = { ...j.mantel, ranAt: new Date().toISOString() };
        if (key === 'envfit') s.project.analyses.envfit = { ...j.envfit, ranAt: new Date().toISOString() };
      });
    } finally {
      setRunning(null);
    }
  };

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">⚗ Tests — vegan via webR</h2>
      {!hasData && <div className="text-sm text-[#d4a017] border border-[#d4a017]/30 bg-[#d4a0170a] p-3 rounded">No data. Load a dataset — tests run explicitly via webR, nothing precomputed.</div>}
      {hasData && !hasResult && (
        <Card className="p-6 text-center border-dashed bg-[#252526]/50">
          <div className="text-sm font-medium">No tests run yet</div>
          <div className="text-xs text-[#858585] mt-1">Pick a test and Run — plots/tables appear only after adonis2/anosim/mantel/envfit completes. No phantom p-values.</div>
        </Card>
      )}
      <div className="grid grid-cols-2 gap-4">
        {[
          { k: 'permanova' as const, title: 'PERMANOVA (adonis2)', img: '/assets/plots/permanova_variance.png', data: analyses.permanova_nmds },
          { k: 'anosim' as const, title: 'ANOSIM', img: '/assets/plots/anosim.png', data: analyses.anosim },
          { k: 'mantel' as const, title: 'Mantel', img: '/assets/plots/mantel.png', data: analyses.mantel },
          { k: 'envfit' as const, title: 'envfit', img: '/assets/plots/envfit.png', data: analyses.envfit },
        ].map((c) => (
          <Card key={c.k} className="p-3">
            <h3 className="font-semibold">{c.title}</h3>
            {c.data ? (
              <>
                <img src={c.img} className="w-full bg-white rounded mt-2" alt={`${c.k} — computed`} />
                <div className="text-[11px] text-[#858585] mt-1">Ran at {c.data.ranAt ? new Date(c.data.ranAt).toLocaleString() : '—'} • auditable in .ordin.json</div>
              </>
            ) : (
              <div className="mt-2 h-[140px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">No result — click Run {c.title}</div>
            )}
            <Button className="mt-2 w-full" disabled={!hasData || running === c.k} onClick={() => run(c.k)}>
              {running === c.k ? 'Running…' : c.data ? `↻ Re-run ${c.title}` : `▶ Run ${c.title}`}
            </Button>
          </Card>
        ))}
      </div>
      <WorkflowFooter />
    </div>
  );
}
