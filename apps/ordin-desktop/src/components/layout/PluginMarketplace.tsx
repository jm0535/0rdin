import { useState } from 'react';
import { useOrdinStore } from '@ordin/core';
import { Card, Button, Badge } from '@ordin/ui';
import { Puzzle, Check, Search, X, Power, GitBranch, Beaker, Layers, BarChart3 } from 'lucide-react';

const AVAILABLE: { id: string; name: string; ver: string; author: string; kind: 'classification'|'trait'|'tests'|'diversity'; desc: string; r: string[]; panel: string; Icon: React.ComponentType<any> }[] = [
  { id: 'classification', name: 'Classification', ver: '1.0.0', author: 'Ordin Labs', kind: 'classification', desc: 'hclust (all linkages) + TWINSPAN (Oksanen) + K-means + silhouette/IndVal. AnaDat-R Ch. Numerical classification.', r: ['vegan', 'twinspan', 'indicspecies'], panel: 'classification', Icon: GitBranch },
  { id: 'traits', name: 'Traits — CWM/RLQ', ver: '1.0.0', author: 'Ordin Labs', kind: 'trait', desc: 'CWM, fourth-corner, RLQ (R×L×Q). Requires Traits sheet. AnaDat-R Ch. Species attributes.', r: ['ade4', 'FD'], panel: 'traits', Icon: Beaker },
  { id: 'varpart', name: 'Variation Partitioning', ver: '0.9.0', author: 'Community', kind: 'tests', desc: 'varpart + Venn 2–4 groups + ordiR2step. AnaDat-R Ch. Variation partitioning.', r: ['vegan'], panel: 'tests', Icon: Layers },
  { id: 'div-compare', name: 'Diversity Compare', ver: '0.9.0', author: 'Community', kind: 'diversity', desc: 'Hill profiles, evenness, specaccum, rarefy, diversity t-test — AnaDat-R Ch. Comparing diversity.', r: ['vegan','iNEXT'], panel: 'diversity', Icon: BarChart3 },
];

export function PluginMarketplace() {
  const open = useOrdinStore((s) => s.ui.pluginOpen);
  const setOpen = useOrdinStore((s) => s.setPluginOpen);
  const project = useOrdinStore((s) => s.project);
  const [q, setQ] = useState('');
  const active = new Set((project.meta.plugins ?? []).map((p) => p.id));
  const isActiveId = (id: string) => active.has(id);
  const activeCount = active.size;

  const toggle = (p: typeof AVAILABLE[number]) => {
    // @ts-ignore
    useOrdinStore.setState((s: any) => {
      if (!s.project.meta.plugins) s.project.meta.plugins = [];
      const idx = s.project.meta.plugins.findIndex((x: any) => x.id === p.id);
      if (idx >= 0) {
        s.project.meta.plugins.splice(idx, 1);
        if (s.project.view.activePanel === p.panel) s.project.view.activePanel = 'dashboard';
      } else {
        s.project.meta.plugins.push({ id: p.id, version: p.ver });
      }
      s.project.meta.modified = new Date().toISOString();
    });
  };

  if (!open) return null;

  const filtered = AVAILABLE.filter((p) => {
    if (!q.trim()) return true;
    const t = `${p.id} ${p.name} ${p.desc} ${p.r.join(' ')}`.toLowerCase();
    return t.includes(q.toLowerCase());
  });

  return (
    <div className="fixed inset-0 z-50 grid place-items-center bg-black/55 backdrop-blur-sm p-4" onClick={() => setOpen(false)}>
      <div className="w-full max-w-[720px] max-h-[85vh] overflow-auto rounded-2xl border border-[#2d2d30] bg-[#1e1e1e] shadow-2xl" onClick={(e) => e.stopPropagation()}>
        <div className="sticky top-0 bg-[#252526] border-b border-[#2d2d30] p-4 flex items-center gap-3">
          <Puzzle size={18} className="text-[#2e8b57]" />
          <div>
            <div className="font-semibold">Plugin Marketplace</div>
            <div className="text-xs text-[#858585]">All plugins are <b className="text-[#cccccc]">bundled — no install, no download</b>. Just <b className="text-[#cccccc]">Activate</b> to show the panel. Deactivate hides it from the rail. Versions pinned in <code>.ordin.json</code> for reproducibility.</div>
          </div>
          <button onClick={() => setOpen(false)} className="ml-auto w-7 h-7 grid place-items-center rounded hover:bg-[#2a2a2a] text-[#858585]"><X size={16} /></button>
        </div>

        <div className="p-4 space-y-3">
          <div className="flex gap-2">
            <div className="relative flex-1">
              <Search size={14} className="absolute left-2 top-2.5 text-[#858585]" />
              <input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search plugins (e.g. twinspan, varpart, RLQ)" className="w-full pl-7 h-8 bg-[#252526] border border-[#3e3e42] rounded text-xs" />
            </div>
            <Badge variant="info">{AVAILABLE.length} plugins</Badge>
            <Badge variant="success">{activeCount} active</Badge>
          </div>

          <Card className="p-3 bg-[#2e8b5720] border-[#2e8b57]/20">
            <div className="text-xs font-semibold text-[#2e8b57]">manifest.schema.json — how plugins work</div>
            <pre className="mt-1 bg-[#1e1e1e] p-2 rounded text-[10px] overflow-auto">{`{
  "id": "twinspan",
  "version": "1.0.0",
  "kind": "classification",
  "r": ["vegan","twinspan"],
  "panels": [{"id":"twinspan","mount":"classification","component":"./TwinspanPanel.tsx"}],
  "duckdb": {"tables":["species","env"]},
  "permissions": ["webR:run","fs:read"]
}`}</pre>
            <div className="text-[11px] text-[#858585] mt-2">Toggle = <code>project.meta.plugins</code>. No download — bundle is already in the app. Opening a plugin auto-closes this window.</div>
          </Card>

          {filtered.map((p) => {
            const isActive = isActiveId(p.id);
            return (
              <Card key={p.id} className={`p-3 flex gap-3 ${isActive ? 'border-[#2e8b57]/30 bg-[#2e8b57]/5' : 'opacity-90'}`}>
                <div className={`w-10 h-10 rounded-lg border grid place-items-center shrink-0 ${isActive ? 'bg-[#2e8b57]/15 border-[#2e8b57]/20' : 'bg-[#252526] border-[#2d2d30]'}`}>
                  {(() => { const Icon = p.Icon; return <Icon size={18} className={isActive ? 'text-[#2e8b57]' : 'text-[#858585]'} />; })()}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="font-medium flex items-center gap-2 flex-wrap">
                    {p.name} <Badge variant={isActive ? 'success' : 'neutral'}>{isActive ? 'active' : 'inactive'}</Badge>
                    <span className="text-[11px] font-normal text-[#858585]">{p.ver} • by {p.author} • R: {p.r.join(', ')}</span>
                  </div>
                  <div className="text-xs text-[#858585] mt-1">{p.desc}</div>
                  <div className="text-[11px] text-[#858585] mt-1">Mount: <code>{p.panel}</code> • kind: {p.kind} • gate: hasData</div>
                </div>
                <div className="shrink-0 flex flex-col items-end gap-2">
                  <div className="flex items-center gap-2">
                    <span className={`text-[11px] ${isActive ? 'text-[#2e8b57] font-medium' : 'text-[#858585]'}`}>{isActive ? 'Active' : 'Inactive'}</span>
                    <button
                      onClick={() => toggle(p)}
                      role="switch"
                      aria-checked={isActive}
                      title={isActive ? 'Deactivate — hides from rail' : 'Activate — shows in rail'}
                      className={`relative w-9 h-5 rounded-full transition-colors ${isActive ? 'bg-[#2e8b57]' : 'bg-[#3e3e42]'}`}
                    >
                      <span className={`absolute top-0.5 left-0.5 w-4 h-4 rounded-full bg-white shadow transition-transform ${isActive ? 'translate-x-4' : 'translate-x-0'}`} />
                    </button>
                  </div>
                  <Button
                    variant={isActive ? 'default' : 'subtle'}
                    className="h-7 text-xs"
                    onClick={() => {
                      if (!isActive) {
                        // @ts-ignore
                        useOrdinStore.setState((s: any) => {
                          if (!s.project.meta.plugins) s.project.meta.plugins = [];
                          if (!s.project.meta.plugins.find((x: any) => x.id === p.id)) {
                            s.project.meta.plugins.push({ id: p.id, version: p.ver });
                          }
                          s.project.meta.modified = new Date().toISOString();
                        });
                      }
                      useOrdinStore.getState().setPanel(p.panel as any);
                      setOpen(false);
                    }}
                  >
                    {isActive ? <><Check size={12} className="mr-1" /> Open</> : <><Power size={12} className="mr-1" /> Activate & Open</>}
                  </Button>
                </div>
              </Card>
            );
          })}
          {filtered.length === 0 && <div className="text-xs text-[#858585] text-center py-6">No plugins match “{q}”.</div>}

          <div className="text-[11px] text-[#858585] border border-[#2d2d30] rounded p-2 bg-[#252526]/50">
            Plugins run in <b className="text-[#cccccc]">webR Workers</b> (Comlink, 30s timeout, per-plugin namespace) + <b className="text-[#cccccc]">DuckDB</b> views. Toggle state persisted in <code>.ordin.json → meta.plugins</code> — re-open on another machine restores same active set. Tauri prod would verify signature on enable.
          </div>
        </div>
      </div>
    </div>
  );
}
