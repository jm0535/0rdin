import { useOrdinStore, validateSpeciesMatrix } from '@ordin/core';
import { ArrowLeft, ArrowRight } from 'lucide-react';
import { Button } from '@ordin/ui';

const ORDER: Array<{ id: import('@ordin/core').PanelId; label: string }> = [
  { id: 'data', label: 'Data' },
  { id: 'diversity', label: 'Diversity' },
  { id: 'beta', label: 'Beta' },
  { id: 'ordination', label: 'Ordination' },
  { id: 'tests', label: 'Tests' },
  { id: 'results', label: 'Results' },
];

export function WorkflowFooter() {
  const project = useOrdinStore((s) => s.project);
  const active = useOrdinStore((s) => s.project.view.activePanel);
  const setPanel = useOrdinStore((s) => s.setPanel);
  const sp = project.data.species;
  const hasData = !!sp && validateSpeciesMatrix(sp).valid;
  const hasAny = Object.keys(project.analyses).length > 0;

  // only show on workflow-relevant panels
  if (!['data', 'ordination', 'diversity', 'tests', 'beta', 'results'].includes(active)) return null;

  const idx = ORDER.findIndex((o) => o.id === active);
  const prev = idx > 0 ? ORDER[idx - 1] : null;
  const next = idx < ORDER.length - 1 ? ORDER[idx + 1] : null;

  const nextBlocked = next && !hasData && next.id !== 'data';

  return (
    <div className="mt-6 flex items-center justify-between gap-2 rounded-xl border border-[#2d2d30] bg-[#252526]/60 p-3">
      <div className="text-xs text-[#858585]">
        <span className="font-medium text-[#cccccc]">Workflow:</span> {ORDER.map((o, i) => (
          <span key={o.id} className={o.id === active ? 'text-[#2e8b57] font-semibold' : 'text-[#858585]'}>
            {i > 0 && ' → '} {o.label}
          </span>
        ))}
      </div>
      <div className="flex gap-1.5 shrink-0">
        {prev && (
          <Button variant="ghost" className="h-7 text-xs" onClick={() => setPanel(prev.id)}>
            <ArrowLeft size={12} className="mr-1" /> {prev.label}
          </Button>
        )}
        {next && (
          <Button
            variant={nextBlocked ? 'ghost' : 'subtle'}
            className={`h-7 text-xs ${nextBlocked ? 'opacity-50 cursor-not-allowed' : ''}`}
            disabled={!!nextBlocked}
            title={nextBlocked ? 'Requires Data — import & validate first' : hasAny ? 'Next step (JASP-like: results stack)' : 'Next step'}
            onClick={() => !nextBlocked && setPanel(next.id)}
          >
            {next.label} <ArrowRight size={12} className="ml-1" />
          </Button>
        )}
      </div>
    </div>
  );
}
