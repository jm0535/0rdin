import { useOrdinStore } from '@ordin/core';
import { Card, Button, Badge } from '@ordin/ui';
import { Puzzle, Download, Check, Search, X } from 'lucide-react';

const AVAILABLE = [
  { id: 'classification', name: 'Classification', ver: '1.0.0', author: 'Ordin Labs', kind: 'ordination' as const, desc: 'hclust (all linkages) + TWINSPAN (Oksanen) + K-means + silhouette/IndVal. AnaDat-R Ch. Numerical classification.', r: ['vegan', 'twinspan', 'indicspecies'], panel: 'classification' },
  { id: 'traits', name: 'Traits — CWM/RLQ', ver: '1.0.0', author: 'Ordin Labs', kind: 'trait' as const, desc: 'CWM, fourth-corner, RLQ (R×L×Q). Requires Traits sheet. AnaDat-R Ch. Species attributes.', r: ['ade4', 'FD'], panel: 'traits' },
  { id: 'varpart', name: 'Variation Partitioning', ver: '0.9.0', author: 'Community', kind: 'tests' as const, desc: 'varpart + Venn 2–4 groups + ordiR2step. AnaDat-R Ch. Variation partitioning.', r: ['vegan'], panel: 'tests' },
  { id: 'div-compare', name: 'Diversity Compare', ver: '0.9.0', author: 'Community', kind: 'diversity' as const, desc: 'Hill profiles, evenness, specaccum, rarefy, diversity t-test — AnaDat-R Ch. Comparing diversity.', r: ['vegan','iNEXT'], panel: 'diversity' },
];

export function PluginMarketplace() {
  const open = useOrdinStore((s) => s.ui.pluginOpen);
  const setOpen = useOrdinStore((s) => s.setPluginOpen);
  const project = useOrdinStore((s) => s.project);
  const installed = new Set((project.meta.plugins ?? []).map((p) => p.id));
  // core plugins are always installed
  const coreInstalled = new Set(['classification', 'traits']);
  const allInstalled = new Set([...installed, ...coreInstalled]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 grid place-items-center bg-black/55 backdrop-blur-sm p-4" onClick={() => setOpen(false)}>
      <div className="w-full max-w-[720px] max-h-[85vh] overflow-auto rounded-2xl border border-[#2d2d30] bg-[#1e1e1e] shadow-2xl" onClick={(e) => e.stopPropagation()}>
        <div className="sticky top-0 bg-[#252526] border-b border-[#2d2d30] p-4 flex items-center gap-3">
          <Puzzle size={18} className="text-[#2e8b57]" />
          <div>
            <div className="font-semibold">Plugin Marketplace — like jamovi +Modules</div>
            <div className="text-xs text-[#858585]">Marketplace hosts R-backed plugins (vegan, twinspan, ade4). Core (Classification, Traits) pre-installed. Others install via .ordin-plugin.zip (Tauri) or one-click here (web). All runs gated + provenance.</div>
          </div>
          <button onClick={() => setOpen(false)} className="ml-auto w-7 h-7 grid place-items-center rounded hover:bg-[#2a2a2a] text-[#858585]"><X size={16} /></button>
        </div>

        <div className="p-4 space-y-3">
          <div className="flex gap-2">
            <div className="relative flex-1">
              <Search size={14} className="absolute left-2 top-2.5 text-[#858585]" />
              <input placeholder="Search plugins (e.g. twinspan, varpart, RLQ)" className="w-full pl-7 h-8 bg-[#252526] border border-[#3e3e42] rounded text-xs" />
            </div>
            <Badge variant="info">{AVAILABLE.length} available</Badge>
            <Badge variant="success">{allInstalled.size} installed</Badge>
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
          </Card>

          {AVAILABLE.map((p) => {
            const isInstalled = allInstalled.has(p.id);
            return (
              <Card key={p.id} className={`p-3 flex gap-3 ${isInstalled ? 'border-[#2e8b57]/30 bg-[#2e8b57]/5' : ''}`}>
                <div className="w-10 h-10 rounded-lg bg-[#252526] border border-[#2d2d30] grid place-items-center shrink-0">
                  <Puzzle size={18} className={isInstalled ? 'text-[#2e8b57]' : 'text-[#858585]'} />
                </div>
                <div className="flex-1 min-w-0">
                  <div className="font-medium flex items-center gap-2">
                    {p.name} <Badge variant={isInstalled ? 'success' : 'neutral'}>{isInstalled ? 'installed' : p.ver}</Badge>
                    <span className="text-[11px] text-[#858585]">by {p.author} • R: {p.r.join(', ')}</span>
                  </div>
                  <div className="text-xs text-[#858585] mt-1">{p.desc}</div>
                  <div className="text-[11px] text-[#858585] mt-1">Mount: <code>{p.panel}</code> • kind: {p.kind} • gate: hasData • provenance: .ordin.json `meta.plugins`</div>
                </div>
                <div className="shrink-0 flex flex-col gap-1">
                  {isInstalled ? (
                    <Button variant="ghost" className="h-7 text-xs" disabled><Check size={12} className="mr-1" /> Installed</Button>
                  ) : (
                    <Button variant="subtle" className="h-7 text-xs" onClick={() => {
                      const { useOrdinStore: store } = require('@ordin/core');
                      // @ts-ignore
                      store.setState((s: any) => {
                        if (!s.project.meta.plugins) s.project.meta.plugins = [];
                        s.project.meta.plugins.push({ id: p.id, version: p.ver });
                        s.project.meta.modified = new Date().toISOString();
                      });
                    }}><Download size={12} className="mr-1" /> Install</Button>
                  )}
                  <Button variant="ghost" className="h-7 text-xs" onClick={() => useOrdinStore.getState().setPanel(p.panel as any)}>Open</Button>
                </div>
              </Card>
            );
          })}

          <div className="text-[11px] text-[#858585] border border-[#2d2d30] rounded p-2 bg-[#252526]/50">
            Plugins run in <b className="text-[#cccccc]">webR Workers</b> (Comlink, 30s timeout, per-plugin namespace) + <b className="text-[#cccccc]">DuckDB</b> views. Version pinned in <code>.ordin.json meta.plugins</code> for reproducibility — re-open on another machine re-installs same R pkg versions. Tauri prod would verify signature.
          </div>
        </div>
      </div>
    </div>
  );
}
