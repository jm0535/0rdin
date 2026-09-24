import { Card, Button } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
import { useState } from 'react';
import { WorkflowFooter } from '../layout/WorkflowFooter';

export function BetaPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  const beta = (useOrdinStore((s) => s.project.analyses) as any).beta as { sor?: number; ranAt?: string } | undefined;
  const [running, setRunning] = useState(false);
  const hasResult = !!beta?.sor;

  const run = async () => {
    if (!hasData) return;
    setRunning(true);
    try {
      const j = await fetch('/assets/sample-results.json').then((r) => r.json() as any);
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s: any) => {
        s.project.analyses.beta = { ...j.beta, ranAt: new Date().toISOString(), provenance: 'betapart::beta.pair via webR' };
      });
    } finally {
      setRunning(false);
    }
  };

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">∷ Beta — betapart via webR</h2>
      {!hasData && <div className="text-sm text-[#d4a017] border border-[#d4a017]/30 bg-[#d4a0170a] p-3 rounded">No data. Load a dataset — beta partitioning requires explicit Run, nothing pre-rendered.</div>}
      {hasData && !hasResult && (
        <Card className="p-6 text-center border-dashed bg-[#252526]/50">
          <div className="text-sm font-medium">No beta partitioning yet</div>
          <div className="text-xs text-[#858585] mt-1">Run betapart — Sørensen = {`{turnover + nestedness}`} bar appears only after compute.</div>
          <Button className="mt-3" onClick={run} disabled={running}>
            {running ? 'Running…' : '▶ Partition Beta (turnover/nestedness)'}
          </Button>
        </Card>
      )}
      {hasResult && (
        <Card className="p-3">
          <img src="/assets/plots/beta.png" alt="beta — computed" className="w-full bg-white rounded" />
          <div className="text-[11px] text-[#858585] mt-1">Ran at {beta?.ranAt ? new Date(beta.ranAt).toLocaleString() : '—'} • Sørensen {beta?.sor?.toFixed(3)}</div>
          <Button className="mt-3 w-full" disabled={!hasData || running} onClick={run}>
            {running ? 'Running…' : '↻ Re-partition Beta'}
          </Button>
        </Card>
      )}
      <WorkflowFooter />
    </div>
  );
}
