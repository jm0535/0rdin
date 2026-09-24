import { useOrdinStore } from '@ordin/core';
import { Card, Badge } from '@ordin/ui';

export function DashboardPanel() {
  const setPanel = useOrdinStore((s) => s.setPanel);
  return (
    <div className="space-y-6">
      <div className="text-center py-8">
        <div className="text-6xl font-black text-[#2e8b57]">Ö</div>
        <h1 className="text-3xl font-bold mt-2">Ördin 4.0</h1>
        <p className="text-[#858585] mt-1">GeoLibre Edition — Tauri + React + Vite + MapLibre + DuckDB-WASM + webR</p>
        <div className="flex justify-center gap-2 mt-4">
          <Badge variant="success">Open Source</Badge>
          <Badge variant="info">Cloud-Native</Badge>
          <Badge variant="warn">WASM</Badge>
        </div>
      </div>

      <div className="grid grid-cols-4 gap-3">
        {[
          { v: '9', k: 'Ordination Methods', c: 'from-[#2e8b57] to-[#1e5f3f]' },
          { v: 'WASM', k: 'webR + DuckDB', c: 'from-[#4a90e2] to-[#2563a8]' },
          { v: 'MapLibre', k: 'Site Map', c: 'from-[#ffa500] to-[#cc8400]' },
          { v: '4.0', k: 'Tauri Shell', c: 'from-[#9b59b6] to-[#6c3483]' },
        ].map((x) => (
          <Card key={x.k} className={`p-4 text-center bg-gradient-to-br ${x.c} border-0`}>
            <div className="text-2xl font-bold text-white">{x.v}</div>
            <div className="text-xs text-white/80">{x.k}</div>
          </Card>
        ))}
      </div>

      <div className="grid grid-cols-4 gap-3">
        {[
          { icon: '📥', title: 'Import Data', desc: 'CSV/Parquet via DuckDB', panel: 'data' as const },
          { icon: '≋', title: 'Diversity', desc: 'iNEXT, Shannon, Simpson', panel: 'diversity' as const },
          { icon: '⬡', title: 'Ordination', desc: 'NMDS, PCA, CA…', panel: 'ordination' as const },
          { icon: '∷', title: 'Beta', desc: 'Turnover / nestedness', panel: 'beta' as const },
        ].map((c) => (
          <Card key={c.title} className="p-4 text-center">
            <div className="text-3xl mb-2">{c.icon}</div>
            <div className="font-semibold">{c.title}</div>
            <div className="text-xs text-[#858585] mb-3">{c.desc}</div>
            <button onClick={() => setPanel(c.panel)} className="text-xs bg-[#2e8b57] text-white px-3 py-1 rounded hover:bg-[#257a4a]">
              Open →
            </button>
          </Card>
        ))}
      </div>

      <Card className="p-4">
        <h3 className="font-semibold text-[#2e8b57]">How this mirrors GeoLibre</h3>
        <ul className="list-disc pl-5 text-sm text-[#858585] space-y-1 mt-2">
          <li>
            <code className="text-white">apps/ordin-desktop</code> = <code className="text-white">apps/geolibre-desktop</code> (Vite + Tauri)
          </li>
          <li>
            <code className="text-white">packages/core</code> holds the single <code className="text-white">.ordin.json</code> schema + Zustand store — like <code className="text-white">.geolibre.json</code>
          </li>
          <li>
            <code className="text-white">packages/map</code> wraps MapLibre lifecycle; PMTiles-ready
          </li>
          <li>
            <code className="text-white">packages/processing</code> is the WASM bridge — here webR (vegan/iNEXT), in GeoLibre Whitebox
          </li>
          <li>Shared <code className="text-white">workers/*</code> and <code className="text-white">SQL Workspace</code> via DuckDB-WASM</li>
        </ul>
      </Card>
    </div>
  );
}
