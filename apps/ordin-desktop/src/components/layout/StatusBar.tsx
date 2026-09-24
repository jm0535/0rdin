import { useOrdinStore } from '@ordin/core';

export function StatusBar() {
  const sp = useOrdinStore((s) => s.project.data.species);
  const webrReady = useOrdinStore((s) => s.webrReady);
  return (
    <div className="h-6 flex items-center px-3 bg-[#2e8b57] text-white text-xs gap-3">
      <span>● Ready</span>
      <span className="opacity-60">|</span>
      <span>{sp ? `${sp.rownames.length}×${sp.columns.length} matrix` : 'No data'}</span>
      <span className="opacity-60">|</span>
      <span>webR {webrReady ? 'ready' : 'loading…'}</span>
      <span className="opacity-60">|</span>
      <span>Ördin 4.0 — statistical engine (vegan/iNEXT/betapart via webR)</span>
      <span className="ml-auto">Tauri • DuckDB-WASM • deck.gl • webR</span>
    </div>
  );
}
