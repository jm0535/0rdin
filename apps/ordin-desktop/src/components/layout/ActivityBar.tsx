import { useOrdinStore, type PanelId } from '@ordin/core';
import { LayoutDashboard, Database, Leaf, Orbit, FlaskConical, Split, BarChart3, GitBranch, Beaker, Settings, HelpCircle, Search as SearchIcon } from 'lucide-react';

const items: { id: PanelId; icon: React.ComponentType<any>; label: string; kbd?: string }[] = [
  { id: 'dashboard', icon: LayoutDashboard, label: 'Dashboard', kbd: '1' },
  { id: 'data', icon: Database, label: 'Data', kbd: '2' },
  { id: 'diversity', icon: Leaf, label: 'Diversity', kbd: '3' },
  { id: 'beta', icon: Split, label: 'Beta', kbd: '4' },
  { id: 'ordination', icon: Orbit, label: 'Ordination', kbd: '5' },
  { id: 'tests', icon: FlaskConical, label: 'Tests', kbd: '6' },
  { id: 'classification', icon: GitBranch, label: 'Classification', kbd: '7' },
  { id: 'traits', icon: Beaker, label: 'Traits', kbd: '8' },
  { id: 'results', icon: BarChart3, label: 'Results', kbd: '9' },
];

export function ActivityBar() {
  const active = useOrdinStore((s) => s.project.view.activePanel);
  const setPanel = useOrdinStore((s) => s.setPanel);
  const setCommandOpen = useOrdinStore((s) => s.setCommandOpen);
  return (
    <div className="w-[52px] shrink-0 bg-[#181818] border-r border-[#2d2d30] flex flex-col items-center py-2 gap-0.5 select-none">
      {/* top search trigger — popup, not a panel */}
      <button
        onClick={() => setCommandOpen(true)}
        title="Command palette — ⌘K"
        className="w-9 h-9 rounded-lg flex items-center justify-center text-[#858585] hover:text-white hover:bg-[#2a2a2a] transition-colors mb-1"
      >
        <SearchIcon size={18} />
      </button>
      <div className="w-6 h-px bg-[#2d2d30] my-1" />
      {items.map((it) => {
        const Icon = it.icon;
        const isActive = active === it.id;
        return (
          <button
            key={it.id}
            onClick={() => setPanel(it.id)}
            title={`${it.label} — ${it.kbd}`}
            className={`relative w-9 h-9 rounded-lg flex items-center justify-center transition-all ${
              isActive ? 'bg-[#2e8b57] text-white shadow-sm' : 'text-[#858585] hover:text-white hover:bg-[#2a2a2a]'
            }`}
          >
            {isActive && <span className="absolute -left-[8px] top-1.5 bottom-1.5 w-0.5 rounded bg-white/80" />}
            <Icon size={18} />
          </button>
        );
      })}
      <div className="mt-auto flex flex-col gap-0.5 w-full items-center pt-2 border-t border-[#2d2d30]/60">
        <button
          onClick={() => setPanel('settings')}
          title="Settings"
          className={`w-9 h-9 rounded-lg flex items-center justify-center ${active === 'settings' ? 'bg-[#2e8b57] text-white' : 'text-[#858585] hover:text-white hover:bg-[#2a2a2a]'}`}
        >
          <Settings size={18} />
        </button>
        <button
          onClick={() => setPanel('help')}
          title="Help — SQL + webR docs"
          className={`w-9 h-9 rounded-lg flex items-center justify-center ${active === 'help' ? 'bg-[#2e8b57] text-white' : 'text-[#858585] hover:text-white hover:bg-[#2a2a2a]'}`}
        >
          <HelpCircle size={18} />
        </button>
      </div>
    </div>
  );
}
