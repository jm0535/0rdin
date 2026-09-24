import { useOrdinStore } from '@ordin/core';

export function Toolbar() {
  const panel = useOrdinStore((s) => s.project.view.activePanel);
  const title: Record<string, string> = {
    dashboard: 'Dashboard — Next-Gen Community Ecology (GeoLibre stack)',
    data: 'Data — CSV/Parquet via DuckDB-WASM',
    diversity: 'Diversity — iNEXT + Hill numbers (webR)',
    ordination: 'Ordination — 9 methods (NMDS, PCA, CA, DCA, PCoA, CCA, RDA, dbRDA, CAP)',
    tests: 'Tests — PERMANOVA / ANOSIM / Mantel / envfit',
    beta: 'Beta — turnover / nestedness (betapart)',
    results: 'Results — .ordin.json project',
    settings: 'Settings — theme, map style, webR',
    help: 'Help — SQL Workspace + docs',
  };
  return (
    <div className="h-9 flex items-center px-3 bg-[#252526] border-b border-[#2d2d30] text-sm gap-3">
      <span className="text-[#858585]">Ördin</span>
      <span className="text-[#3e3e42]">/</span>
      <span className="font-medium">{title[panel] ?? panel}</span>
      <span className="ml-auto text-xs text-[#858585]">Zustand • Vite • webR Worker</span>
    </div>
  );
}
