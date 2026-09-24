import { useState } from 'react';
import { useOrdinStore, validateSpeciesMatrix } from '@ordin/core';
import {
  ChevronDown,
  ChevronRight,
  Upload,
  Database,
  FileSpreadsheet,
  Leaf,
  Orbit,
  FlaskConical,
  Split,
  BarChart3,
  Check,
  Clock3,
  Lock,
  Search,
  PanelLeftClose,
  Play,
  Eye,
} from 'lucide-react';
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

// Enterprise workflow helpers — how R/Python scripts and JASP/jamovi do it
function useWorkflow() {
  const project = useOrdinStore((s) => s.project);
  const sp = project.data.species;
  const hasData = !!sp && validateSpeciesMatrix(sp).valid;
  const hasOrdination = !!(project.analyses as any).nmds;
  const hasDiversity = !!(project.analyses as any).diversity;
  const hasTests = !!(project.analyses as any).permanova_nmds || !!(project.analyses as any).anosim || !!(project.analyses as any).mantel;
  const hasBeta = !!(project.analyses as any).beta?.sor;
  const hasAnyResult = Object.keys(project.analyses).length > 0;
  const steps = [
    {
      id: 'data' as const,
      label: '1 — Data',
      desc: 'Import & validate',
      panel: 'data' as const,
      icon: Database,
      status: hasData ? ('done' as const) : ('ready' as const),
      badge: hasData ? `${sp!.rownames.length}×${sp!.columns.length}` : '— empty —',
      hint: hasData ? '✓ validated — enables all analyses' : 'CSV/Parquet via DuckDB • drag-drop or sample',
      requires: null,
    },
    {
      id: 'ordination' as const,
      label: '2 — Ordination',
      desc: 'NMDS·PCA·CA·DCA·PCoA·CCA·RDA',
      panel: 'ordination' as const,
      icon: Orbit,
      status: !hasData ? ('blocked' as const) : hasOrdination ? ('done' as const) : ('ready' as const),
      badge: hasOrdination ? `stress ${(project.analyses as any).nmds.stress.toFixed(3)}` : '9 methods',
      hint: !hasData ? 'Needs Data (≥3 sites, ≥2 species)' : hasOrdination ? 'Reran deck.gl biplot ready • Tests/Beta now unlocked' : 'Rank-1 in R: metaMDS(dune) → stress → envfit',
      requires: 'Data',
    },
    {
      id: 'diversity' as const,
      label: '3 — Diversity',
      desc: 'iNEXT · Shannon · Hill',
      panel: 'diversity' as const,
      icon: Leaf,
      status: !hasData ? ('blocked' as const) : hasDiversity ? ('done' as const) : ('ready' as const),
      badge: hasDiversity ? 'iNEXT done' : 'iNEXT',
      hint: !hasData ? 'Needs Data' : 'R: iNEXT(species) + vegan::diversity',
      requires: 'Data',
    },
    {
      id: 'tests' as const,
      label: '4 — Tests',
      desc: 'PERMANOVA · ANOSIM · Mantel · envfit',
      panel: 'tests' as const,
      icon: FlaskConical,
      status: !hasData ? ('blocked' as const) : hasTests ? ('done' as const) : ('ready' as const),
      badge: hasTests ? 'p < 0.05 available' : 'adonis2',
      hint: !hasData ? 'Needs Data + env' : hasOrdination ? 'Tests fit on ordination (R: adonis2(dune ~ Management))' : 'Can run without ordination, but best after 2',
      requires: 'Data (+ Ordination)',
    },
    {
      id: 'beta' as const,
      label: '5 — Beta',
      desc: 'Sørensen turnover / nestedness',
      panel: 'beta' as const,
      icon: Split,
      status: !hasData ? ('blocked' as const) : hasBeta ? ('done' as const) : ('ready' as const),
      badge: hasBeta ? `Sør ${((project.analyses as any).beta.sor as number).toFixed(2)}` : 'betapart',
      hint: !hasData ? 'Needs Data' : 'R: betapart::beta.pair',
      requires: 'Data',
    },
    {
      id: 'results' as const,
      label: '6 — Results',
      desc: '.ordin.json · Export & Report',
      panel: 'results' as const,
      icon: BarChart3,
      status: !hasAnyResult ? (!hasData ? ('blocked' as const) : ('ready' as const)) : ('done' as const),
      badge: hasAnyResult ? `${Object.keys(project.analyses).length} analyses` : '— none yet —',
      hint: hasAnyResult ? 'Reproducible bundle — download & share' : 'Appears only after at least one explicit Run (JASP-like live stack, but gated for audit)',
      requires: '≥1 analysis',
    },
  ];
  const done = steps.filter((s) => s.status === 'done').length;
  return { steps, hasData, hasAnyResult, done, total: steps.length };
}

export function Sidebar() {
  const project = useOrdinStore((s) => s.project);
  const setPanel = useOrdinStore((s) => s.setPanel);
  const setImportOpen = useOrdinStore((s) => s.setImportOpen);
  const setSidebarOpen = useOrdinStore((s) => s.setSidebarOpen);
  const active = useOrdinStore((s) => s.project.view.activePanel);
  const { steps, done } = useWorkflow();
  const [filter, setFilter] = useState('');

  const filtered = steps.filter((s) => `${s.label} ${s.desc}`.toLowerCase().includes(filter.toLowerCase()));

  return (
    <div className="w-[320px] shrink-0 bg-[#1f1f20] border-r border-[#2d2d30] flex flex-col text-sm overflow-hidden">
      {/* header */}
      <div className="h-9 flex items-center px-3 gap-2 border-b border-[#2d2d30] shrink-0">
        <span className="text-[11px] font-semibold tracking-widest text-[#858585]">EXPLORER — WORKFLOW</span>
        <span className="ml-auto flex items-center gap-1">
          <button onClick={() => setImportOpen(true)} title="Import — popup (R: read.csv)" className="w-6 h-6 grid place-items-center rounded hover:bg-[#2a2a2a] text-[#858585] hover:text-white">
            <Upload size={14} />
          </button>
          <button onClick={() => setSidebarOpen(false)} title="Collapse — ⌘B" className="w-6 h-6 grid place-items-center rounded hover:bg-[#2a2a2a] text-[#858585] hover:text-white">
            <PanelLeftClose size={14} />
          </button>
        </span>
      </div>

      {/* progress — enterprise like JASP's left data / right results split */}
      <div className="p-3 border-b border-[#2d2d30] bg-[#252526]/60">
        <div className="flex items-center justify-between text-xs">
          <span className="text-[#858585] flex items-center gap-1">
            <Eye size={12} /> Workflow
          </span>
          <span className="text-[#7bd49e] font-medium">{done}/6 done</span>
        </div>
        <div className="mt-2 h-1.5 rounded-full bg-[#2d2d30] overflow-hidden">
          <div className="h-full bg-[#2e8b57] transition-all" style={{ width: `${(done / 6) * 100}%` }} />
        </div>
        <div className="mt-2 text-[11px] leading-relaxed text-[#858585]">
          Like <b className="text-[#cccccc]">JASP/jamovi</b>: data left, results right — but here <b className="text-[#cccccc]">gated & auditable</b> (R/Python style): load → validate → explicit <code>Run</code> → Results stack with provenance. Not live until you ask.
        </div>
      </div>

      {/* filter */}
      <div className="p-2 shrink-0">
        <div className="relative">
          <Search size={14} className="absolute left-2 top-2.5 text-[#858585]" />
          <Input value={filter} onChange={(e) => setFilter(e.target.value)} placeholder="Filter workflow… (e.g. ordination, tests)" className="pl-7 h-7 text-xs bg-[#252526]" />
        </div>
      </div>

      {/* workflow stepper — the core explainer */}
      <div className="flex-1 overflow-auto px-2 py-1">
        <div className="relative pl-4">
          {/* vertical line */}
          <div className="absolute left-[18px] top-3 bottom-3 w-px bg-[#2d2d30]" />
          <div className="space-y-1">
            {filtered.map((st) => {
              const Icon = st.icon;
              const isActive = active === st.panel;
              const blocked = st.status === 'blocked';
              const done = st.status === 'done';
              return (
                <button
                  key={st.id}
                  onClick={() => !blocked && setPanel(st.panel)}
                  disabled={blocked}
                  title={blocked ? `Blocked — requires ${st.requires}` : st.hint}
                  className={`relative w-full text-left flex gap-3 p-2 rounded-lg border transition-colors ${isActive ? 'bg-[#2e8b57] border-[#2e8b57] text-white shadow' : blocked ? 'bg-[#1e1e1e] border-[#2d2d30] border-dashed opacity-60 cursor-not-allowed' : 'bg-[#252526] border-[#2d2d30] hover:bg-[#2a2a2a] hover:border-[#3e3e42]'}`}
                >
                  {/* step dot */}
                  <span className={`shrink-0 w-7 h-7 rounded-full grid place-items-center border ${done ? 'bg-[#2e8b57] border-[#2e8b57] text-white' : blocked ? 'bg-[#1e1e1e] border-[#3e3e42] text-[#858585]' : isActive ? 'bg-white text-[#2e8b57] border-white' : 'bg-[#2d2d30] border-[#3e3e42] text-[#858585]'}`}>
                    {blocked ? <Lock size={13} /> : done ? <Check size={14} /> : <Icon size={14} />}
                  </span>
                  <span className="min-w-0 flex-1">
                    <span className={`text-xs font-semibold flex items-center gap-1.5 ${isActive ? 'text-white' : blocked ? 'text-[#858585]' : 'text-[#cccccc]'}`}>
                      {st.label}
                      <span className={`ml-auto text-[11px] px-1.5 py-0.5 rounded ${done ? 'bg-white/20 text-white' : blocked ? 'bg-[#3e3e42] text-[#858585]' : isActive ? 'bg-white/20 text-white' : 'bg-[#3e3e42] text-[#cccccc]'}`}>{st.badge}</span>
                    </span>
                    <span className={`text-[11px] leading-tight block mt-0.5 ${isActive ? 'text-white/80' : 'text-[#858585]'}`}>{st.desc}</span>
                    <span className={`text-[11px] leading-relaxed block mt-1 ${isActive ? 'text-white/70' : 'text-[#858585]'}`}>{st.hint}</span>
                  </span>
                </button>
              );
            })}
          </div>
        </div>

        {/* quick actions — JASP-like ribbon shortcuts */}
        <Section title="QUICK ACTIONS — like JASP ribbon">
          <div className="grid grid-cols-2 gap-1.5">
            <Button variant="subtle" className="h-7 text-xs justify-start" onClick={() => setPanel('data')}>
              <FileSpreadsheet size={12} className="mr-1" /> Data
            </Button>
            <Button variant="subtle" className="h-7 text-xs justify-start" onClick={() => setImportOpen(true)}>
              <Upload size={12} className="mr-1" /> Import
            </Button>
            <Button variant="outline" className="h-7 text-xs" onClick={() => setPanel('ordination')}>
              <Play size={12} className="mr-1" /> Run next
            </Button>
            <Button variant="outline" className="h-7 text-xs" onClick={() => setPanel('results')}>
              <BarChart3 size={12} className="mr-1" /> Results
            </Button>
          </div>
          <div className="mt-2 rounded-md bg-[#1e1e1e] border border-[#2d2d30] p-2 text-[11px] leading-relaxed text-[#858585]">
            <b className="text-[#cccccc]">R equivalent:</b> <code className="text-white">dune &lt;- read.csv(); metaMDS(dune); inext(); adonis2(); beta.pair()</code> — here each stage maps to a panel with explicit <code>Run</code>, provenance, and <code>.ordin.json</code> lineage. JASP auto-updates live; Ördin gates for enterprise audit but preserves the left→right feel.
          </div>
        </Section>

        <Section title="WORKSPACE — live">
          <div className="space-y-1">
            {(() => {
              const sp = project.data.species;
              const env = project.data.env;
              const valid = !!sp && sp.rownames.length >= 3 && sp.columns.length >= 2;
              return (
                <>
                  <div className="flex items-center justify-between px-2 py-1.5 rounded bg-[#252526] border border-[#2d2d30]">
                    <span className="flex items-center gap-2">
                      <Database size={14} className="text-[#2e8b57]" /> Species
                    </span>
                    <Badge variant={sp ? 'success' : 'neutral'}>{sp ? `${sp.rownames.length}×${sp.columns.length}` : '— empty —'}</Badge>
                  </div>
                  <div className="flex items-center justify-between px-2 py-1.5 rounded bg-[#252526] border border-[#2d2d30]">
                    <span className="flex items-center gap-2">
                      <FileSpreadsheet size={14} className="text-[#ffa500]" /> Env
                    </span>
                    <Badge variant={env ? 'info' : 'neutral'}>{env ? `${env.columns.length} vars` : '—'}</Badge>
                  </div>
                  <div className={`flex items-center justify-between px-2 py-1.5 rounded border ${valid ? 'bg-[#2e8b5720] border-[#2e8b57]/15' : 'bg-[#3e3e42]/40 border-[#3e3e42] border-dashed'}`}>
                    <span className={`flex items-center gap-2 ${valid ? 'text-[#2e8b57]' : 'text-[#858585]'}`}>Validation</span>
                    <Badge variant={valid ? 'success' : 'neutral'}>{!sp ? '— no data —' : valid ? 'OK' : 'blocked'}</Badge>
                  </div>
                </>
              );
            })()}
          </div>
        </Section>
      </div>

      <div className="p-2 border-t border-[#2d2d30] bg-[#252526]/50 shrink-0">
        <div className="text-xs font-medium text-[#cccccc] truncate flex items-center gap-1">
          <Clock3 size={12} className="text-[#858585]" /> Project: {project.meta.name}
        </div>
        <div className="text-[11px] text-[#858585]">.ordin.json • {Object.keys(project.analyses).length} analyses • reproducible</div>
      </div>
    </div>
  );
}
