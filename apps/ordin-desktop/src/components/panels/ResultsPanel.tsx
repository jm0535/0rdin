import { Card } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
export function ResultsPanel() {
  const project = useOrdinStore((s) => s.project);
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">▤ Results — .ordin.json</h2>
      <Card className="p-3"><pre className="text-xs bg-[#1e1e1e] p-3 rounded overflow-auto max-h-[60vh]">{JSON.stringify(project, null, 2).slice(0, 4000)}</pre></Card>
    </div>
  );
}
