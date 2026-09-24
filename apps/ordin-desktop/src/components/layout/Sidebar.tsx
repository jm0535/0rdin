import { useState } from 'react';
import { useOrdinStore } from '@ordin/core';
import { ChevronDown, ChevronRight, FolderOpen, Upload, Database, FlaskConical, Layers, Search, PanelLeftClose, FileSpreadsheet, Dna } from 'lucide-react';
import { Badge, Button, Input } from '@ordin/ui';

function Section({ title, defaultOpen = true, children }: { title: string; defaultOpen?: boolean; children: React.ReactNode }) {
  const [open, setOpen] = useState(defaultOpen);
  return (
    <div className="py-1">
      <button onClick={() => setOpen((v) => !v)} className="w-full flex items-center gap-1 px-2 py-1 text-[11px] font-semibold tracking-widest text-[#858585] hover:text-[#cccccc]">
        {open ? <ChevronDown size={12} /> : <ChevronRight size={12} />}
        {title}
      </button>
      {open && <div className="px-2 py-1 space-y-1">{children}</div>}
    </div>
  );
}

export function Sidebar() {
  const project = useOrdinStore((s) => s.project);
  const sp = project.data.species;
  const env = project.data.env;
  const setPanel = useOrdinStore((s) => s.setPanel);
  const setImportOpen = useOrdinStore((s) => s.setImportOpen);
  const setSidebarOpen = useOrdinStore((s) => s.setSidebarOpen);
  const [filter, setFilter] = useState('');

  return (
    <div className="w-[300px] shrink-0 bg-[#1f1f20] border-r border-[#2d2d30] flex flex-col text-sm overflow-hidden">
      {/* header */}
      <div className="h-9 flex items-center px-3 gap-2 border-b border-[#2d2d30] shrink-0">
        <span className="text-[11px] font-semibold tracking-widest text-[#858585]">EXPLORER</span>
        <span className="ml-auto flex items-center gap-1">
          <button onClick={() => setImportOpen(true)} title="Import — popup" className="w-6 h-6 grid place-items-center rounded hover:bg-[#2a2a2a] text-[#858585] hover:text-white">
            <Upload size={14} />
          </button>
          <button onClick={() => setSidebarOpen(false)} title="Collapse sidebar — ⌘B" className="w-6 h-6 grid place-items-center rounded hover:bg-[#2a2a2a] text-[#858585] hover:text-white">
            <PanelLeftClose size={14} />
          </button>
        </span>
      </div>

      {/* filter */}
      <div className="p-2">
        <div className="relative">
          <Search size={14} className="absolute left-2 top-2.5 text-[#858585]" />
          <Input value={filter} onChange={(e) => setFilter(e.target.value)} placeholder="Filter panels, datasets…" className="pl-7 h-7 text-xs bg-[#252526]" />
        </div>
      </div>

      <div className="flex-1 overflow-auto">
        <Section title="DATA SOURCES">
          <button onClick={() => setPanel('data')} className="w-full text-left flex items-center gap-2 px-2 py-1.5 rounded-md hover:bg-[#2a2a2a] transition-colors">
            <FileSpreadsheet size={14} className="text-[#858585]" />
            <span>Current dataset</span>
            {sp && <span className="ml-auto text-xs px-1.5 py-0.5 rounded bg-[#3e3e42]">{sp.rownames.length}×{sp.columns.length}</span>}
          </button>
          <button onClick={() => setImportOpen(true)} className="w-full text-left flex items-center gap-2 px-2 py-1.5 rounded-md hover:bg-[#2a2a2a] border border-dashed border-[#3e3e42] hover:border-[#2e8b57]/40">
            <Upload size={14} className="text-[#2e8b57]" />
            <span>Import file…</span>
            <span className="ml-auto text-[11px] text-[#858585]">CSV/Parquet</span>
          </button>
          <button onClick={() => setPanel('data')} className="w-full text-left flex items-center gap-2 px-2 py-1.5 rounded-md hover:bg-[#2a2a2a]">
            <Database size={14} className="text-[#4a90e2]" />
            <span>Sample datasets</span>
            <span className="ml-auto text-xs text-[#858585]">dune • BCI</span>
          </button>
        </Section>

        <Section title="WORKSPACE">
          <div className="space-y-1">
            <div className="flex items-center justify-between px-2 py-1.5 rounded hover:bg-[#2a2a2a]">
              <span className="flex items-center gap-2">
                <Dna size={14} className="text-[#2e8b57]" /> Species
              </span>
              <Badge variant={sp ? 'success' : 'neutral'}>{sp ? `${sp.rownames.length}×${sp.columns.length}` : '— empty —'}</Badge>
            </div>
            <div className="flex items-center justify-between px-2 py-1.5 rounded hover:bg-[#2a2a2a]">
              <span className="flex items-center gap-2">
                <Layers size={14} className="text-[#ffa500]" /> Env
              </span>
              <Badge variant={env ? 'info' : 'neutral'}>{env ? `${env.columns.length} vars` : '—'}</Badge>
            </div>
            <div className="flex items-center justify-between px-2 py-1.5 rounded bg-[#2e8b5720] border border-[#2e8b57]/15">
              <span className="flex items-center gap-2 text-[#2e8b57]">
                <FlaskConical size={14} /> Validation
              </span>
              <Badge variant="success">OK</Badge>
            </div>
            <div className="px-2 text-[11px] leading-relaxed text-[#858585]">
              Zustand → <code className="text-[#cccccc]">.ordin.json</code> • editable, versioned, reproducible.
            </div>
          </div>
        </Section>

        <Section title="ANALYSES" defaultOpen={true}>
          <button onClick={() => setPanel('ordination')} className="w-full flex items-center justify-between px-2 py-1.5 rounded hover:bg-[#2a2a2a] text-left">
            <span className="flex items-center gap-2"> <span className="w-2 h-2 rounded-full bg-[#2e8b57]" /> Ordination</span>
            <Badge variant="success">9</Badge>
          </button>
          <button onClick={() => setPanel('diversity')} className="w-full flex items-center justify-between px-2 py-1.5 rounded hover:bg-[#2a2a2a] text-left">
            <span className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-[#4a90e2]" /> Diversity
            </span>
            <Badge variant="info">iNEXT</Badge>
          </button>
          <button onClick={() => setPanel('tests')} className="w-full flex items-center justify-between px-2 py-1.5 rounded hover:bg-[#2a2a2a] text-left">
            <span className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-[#ffa500]" /> Tests
            </span>
            <span className="text-xs text-[#858585]">PERMANOVA</span>
          </button>
          <button onClick={() => setPanel('beta')} className="w-full flex items-center justify-between px-2 py-1.5 rounded hover:bg-[#2a2a2a] text-left">
            <span className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-[#9b59b6]" /> Beta
            </span>
            <span className="text-xs text-[#858585]">Sørensen</span>
          </button>
          <div className="px-2 pt-1 text-[11px] text-[#858585] leading-relaxed">
            deck.gl draws <b className="text-[#cccccc]">ordination biplots</b>, not map tiles. MapLibre only appears if env has <code>lon/lat</code>.
          </div>
        </Section>

        <Section title="RECENT">
          <div className="px-2 py-1 text-xs text-[#858585]">No recent projects — open a sample to start.</div>
          <div className="flex gap-1 px-2">
            <Button variant="subtle" onClick={() => setPanel('data')}>
              <FolderOpen size={14} className="mr-1" /> Open
            </Button>
            <Button variant="outline" onClick={() => setPanel('data')} className="h-7 text-xs">
              dune
            </Button>
          </div>
        </Section>
      </div>

      <div className="p-2 border-t border-[#2d2d30] bg-[#252526]/50">
        <div className="text-xs font-medium text-[#cccccc] truncate">Project: {project.meta.name}</div>
        <div className="text-[11px] text-[#858585]">.ordin.json • Tauri • DuckDB • webR</div>
      </div>
    </div>
  );
}
