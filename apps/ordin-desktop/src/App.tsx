import { useOrdinStore } from '@ordin/core';
import { ActivityBar } from './components/layout/ActivityBar';
import { Sidebar } from './components/layout/Sidebar';
import { StatusBar } from './components/layout/StatusBar';
import { Toolbar } from './components/layout/Toolbar';
import { DashboardPanel } from './components/panels/DashboardPanel';
import { DataPanel } from './components/panels/DataPanel';
import { OrdinationPanel } from './components/panels/OrdinationPanel';
import { DiversityPanel } from './components/panels/DiversityPanel';
import { TestsPanel } from './components/panels/TestsPanel';
import { BetaPanel } from './components/panels/BetaPanel';
import { ResultsPanel } from './components/panels/ResultsPanel';
import { SettingsPanel } from './components/panels/SettingsPanel';
import { HelpPanel } from './components/panels/HelpPanel';

export default function App() {
  const panel = useOrdinStore((s) => s.project.view.activePanel);
  return (
    <div className="flex flex-col h-screen bg-[#1e1e1e] text-[#cccccc]">
      {/* Titlebar — Tauri drag region, like GeoLibre */}
      <div className="h-8 flex items-center px-3 bg-[#181818] border-b border-[#2d2d30] text-xs select-none" data-tauri-drag-region>
        <span className="font-bold tracking-wide">Ö</span>
        <span className="ml-2 font-semibold">Ördin 4.0</span>
        <span className="ml-2 text-[#858585]">— GeoLibre Edition</span>
        <span className="ml-auto text-[#858585]">Tauri + React + Vite + MapLibre + DuckDB-WASM + webR</span>
      </div>

      <div className="flex flex-1 min-h-0">
        <ActivityBar />
        <Sidebar />
        <div className="flex-1 flex flex-col min-w-0 bg-[#1e1e1e]">
          <Toolbar />
          <div className="flex-1 overflow-auto p-4">
            {panel === 'dashboard' && <DashboardPanel />}
            {panel === 'data' && <DataPanel />}
            {panel === 'ordination' && <OrdinationPanel />}
            {panel === 'diversity' && <DiversityPanel />}
            {panel === 'tests' && <TestsPanel />}
            {panel === 'beta' && <BetaPanel />}
            {panel === 'results' && <ResultsPanel />}
            {panel === 'settings' && <SettingsPanel />}
            {panel === 'help' && <HelpPanel />}
          </div>
        </div>
      </div>

      <StatusBar />
    </div>
  );
}
