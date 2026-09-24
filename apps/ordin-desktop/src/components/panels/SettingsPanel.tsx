export function SettingsPanel() {
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">⚙ Settings</h2>
      <div className="bg-[#252526] border border-[#3e3e42] rounded p-4">
        <label className="text-sm block mb-1">Map style</label>
        <select className="bg-[#3c3c3c] border border-[#3e3e42] rounded px-2 py-1 text-sm w-full">
          <option>MapLibre Demo Tiles</option>
          <option>Carto Dark Matter</option>
          <option>OpenStreetMap</option>
        </select>
      </div>
    </div>
  );
}
