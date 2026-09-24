export function SettingsPanel() {
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">⚙ Settings — theme, webR, reproducibility</h2>
      <p className="text-sm text-[#858585]">Reproducibility is first-class: every run is exportable as <code>.ordin.json</code> (like GeoLibre's <code>.geolibre.json</code>).</p>
      <div className="bg-[#252526] border border-[#3e3e42] rounded p-4 space-y-3">
        <div>
          <label className="text-sm block mb-1">Theme</label>
          <select className="bg-[#3c3c3c] border border-[#3e3e42] rounded px-2 py-1 text-sm w-full">
            <option>Dark (default)</option>
            <option>Light</option>
          </select>
        </div>
        <div>
          <label className="text-sm block mb-1">webR / reproducibility</label>
          <div className="text-xs text-[#858585]">webR Worker (vegan/iNEXT) is enabled by default. Optional site map (MapLibre) only appears if env has lon/lat.</div>
        </div>
      </div>
    </div>
  );
}
