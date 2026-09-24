import { useOrdinStore } from '@ordin/core';

export function Sidebar() {
  const project = useOrdinStore((s) => s.project);
  const sp = project.data.species;
  const env = project.data.env;
  const setPanel = useOrdinStore((s) => s.setPanel);
  return (
    <div className="w-[260px] bg-[#252526] border-r border-[#2d2d30] flex flex-col text-sm">
      <div className="px-3 py-2 text-[11px] font-semibold tracking-widest text-[#858585]">EXPLORER</div>
      <div className="px-2 py-2 space-y-4 overflow-auto">
        <div>
          <div className="text-[11px] text-[#858585] px-2 mb-1">▼ DATA SOURCES</div>
          <button onClick={() => setPanel('data')} className="w-full text-left px-2 py-1 hover:bg-[#2a2a2a] rounded">📄 Current Dataset</button>
          <button onClick={() => setPanel('data')} className="w-full text-left px-2 py-1 hover:bg-[#2a2a2a] rounded">📥 Import New File</button>
          <button onClick={() => setPanel('data')} className="w-full text-left px-2 py-1 hover:bg-[#2a2a2a] rounded">📚 Sample Datasets</button>
        </div>
        <div>
          <div className="text-[11px] text-[#858585] px-2 mb-1">▼ WORKSPACE</div>
          <div className="px-2 py-1 flex items-center justify-between">
            <span>📊 Current Dataset</span>
            <span className="text-xs bg-[#3e3e42] px-1.5 py-0.5 rounded">{sp ? `${sp.rownames.length}×${sp.columns.length}` : '—'}</span>
          </div>
          <div className="px-2 py-1 flex items-center justify-between">
            <span>🌡️ Env</span>
            <span className="text-xs bg-[#3e3e42] px-1.5 py-0.5 rounded">{env ? `${env.columns.length} vars` : '—'}</span>
          </div>
          <div className="px-2 py-1 flex items-center justify-between">
            <span>✅ Validation</span>
            <span className="text-xs bg-[#2e8b5720] text-[#2e8b57] px-1.5 py-0.5 rounded">OK</span>
          </div>
        </div>
        <div>
          <div className="text-[11px] text-[#858585] px-2 mb-1">▼ LAYERS</div>
          <div className="px-2 py-1 text-[#858585]">MapLibre layers (PMTiles, GeoJSON) — new in 4.0</div>
        </div>
      </div>
      <div className="mt-auto p-2 border-t border-[#2d2d30] text-xs text-[#858585]">
        <div>Project: {project.meta.name}</div>
        <div className="truncate">.ordin.json — like .geolibre.json</div>
      </div>
    </div>
  );
}
