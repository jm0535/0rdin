import { useOrdinStore, type PanelId } from '@ordin/core';

const items: { id: PanelId; icon: string; label: string }[] = [
  { id: 'dashboard', icon: '⌂', label: 'Home' },
  { id: 'data', icon: '◧', label: 'Data' },
  { id: 'diversity', icon: '≋', label: 'Diversity' },
  { id: 'ordination', icon: '⬡', label: 'Ordination' },
  { id: 'tests', icon: '⚗', label: 'Tests' },
  { id: 'beta', icon: '∷', label: 'Beta' },
  { id: 'results', icon: '▤', label: 'Results' },
  { id: 'settings', icon: '⚙', label: 'Settings' },
  { id: 'help', icon: '?', label: 'Help' },
];

export function ActivityBar() {
  const active = useOrdinStore((s) => s.project.view.activePanel);
  const setPanel = useOrdinStore((s) => s.setPanel);
  return (
    <div className="w-12 bg-[#181818] border-r border-[#2d2d30] flex flex-col items-center py-2 gap-1">
      {items.map((it) => (
        <button
          key={it.id}
          onClick={() => setPanel(it.id)}
          title={it.label}
          className={`w-9 h-9 rounded flex items-center justify-center text-lg transition-colors ${
            active === it.id ? 'bg-[#2e8b57] text-white' : 'text-[#858585] hover:text-white hover:bg-[#2a2a2a]'
          }`}
        >
          {it.icon}
        </button>
      ))}
    </div>
  );
}
