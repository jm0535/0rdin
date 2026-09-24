import { Card, Button } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
export function TestsPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">⚗ Tests — vegan via webR</h2>
      <div className="grid grid-cols-2 gap-4">
        <Card className="p-3"><h3 className="font-semibold">PERMANOVA (adonis2)</h3><img src="/assets/plots/permanova_variance.png" className="w-full bg-white rounded mt-2" alt="permanova"/><Button className="mt-2 w-full" disabled={!hasData}>▶ Run PERMANOVA</Button></Card>
        <Card className="p-3"><h3 className="font-semibold">ANOSIM</h3><img src="/assets/plots/anosim.png" className="w-full bg-white rounded mt-2" alt="anosim"/><Button className="mt-2 w-full" disabled={!hasData}>▶ Run ANOSIM</Button></Card>
        <Card className="p-3"><h3 className="font-semibold">Mantel</h3><img src="/assets/plots/mantel.png" className="w-full bg-white rounded mt-2" alt="mantel"/><Button className="mt-2 w-full" disabled={!hasData}>▶ Run Mantel</Button></Card>
        <Card className="p-3"><h3 className="font-semibold">envfit</h3><img src="/assets/plots/envfit.png" className="w-full bg-white rounded mt-2" alt="envfit"/><Button className="mt-2 w-full" disabled={!hasData}>▶ Run envfit</Button></Card>
      </div>
    </div>
  );
}
