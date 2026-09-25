import { useOrdinStore } from '@ordin/core';
import { CheckCircle2, Database, Cpu, Leaf } from 'lucide-react';

export function StatusBar() {
  const sp = useOrdinStore((s) => s.project.data.species);
  const webrReady = useOrdinStore((s) => s.webrReady);
  const inspectorOpen = useOrdinStore((s) => s.ui.inspectorOpen);
  const sidebarOpen = useOrdinStore((s) => s.ui.sidebarOpen);

  return (
    <div className="h-6 shrink-0 flex items-center px-2.5 bg-[#0f2e1f] text-white text-[11px] gap-2 border-t border-[#1e5f3f]">
      <span className="flex items-center gap-1">
        <CheckCircle2 size={12} className="text-[#7bd49e]" /> Ready
      </span>
      <span className="opacity-30">|</span>
      <span className="flex items-center gap-1">
        <Database size={11} className="opacity-70" /> {sp ? `${sp.rownames.length}×${sp.columns.length}` : 'no matrix'}
      </span>
      <span className="opacity-30">|</span>
      <span className="flex items-center gap-1">
        <Cpu size={11} className="opacity-70" /> webR {webrReady ? 'ready' : 'loading…'}
      </span>
      <span className="hidden sm:inline opacity-30">|</span>
      <span className="hidden sm:inline-flex items-center gap-1">
        <Leaf size={11} className="opacity-70" /> vegan · iNEXT · betapart
      </span>
      <span className="ml-auto hidden md:flex items-center gap-2 text-white/70">
        <span>
          {sidebarOpen ? '◧' : '◨'} Explorer
        </span>
        <span>•</span>
        <span>{inspectorOpen ? '◩' : '◪'} Inspector</span>
        <span className="opacity-30">|</span>
        <span>Tauri • DuckDB-WASM • deck.gl • webR</span>
      </span>
    </div>
  );
}
