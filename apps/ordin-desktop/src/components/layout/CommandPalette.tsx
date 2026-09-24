import { useEffect, useMemo, useState } from 'react';
import { useOrdinStore, type PanelId } from '@ordin/core';
import { Search, Database, Leaf, Orbit, FlaskConical, Split, LayoutDashboard, Upload, FileSpreadsheet } from 'lucide-react';
import { Dialog, Input } from '@ordin/ui';

const NAV: { id: PanelId; label: string; desc: string; icon: any }[] = [
  { id: 'dashboard', label: 'Dashboard', desc: 'Overview & quick start', icon: LayoutDashboard },
  { id: 'data', label: 'Data — Import & Preview', desc: 'CSV/Parquet • DuckDB', icon: Database },
  { id: 'ordination', label: 'Ordination', desc: 'NMDS PCA CA DCA… • deck.gl biplots', icon: Orbit },
  { id: 'diversity', label: 'Diversity', desc: 'iNEXT • Hill numbers', icon: Leaf },
  { id: 'tests', label: 'Tests', desc: 'PERMANOVA / ANOSIM / Mantel', icon: FlaskConical },
  { id: 'beta', label: 'Beta', desc: 'Sørensen turnover', icon: Split },
];

export function CommandPalette() {
  const open = useOrdinStore((s) => s.ui.commandOpen);
  const setOpen = useOrdinStore((s) => s.setCommandOpen);
  const setPanel = useOrdinStore((s) => s.setPanel);
  const setImportOpen = useOrdinStore((s) => s.setImportOpen);
  const loadSample = useOrdinStore((s) => s.loadSample);
  const [q, setQ] = useState('');

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        setOpen(!open);
      }
      if (e.key === 'Escape' && open) setOpen(false);
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [open, setOpen]);

  useEffect(() => {
    if (!open) setQ('');
  }, [open]);

  const filtered = useMemo(() => {
    const s = q.trim().toLowerCase();
    if (!s) return NAV;
    return NAV.filter((n) => `${n.label} ${n.desc}`.toLowerCase().includes(s));
  }, [q]);

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <div className="flex items-center gap-2 px-3 py-2 border-b border-[#2d2d30] shrink-0">
        <Search size={16} className="text-[#858585]" />
        <Input autoFocus value={q} onChange={(e) => setQ(e.target.value)} placeholder="Type a command — try “ordination”, “dune”, “sql”…" className="flex-1 border-0 bg-transparent focus:ring-0 focus:border-0 h-8 px-0" />
        <span className="text-[11px] text-[#858585] border border-[#3e3e42] rounded px-1.5 py-0.5">ESC</span>
      </div>

      <div className="p-2 overflow-auto space-y-3">
        <div>
          <div className="text-[11px] tracking-widest font-semibold text-[#858585] px-2 py-1">GO TO</div>
          <div className="space-y-1">
            {filtered.map((n) => {
              const Icon = n.icon as any;
              return (
                <button
                  key={n.id}
                  onClick={() => {
                    setPanel(n.id);
                    setOpen(false);
                  }}
                  className="w-full flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-[#2a2a2a] text-left transition-colors"
                >
                  <span className="w-8 h-8 grid place-items-center rounded-md bg-[#2d2d30] text-[#858585]">
                    <Icon size={16} />
                  </span>
                  <span className="flex-1">
                    <div className="text-sm font-medium">{n.label}</div>
                    <div className="text-xs text-[#858585]">{n.desc}</div>
                  </span>
                  <span className="text-[11px] text-[#858585]">↵</span>
                </button>
              );
            })}
            {filtered.length === 0 && <div className="text-xs text-[#858585] px-3 py-2">No match.</div>}
          </div>
        </div>

        <div className="border-t border-[#2d2d30] pt-3">
          <div className="text-[11px] tracking-widest font-semibold text-[#858585] px-2 py-1">QUICK ACTIONS — popups</div>
          <div className="grid grid-cols-2 gap-2">
            <button
              onClick={() => {
                setOpen(false);
                setImportOpen(true);
              }}
              className="flex items-center gap-2 px-3 py-2 rounded-lg border border-[#3e3e42] hover:bg-[#2a2a2a] text-left"
            >
              <Upload size={16} className="text-[#2e8b57]" /> <span className="text-sm">Import file…</span>
              <span className="ml-auto text-[11px] text-[#858585]">⌘I</span>
            </button>
            <button
              onClick={async () => {
                await loadSample('dune');
                setOpen(false);
              }}
              className="flex items-center gap-2 px-3 py-2 rounded-lg border border-[#3e3e42] hover:bg-[#2a2a2a] text-left"
            >
              <FileSpreadsheet size={16} className="text-[#4a90e2]" /> <span className="text-sm">Load dune</span>
              <span className="ml-auto text-[11px] text-[#858585]">sample</span>
            </button>
            <button onClick={() => { setOpen(false); setTimeout(() => document.getElementById('sql-workspace')?.scrollIntoView({ behavior: 'smooth' }), 100); }} className="col-span-2 flex items-center gap-2 px-3 py-2 rounded-lg bg-[#4a90e220] border border-[#4a90e2]/20 text-left">
              <Database size={16} className="text-[#4a90e2]" /> <span className="text-sm">Open SQL Workspace</span>
              <span className="ml-auto text-xs text-[#4a90e2]">DuckDB-WASM</span>
            </button>
          </div>
        </div>

        <div className="text-[11px] text-[#858585] px-2">Stack: Tauri • React • Vite • Zustand • DuckDB-WASM • deck.gl • webR — same stack as GeoLibre, distinct product (statistical, not GIS).</div>
      </div>
    </Dialog>
  );
}
