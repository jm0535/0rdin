import { Card, Button } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
export function BetaPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">∷ Beta — betapart via webR</h2>
      <Card className="p-3"><img src="/assets/plots/beta.png" alt="beta" className="w-full bg-white rounded"/><Button className="mt-3 w-full" disabled={!hasData}>▶ Partition Beta (turnover/nestedness)</Button></Card>
    </div>
  );
}
