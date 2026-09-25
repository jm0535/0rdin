import { useOrdinStore } from '@ordin/core';
import { Search, Upload, Download, Command, PanelRight, PanelLeft, Sparkles, Beaker } from 'lucide-react';
import { Button, Input } from '@ordin/ui';

export function Toolbar() {
  const panel = useOrdinStore((s) => s.project.view.activePanel);
  const ui = useOrdinStore((s) => s.ui);
  const set = useOrdinStore((s) => s);
  const titles: Record<string, { title: string; subtitle: string }> = {
    dashboard: { title: 'Dashboard', subtitle: 'Overview • quick start • reproducibility' },
    data: { title: 'Data', subtitle: 'Species matrix + env • DuckDB-WASM SQL • validation' },
    diversity: { title: 'Diversity', subtitle: 'iNEXT • Shannon / Simpson / Hill • rarefaction' },
    ordination: { title: 'Ordination', subtitle: '9 methods • NMDS PCA CA DCA PCoA CCA RDA dbRDA CAP • deck.gl biplots' },
    tests: { title: 'Tests', subtitle: 'PERMANOVA • ANOSIM • Mantel • envfit • webR' },
    beta: { title: 'Beta diversity', subtitle: 'Sørensen turnover / nestedness • betapart' },
    settings: { title: 'Settings', subtitle: 'Theme • webR • reproducibility' },
    help: { title: 'Help', subtitle: 'SQL Workspace • vegan / iNEXT docs' },
  };
  const cur = titles[panel] ?? { title: panel, subtitle: '' };

  return (
    <div className="h-[44px] shrink-0 flex items-center gap-2 px-3 bg-[#252526]/80 backdrop-blur border-b border-[#2d2d30] sticky top-0 z-10">
      {/* left: sidebar toggle + breadcrumb */}
      <button
        onClick={() => set.setSidebarOpen(!ui.sidebarOpen)}
        title="Toggle explorer — ⌘B"
        className="w-7 h-7 grid place-items-center rounded-md hover:bg-[#2a2a2a] text-[#858585] hover:text-white"
      >
        <PanelLeft size={16} />
      </button>
      <div className="hidden sm:flex items-center gap-2 text-sm min-w-0">
        <span className="font-medium text-[#cccccc]">{cur.title}</span>
        <span className="text-[#3e3e42]">•</span>
        <span className="text-xs text-[#858585] truncate">{cur.subtitle}</span>
      </div>

      {/* center: search (command palette entry) */}
      <div className="mx-auto hidden md:flex items-center gap-2">
        <div className="relative">
          <Search size={14} className="absolute left-2.5 top-2.5 text-[#858585]" />
          <Input readOnly onFocus={() => set.setCommandOpen(true)} placeholder="Search datasets, methods, SQL…  ⌘K" className="pl-8 w-[360px] h-8 text-xs bg-[#1e1e1e] border-[#3e3e42] cursor-pointer" />
        </div>
        <Button variant="ghost" onClick={() => set.setCommandOpen(true)} className="h-8 px-2 text-xs">
          <Command size={14} className="mr-1" /> Palette
        </Button>
      </div>

      {/* right: actions + inspector toggle */}
      <div className="ml-auto flex items-center gap-1">
        <Button variant="subtle" onClick={() => set.setImportOpen(true)} className="hidden sm:inline-flex">
          <Upload size={14} className="mr-1.5" /> Import
        </Button>
        <Button variant="ghost" onClick={() => { const blob=new Blob([JSON.stringify(useOrdinStore.getState().project, null, 2)],{type:'application/json'}); const url=URL.createObjectURL(blob); const a=document.createElement('a'); a.href=url; a.download=`${useOrdinStore.getState().project.meta.name || 'ordin'}.ordin.json`; a.click(); URL.revokeObjectURL(url); }} className="hidden sm:inline-flex h-8">
          <Download size={14} className="mr-1" /> Export
        </Button>
        <span className="w-px h-5 bg-[#2d2d30] mx-1" />
        <span className="hidden lg:flex items-center gap-1.5 text-xs text-[#858585] mr-1">
          <Beaker size={14} className="text-[#2e8b57]" /> webR
          <Sparkles size={12} className="text-[#4a90e2]" /> DuckDB
        </span>
        <button
          onClick={() => set.setInspectorOpen(!ui.inspectorOpen)}
          title="Toggle inspector — popups / details"
          className={`w-7 h-7 grid place-items-center rounded-md ${ui.inspectorOpen ? 'bg-[#2e8b57] text-white' : 'hover:bg-[#2a2a2a] text-[#858585] hover:text-white'}`}
        >
          <PanelRight size={16} />
        </button>
      </div>
    </div>
  );
}
