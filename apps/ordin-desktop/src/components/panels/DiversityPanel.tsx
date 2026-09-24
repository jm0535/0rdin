import { Card, Button } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
export function DiversityPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">≋ Diversity — iNEXT via webR</h2>
      {!hasData && <div className="text-sm text-[#d4a017] border border-[#d4a017]/30 bg-[#d4a0170a] p-3 rounded">Load data first.</div>}
      <div className="grid grid-cols-2 gap-4">
        <Card className="p-3"><h3 className="font-semibold">iNEXT rarefaction</h3><img src="/assets/plots/inext.png" alt="iNEXT" className="w-full bg-white rounded mt-2" /><Button className="mt-2 w-full" disabled={!hasData}>▶ Run iNEXT (webR)</Button></Card>
        <Card className="p-3"><h3 className="font-semibold">Indices</h3><img src="/assets/plots/indices.png" alt="indices" className="w-full bg-white rounded mt-2" /><Button className="mt-2 w-full" disabled={!hasData}>▶ Calculate Shannon/Simpson</Button></Card>
      </div>
    </div>
  );
}
