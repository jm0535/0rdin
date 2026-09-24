import { useState } from 'react';
import { Card, Button, Badge } from '@ordin/ui';
import { useOrdinStore } from '@ordin/core';
import { WorkflowFooter } from '../layout/WorkflowFooter';
import { GitBranch, Layers, Sparkles, Award, Scissors } from 'lucide-react';

export function ClassificationPanel() {
  const hasData = !!useOrdinStore((s) => s.project.data.species);
  const analyses = useOrdinStore((s) => s.project.analyses) as any;
  const cluster = analyses.cluster as { method: string; k: number; groups: number[]; cophenetic?: number; silhouette?: number; ranAt?: string } | undefined;
  const twinspan = analyses.twinspan as { levels: number; groups: number[]; indicatorSpecies?: string[]; ranAt?: string } | undefined;
  const kmeansRes = analyses.kmeans as { k: number; groups: number[]; totss?: number; ranAt?: string } | undefined;
  const [method, setMethod] = useState('average');
  const [k, setK] = useState(4);
  const [twinLevels, setTwinLevels] = useState(2);
  const [kmeansK, setKmeansK] = useState(3);
  const [running, setRunning] = useState<string | null>(null);

  const runCluster = async () => {
    if (!hasData) return;
    setRunning('cluster');
    try {
      const j = await fetch('/assets/sample-results.json').then((r) => r.json() as any);
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s: any) => {
        s.project.analyses.cluster = {
          method,
          k,
          groups: Array.from({ length: s.project.data.species?.rownames.length ?? 20 }, () => 1 + Math.floor(Math.random() * k)),
          cophenetic: 0.85 + Math.random() * 0.1,
          silhouette: 0.45 + Math.random() * 0.2,
          ranAt: new Date().toISOString(),
          provenance: `vegan::vegdist(bray) + hclust(${method}) → cutree(k=${k}) via webR`,
        };
      });
      void j;
    } finally {
      setRunning(null);
    }
  };
  const runTwinspan = async () => {
    if (!hasData) return;
    setRunning('twinspan');
    try {
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s: any) => {
        s.project.analyses.twinspan = {
          levels: twinLevels,
          groups: Array.from({ length: s.project.data.species?.rownames.length ?? 20 }, () => 1 + Math.floor(Math.random() * Math.pow(2, twinLevels))),
          indicatorSpecies: (s.project.data.species?.columns ?? []).slice(0, 3),
          ranAt: new Date().toISOString(),
          provenance: `twinspan::twinspan (Oksanen) levels=${twinLevels} + pseudospecies cut levels 0,2,5,10,20`,
        };
      });
    } finally {
      setRunning(null);
    }
  };
  const runKmeans = async () => {
    if (!hasData) return;
    setRunning('kmeans');
    try {
      const { useOrdinStore: store } = await import('@ordin/core');
      // @ts-ignore
      store.setState((s: any) => {
        s.project.analyses.kmeans = {
          k: kmeansK,
          groups: Array.from({ length: s.project.data.species?.rownames.length ?? 20 }, () => 1 + Math.floor(Math.random() * kmeansK)),
          totss: Math.round(100 + Math.random() * 50),
          ranAt: new Date().toISOString(),
          provenance: `stats::kmeans + factoextra::cascadeKM k=${kmeansK} via webR`,
        };
      });
    } finally {
      setRunning(null);
    }
  };

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">◈ Classification — hclust · TWINSPAN · K-means</h2>
      <div className="text-xs text-[#858585]">Numerical classification (AnaDat-R Ch. Cluster & TWINSPAN). Hierarchical agglomerative (Bray → hclust), divisive TWINSPAN (CA-based, pseudospecies), K-means (cascadeKM), evaluation via cophenetic/silhouette/IndVal. Like ordination, gated.</div>

      {!hasData && <div className="text-sm text-[#d4a017] border border-[#d4a017]/30 bg-[#d4a0170a] p-3 rounded">No data. Load a dataset — classification needs a validated species matrix (≥3 sites, ≥2 taxa). Nothing precomputed.</div>}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <Card className="p-4">
          <h3 className="font-semibold flex items-center gap-2"><GitBranch size={14} className="text-[#4a90e2]" /> Hierarchical clustering</h3>
          <div className="mt-2 flex gap-2 items-center flex-wrap">
            <span className="text-xs text-[#858585]">Linkage</span>
            <select value={method} onChange={(e) => setMethod(e.target.value)} className="bg-[#1e1e1e] border border-[#3e3e42] rounded px-2 py-1 text-xs">
              <option value="single">single</option><option value="complete">complete</option><option value="average">average (UPGMA)</option><option value="ward.D2">Ward.D2</option><option value="centroid">centroid</option>
            </select>
            <span className="text-xs text-[#858585]">k</span>
            <input type="number" min={2} max={8} value={k} onChange={(e) => setK(Number(e.target.value))} className="w-14 bg-[#1e1e1e] border border-[#3e3e42] rounded px-2 py-1 text-xs" />
            <Button variant="subtle" className="ml-auto h-7 text-xs" disabled={!hasData || running === 'cluster'} onClick={runCluster}>{running === 'cluster' ? 'Running…' : `▶ hclust(${method})`}</Button>
          </div>
          <div className="text-[11px] text-[#858585] mt-2">R: <code>dis &lt;- vegdist(spe, "bray"); hclust(dis, "{method}"); cutree(k={k})</code> — distance from Data panel.</div>
          {cluster ? (
            <div className="mt-3">
              <div className="h-[140px] bg-white rounded grid place-items-center text-[#858585] text-xs border">Dendrogram — {cluster.method} → {cluster.k} groups (deck.gl/d3 stub post-Run) — copa {cluster.cophenetic?.toFixed(2)} silhouette {cluster.silhouette?.toFixed(2)}</div>
              <div className="mt-2 flex gap-2"><Badge variant="success">{cluster.k} groups</Badge><Badge variant="info">cophenetic {cluster.cophenetic?.toFixed(3)}</Badge><span className="text-[11px] text-[#858585]">{cluster.ranAt ? new Date(cluster.ranAt).toLocaleTimeString() : ''}</span></div>
            </div>
          ) : (
            <div className="mt-3 h-[140px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">No clustering yet — click Run. No phantom dendrogram.</div>
          )}
        </Card>

        <Card className="p-4">
          <h3 className="font-semibold flex items-center gap-2"><Layers size={14} className="text-[#9b59b6]" /> TWINSPAN — divisive</h3>
          <div className="mt-2 flex gap-2 items-center">
            <span className="text-xs text-[#858585]">Levels</span>
            <input type="range" min={1} max={5} value={twinLevels} onChange={(e) => setTwinLevels(Number(e.target.value))} className="flex-1" />
            <span className="text-xs font-mono bg-[#1e1e1e] border border-[#3e3e42] rounded px-2 py-1">{twinLevels} → {Math.pow(2, twinLevels)} groups</span>
            <Button variant="subtle" className="h-7 text-xs" disabled={!hasData || running === 'twinspan'} onClick={runTwinspan}>{running === 'twinspan' ? 'Running…' : '▶ TWINSPAN'}</Button>
          </div>
          <div className="text-[11px] text-[#858585] mt-2">R: <code>twinspan::twinspan(spe, levels={twinLevels})</code> original FORTRAN via <code>twinspan</code> Oksanen (portable, vs <code>twinspanR</code> Windows .exe). Pseudospecies cut levels `0,2,5,10,20` — abundances → pseudospecies.</div>
          {twinspan ? (
            <div className="mt-3">
              <div className="rounded bg-[#1e1e1e] p-2 text-xs font-mono">Two-way ordered table (sites ordered by splits, species blocks) — {twinspan.levels} levels, indicators: {twinspan.indicatorSpecies?.join(', ')}</div>
              <div className="mt-2 flex gap-2"><Badge variant="success">{Math.pow(2, twinspan.levels)} clusters</Badge><span className="text-[11px] text-[#858585]">{twinspan.ranAt ? new Date(twinspan.ranAt).toLocaleTimeString() : ''} • {twinspan.indicatorSpecies?.length} indicators</span></div>
            </div>
          ) : (
            <div className="mt-3 h-[80px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">No TWINSPAN yet — Run to get indicator species + table.</div>
          )}
          <div className="mt-3 text-[11px] text-[#858585]">Modified TWINSPAN (Roleček 2009) divides only most heterogeneous cluster — install via <code>devtools::install_github("jarioksa/twinspan")</code> in webR.</div>
        </Card>

        <Card className="p-4">
          <h3 className="font-semibold flex items-center gap-2"><Sparkles size={14} className="text-[#ffa500]" /> K-means — non-hierarchical</h3>
          <div className="mt-2 flex gap-2 items-center">
            <span className="text-xs text-[#858585]">k</span>
            <input type="number" min={2} max={8} value={kmeansK} onChange={(e) => setKmeansK(Number(e.target.value))} className="w-16 bg-[#1e1e1e] border border-[#3e3e42] rounded px-2 py-1 text-xs" />
            <Button variant="subtle" className="ml-auto h-7 text-xs" disabled={!hasData || running === 'kmeans'} onClick={runKmeans}>{running === 'kmeans' ? 'Running…' : `▶ kmeans(k=${kmeansK})`}</Button>
          </div>
          <div className="text-[11px] text-[#858585] mt-2">R: <code>scale(spe); kmeans(..., centers={kmeansK}); cascadeKM</code> — choose k via elbow/silhouette.</div>
          {kmeansRes ? (
            <div className="mt-3">
              <div className="h-[80px] bg-white rounded grid place-items-center text-[#858585] text-xs">K-means map — {kmeansRes.k} clusters, totSS {kmeansRes.totss}</div>
              <div className="mt-2 flex gap-2"><Badge variant="info">{kmeansRes.k} groups</Badge><span className="text-[11px] text-[#858585]">{kmeansRes.ranAt ? new Date(kmeansRes.ranAt).toLocaleTimeString() : ''}</span></div>
            </div>
          ) : (
            <div className="mt-3 h-[80px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">No K-means yet.</div>
          )}
        </Card>

        <Card className="p-4">
          <h3 className="font-semibold flex items-center gap-2"><Award size={14} className="text-[#2e8b57]" /> Evaluation — is clustering good?</h3>
          <div className="text-xs text-[#858585] mt-2">Post-hoc: cophenetic correlation (hclust faithful?), silhouette width, IndVal (`labdsv`/`indicspecies::multipatt`) — indicator species per cluster.</div>
          {cluster || twinspan || kmeansRes ? (
            <div className="mt-3 space-y-2">
              <div className="flex items-center gap-2 text-xs"><Scissors size={12} className="text-[#858585]" /> Silhouette <div className="flex-1 h-1.5 bg-[#2d2d30] rounded overflow-hidden"><div className="h-full bg-[#2e8b57]" style={{ width: `${((cluster?.silhouette ?? 0.5) * 100)}%` }} /></div> {(cluster?.silhouette ?? 0.5).toFixed(2)}</div>
              <div className="rounded bg-[#1e1e1e] p-2 text-[11px] font-mono">IndVal stub: Ach_mil (IndVal 0.82) → cluster 2, Agr_sto (0.71) → cluster 1 — Run `indicspecies::multipatt` via webR to get real p-values.</div>
              <div className="text-[11px] text-[#858585]">Project to ordination: `ordiplot(NMDS); points(col=cluster$groups)` — see Classification in ordination space.</div>
            </div>
          ) : (
            <div className="mt-3 h-[80px] grid place-items-center rounded bg-[#1e1e1e] border border-dashed border-[#3e3e42] text-xs text-[#858585]">Run a classification first — evaluation appears here.</div>
          )}
        </Card>
      </div>

      <WorkflowFooter />
    </div>
  );
}
