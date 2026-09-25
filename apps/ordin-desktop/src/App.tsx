import { useEffect } from 'react';
import { useOrdinStore } from '@ordin/core';
import { ActivityBar } from './components/layout/ActivityBar';
import { Sidebar } from './components/layout/Sidebar';
import { RightInspector } from './components/layout/RightInspector';
import { StatusBar } from './components/layout/StatusBar';
import { Toolbar } from './components/layout/Toolbar';
import { CommandPalette } from './components/layout/CommandPalette';
import { ImportDialog } from './components/layout/ImportDialog';
import { DashboardPanel } from './components/panels/DashboardPanel';
import { DataPanel } from './components/panels/DataPanel';
import { OrdinationPanel } from './components/panels/OrdinationPanel';
import { DiversityPanel } from './components/panels/DiversityPanel';
import { TestsPanel } from './components/panels/TestsPanel';
import { BetaPanel } from './components/panels/BetaPanel';
import { ClassificationPanel } from './components/panels/ClassificationPanel';
import { TraitsPanel } from './components/panels/TraitsPanel';
import { ResultsPanel } from './components/panels/ResultsPanel';
import { SettingsPanel } from './components/panels/SettingsPanel';
import { HelpPanel } from './components/panels/HelpPanel';
import { PluginMarketplace } from './components/layout/PluginMarketplace';
import { ErrorBoundary } from './components/ErrorBoundary';
import { PanelLeft, PanelRight } from 'lucide-react';

export default function App() {
  const panel = useOrdinStore((s) => s.project.view.activePanel);
  const ui = useOrdinStore((s) => s.ui);
  const set = useOrdinStore((s) => s);

  // global hotkeys — statistical-focused
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'b') {
        e.preventDefault();
        set.setSidebarOpen(!useOrdinStore.getState().ui.sidebarOpen);
      }
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'i') {
        e.preventDefault();
        set.setInspectorOpen(!useOrdinStore.getState().ui.inspectorOpen);
      }
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
        // handled in CommandPalette too, but we keep here for race
      }
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [set]);

  return (
    <div className="flex flex-col h-screen bg-[#121214] text-[#cccccc] selection:bg-[#2e8b57]/30">
      {/* Titlebar — Tauri drag region */}
      <div className="h-8 flex items-center px-3 bg-[#0f0f0f] border-b border-[#2d2d30] text-xs select-none shrink-0" data-tauri-drag-region>
        <span className="w-2 h-2 rounded-full bg-[#2e8b57] shadow-[0_0_8px_rgba(46,139,87,0.6)]" />
        <span className="ml-2 font-semibold tracking-tight">Ördin 4</span>
        <span className="ml-2 text-[#858585] hidden sm:inline">— Community Ecology, statistical workbench · Tauri • React • Vite • Zustand • DuckDB-WASM • webR</span>
        <span className="ml-auto hidden md:flex items-center gap-2 text-[#858585]">
          <span className="w-1.5 h-1.5 rounded-full bg-[#4a90e2] animate-pulse" /> DuckDB in-browser
          <span className="w-px h-3 bg-[#2d2d30]" /> vegan / iNEXT via webR Worker
        </span>
      </div>

      <div className="flex flex-1 min-h-0 overflow-hidden">
        <ActivityBar />

        {/* left sidebar — collapsible popup-like: slides, not always docked, but here as push */}
        {ui.sidebarOpen ? (
          <Sidebar />
        ) : (
          <div className="w-0 shrink-0 relative">
            <button
              onClick={() => set.setSidebarOpen(true)}
              title="Show explorer — ⌘B"
              className="absolute left-0 top-2 z-10 w-6 h-7 grid place-items-center rounded-r-md bg-[#252526] border border-l-0 border-[#2d2d30] text-[#858585] hover:text-white shadow"
            >
              <PanelLeft size={14} />
            </button>
          </div>
        )}

        <div className="flex-1 flex flex-col min-w-0 bg-[#1e1e1e]">
          <Toolbar />
          <div className="flex-1 overflow-auto p-4 md:p-5 scroll-smooth">
            {/* subtle distinct background: paper grid, not map */}
            <div className="max-w-[1120px] mx-auto">
              <ErrorBoundary>
                {panel === 'dashboard' && <DashboardPanel />}
                {panel === 'data' && <DataPanel />}
                {panel === 'ordination' && <OrdinationPanel />}
                {panel === 'diversity' && <DiversityPanel />}
                {panel === 'tests' && <TestsPanel />}
                {panel === 'beta' && <BetaPanel />}
                {panel === 'classification' && <ClassificationPanel />}
                {panel === 'traits' && <TraitsPanel />}
                {panel === 'results' && <ResultsPanel />}
                {panel === 'settings' && <SettingsPanel />}
                {panel === 'help' && <HelpPanel />}
              </ErrorBoundary>
            </div>
          </div>
        </div>

        {/* right inspector — popups / details */}
        {ui.inspectorOpen ? (
          <RightInspector />
        ) : (
          <div className="w-0 shrink-0 relative">
            <button
              onClick={() => set.setInspectorOpen(true)}
              title="Show inspector — ⌘I (popups, SQL, details)"
              className="absolute right-0 top-2 z-10 w-6 h-7 grid place-items-center rounded-l-md bg-[#252526] border border-r-0 border-[#2d2d30] text-[#858585] hover:text-white shadow"
            >
              <PanelRight size={14} />
            </button>
          </div>
        )}
      </div>

      <StatusBar />

      {/* popups — command palette + import dialog + plugin marketplace live above everything */}
      <CommandPalette />
      <ImportDialog />
      <PluginMarketplace />
    </div>
  );
}
