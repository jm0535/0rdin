import { Card, Badge, Button } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
import { WorkflowFooter } from '../layout/WorkflowFooter';
export function ResultsPanel() {
  const project = useOrdinStore((s) => s.project);
  const hasData = !!project.data.species;
  const hasAnyResult = Object.keys(project.analyses).length > 0;
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">▤ Results — .ordin.json (auditable)</h2>
      {!hasData && (
        <Card className="p-6 text-center border-dashed bg-[#252526]/50">
          <div className="text-sm font-medium">No data — nothing to export</div>
          <div className="text-xs text-[#858585] mt-1">Results appear here only after you load data and explicitly Run an analysis. This panel mirrors the persisted <code className="text-white">.ordin.json</code> — enterprise: single source of truth.</div>
        </Card>
      )}
      {hasData && !hasAnyResult && (
        <Card className="p-6 text-center border-dashed bg-[#252526]/50">
          <div className="text-sm font-medium">No results yet</div>
          <div className="text-xs text-[#858585] mt-1">Run an ordination, diversity, test, or beta partitioning. Nothing is pre-filled — every export is traceable to a Run with provenance.</div>
          <div className="mt-3 flex gap-2 justify-center">
            <Button variant="outline" onClick={() => useOrdinStore.getState().setPanel('ordination')}>
              Go to Ordination
            </Button>
            <Button variant="outline" onClick={() => useOrdinStore.getState().setPanel('diversity')}>
              Go to Diversity
            </Button>
          </div>
        </Card>
      )}
      {hasAnyResult && (
        <>
          <div className="flex gap-2 flex-wrap">
            <Badge variant="success">{Object.keys(project.analyses).length} analyses stored</Badge>
            <Badge variant="info">{project.data.species?.rownames.length}×{project.data.species?.columns.length} matrix</Badge>
            <Badge variant="neutral">{project.meta.name}</Badge>
            <Button
              variant="subtle"
              className="ml-auto h-7 text-xs"
              onClick={() => {
                const blob = new Blob([JSON.stringify(project, null, 2)], { type: 'application/json' });
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = `${project.meta.name || 'ordin'}.ordin.json`;
                a.click();
                URL.revokeObjectURL(url);
              }}
            >
              ⤓ Download .ordin.json
            </Button>
          </div>
          <Card className="p-3">
            <pre className="text-xs bg-[#1e1e1e] p-3 rounded overflow-auto max-h-[60vh]">{JSON.stringify(project, null, 2).slice(0, 8000)}</pre>
          </Card>
          <div className="text-[11px] text-[#858585]">Provenance: each analysis entry stores <code>method/distance/k</code> + <code>ranAt</code> + <code>provenance</code>. Re-running never silently overwrites without audit — inspect this JSON before sharing.</div>
        </>
      )}
      <WorkflowFooter />
    </div>
  );
}
