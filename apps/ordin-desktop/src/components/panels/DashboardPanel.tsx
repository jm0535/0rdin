import { useOrdinStore } from '@ordin/core';
import { Card, Badge, Button } from '@ordin/ui';
import { Leaf, Orbit, Database, FlaskConical, Split, Upload, Beaker, Sparkles, Info } from 'lucide-react';

export function DashboardPanel() {
  const setPanel = useOrdinStore((s) => s.setPanel);
  const setImportOpen = useOrdinStore((s) => s.setImportOpen);
  const setCommandOpen = useOrdinStore((s) => s.setCommandOpen);
  const loadSample = useOrdinStore((s) => s.loadSample);

  return (
    <div className="space-y-6">
      {/* hero — ecology paper, not map */}
      <div className="relative overflow-hidden rounded-2xl border border-[#2d2d30] bg-gradient-to-br from-[#1b2a1e] via-[#1e1e1e] to-[#252526] p-6 md:p-8">
        <div className="absolute inset-0 pointer-events-none opacity-[0.04]" style={{ backgroundImage: `radial-gradient(circle at 20% 30%, #2e8b57 1px, transparent 1px), radial-gradient(circle at 80% 70%, #4a90e2 1px, transparent 1px)`, backgroundSize: '28px 28px' }} />
        <div className="relative flex flex-col md:flex-row gap-6 items-start">
          <div className="flex-1">
            <div className="inline-flex items-center gap-2 text-xs font-medium text-[#7bd49e] bg-[#2e8b5720] border border-[#2e8b57]/20 rounded-full px-2.5 py-1">
              <Leaf size={14} /> Community Ecology • Next-Gen
            </div>
            <h1 className="text-3xl md:text-4xl font-black tracking-tight mt-3 flex items-center gap-2">
              <span className="inline-grid place-items-center w-9 h-9 rounded-xl bg-[#2e8b57] text-white text-xl">Ö</span>
              Ördin 4
            </h1>
            <p className="text-[#858585] mt-2 max-w-[60ch] leading-relaxed">
              Statistical workbench rebuilt on <b className="text-[#cccccc]">Tauri + React + Vite + Zustand + DuckDB-WASM + webR</b> — same hardcore stack GeoLibre uses for geospatial, now repurposed for
              <b className="text-[#cccccc]"> ordination • diversity • tests • beta</b>. No map tiles by default; deck.gl draws ordination biplots, DuckDB queries your species tables, webR runs vegan / iNEXT / betapart in a Worker.
            </p>
            <div className="flex flex-wrap gap-2 mt-4">
              <Button onClick={() => setImportOpen(true)} className="h-9">
                <Upload size={16} className="mr-1.5" /> Import dataset
              </Button>
              <Button variant="outline" onClick={async () => { await loadSample('dune'); setPanel('ordination'); }} className="h-9">
                <Orbit size={16} className="mr-1.5" /> Try dune → NMDS
              </Button>
              <Button variant="ghost" onClick={() => setCommandOpen(true)} className="h-9">
                ⌘K Command palette
              </Button>
            </div>
            <div className="flex gap-2 mt-4">
              <Badge variant="success">Open Source</Badge>
              <Badge variant="info">Reproducible .ordin.json</Badge>
              <Badge variant="warn">Runs in browser + Tauri</Badge>
            </div>
          </div>
          <Card className="w-full md:w-[340px] shrink-0 p-0 overflow-hidden">
            <div className="p-3 flex items-center gap-2 border-b border-[#2d2d30]">
              <Beaker size={14} className="text-[#2e8b57]" />
              <span className="text-xs font-semibold tracking-widest text-[#858585]">AT A GLANCE</span>
              <span className="ml-auto text-[11px] text-[#4a90e2] flex items-center gap-1">
                <Sparkles size={12} /> WASM
              </span>
            </div>
            <div className="p-4 grid grid-cols-2 gap-3">
              <div className="rounded-xl bg-[#1e1e1e] border border-[#2d2d30] p-3">
                <div className="text-2xl font-black text-white">9</div>
                <div className="text-xs text-[#858585]">Ordination methods</div>
                <div className="text-[11px] text-[#7bd49e] mt-1">NMDS → CAP</div>
              </div>
              <div className="rounded-xl bg-[#1e1e1e] border border-[#2d2d30] p-3">
                <div className="text-2xl font-black text-white">WASM</div>
                <div className="text-xs text-[#858585]">webR + DuckDB</div>
                <div className="text-[11px] text-[#4a90e2] mt-1">no R install</div>
              </div>
              <div className="rounded-xl bg-[#1e1e1e] border border-[#2d2d30] p-3">
                <div className="text-2xl font-black text-white">deck.gl</div>
                <div className="text-xs text-[#858585]">Biplots</div>
                <div className="text-[11px] text-[#ffa500] mt-1">GPU scatter</div>
              </div>
              <div className="rounded-xl bg-[#1e1e1e] border border-[#2d2d30] p-3">
                <div className="text-2xl font-black text-white">4.0</div>
                <div className="text-xs text-[#858585]">Tauri shell</div>
                <div className="text-[11px] text-[#9b59b6] mt-1">~12MB</div>
              </div>
            </div>
            <div className="px-4 pb-4 text-[11px] text-[#858585] leading-relaxed">
              <Info size={12} className="inline mr-1" /> MapLibre is <b className="text-[#cccccc]">optional</b> — only if env has <code>lon/lat</code>. The primary canvas is statistical.
            </div>
          </Card>
        </div>
      </div>

      {/* quick actions — each opens a popup or jumps to a panel */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
        {[
          { icon: Upload, title: 'Import Data', desc: 'CSV/Parquet via DuckDB', action: () => setImportOpen(true), cta: 'Open popup', accent: 'from-[#2e8b57] to-[#1e5f3f]' },
          { icon: Leaf, title: 'Diversity', desc: 'iNEXT, Shannon, Hill', action: () => setPanel('diversity'), cta: 'Open', accent: 'from-[#4a90e2] to-[#2563a8]' },
          { icon: Orbit, title: 'Ordination', desc: 'NMDS, PCA, CA… 9×', action: () => setPanel('ordination'), cta: 'Open', accent: 'from-[#ffa500] to-[#cc8400]' },
          { icon: Split, title: 'Beta', desc: 'Turnover / nestedness', action: () => setPanel('beta'), cta: 'Open', accent: 'from-[#9b59b6] to-[#6c3483]' },
        ].map((c) => {
          const Icon = c.icon;
          return (
            <Card key={c.title} className="p-4 flex flex-col gap-3 hover:border-[#3e3e42] transition-colors group">
              <div className={`w-9 h-9 rounded-lg bg-gradient-to-br ${c.accent} grid place-items-center text-white shadow`}>
                <Icon size={18} />
              </div>
              <div>
                <div className="font-semibold">{c.title}</div>
                <div className="text-xs text-[#858585]">{c.desc}</div>
              </div>
              <Button variant="subtle" onClick={c.action} className="mt-auto w-fit group-hover:bg-[#2a2a2a]">
                {c.cta} →
              </Button>
            </Card>
          );
        })}
      </div>

      {/* stack — distinct copy, not GeoLibre's marketing */}
      <Card className="p-5">
        <h3 className="font-semibold flex items-center gap-2">
          <Database size={16} className="text-[#2e8b57]" /> How this reuses GeoLibre's <em>stack</em> — not its product
        </h3>
        <p className="text-sm text-[#858585] mt-2 leading-relaxed">
          We copied the <b className="text-[#cccccc]">engineering</b> (Tauri shell, Vite, Zustand, DuckDB-WASM, deck.gl, webR/Workers, .json project file, SQL Workspace) — not the geospatial product. In Ördin, <b className="text-[#cccccc]">deck.gl = ordination scatters & biplot arrows</b>, <b className="text-[#cccccc]">DuckDB = ecology tables</b>, <b className="text-[#cccccc]">webR = vegan / iNEXT / betapart</b>. Sidebars & popups follow the same VS Code-like UX GeoLibre popularized (Explorer • Command palette • Inspector), but the content is purely statistical.
        </p>
        <div className="grid md:grid-cols-2 gap-3 mt-4 text-sm">
          <div className="rounded-lg border border-[#2d2d30] bg-[#1e1e1e] p-3">
            <div className="text-xs font-semibold tracking-widest text-[#858585]">STACK MAPPING</div>
            <ul className="mt-2 space-y-1 text-[#858585]">
              <li>
                <code className="text-white">apps/ordin-desktop</code> — Vite + Tauri (like Geolibre’s desktop)
              </li>
              <li>
                <code className="text-white">packages/core</code> — Zustand + <code className="text-white">.ordin.json</code> (like <code className="text-white">.geolibre.json</code>)
              </li>
              <li>
                <code className="text-white">packages/processing</code> — webR bridge (vs Whitebox)
              </li>
              <li>
                <code className="text-white">packages/map</code> — optional, only if <code>lon/lat</code>
              </li>
            </ul>
          </div>
          <div className="rounded-lg border border-[#2d2d30] bg-[#1e1e1e] p-3">
            <div className="text-xs font-semibold tracking-widest text-[#858585]">UX — sidebars + popups</div>
            <ul className="mt-2 space-y-1 text-[#858585]">
              <li>ActivityBar + Explorer (left) • Inspector (right) — both collapsible</li>
              <li>Command palette (⌘K) — jump to any panel or run “Load dune”</li>
              <li>Import as popup (not a page) • method configs as popovers</li>
              <li>StatusBar + SQL Workspace — DuckDB in-browser, reproducible</li>
            </ul>
          </div>
        </div>
      </Card>
    </div>
  );
}
