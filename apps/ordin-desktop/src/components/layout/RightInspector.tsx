import { useOrdinStore } from '@ordin/core';
import { Card, Badge, Button } from '@ordin/ui';
import { Info, Table, Database, FlaskConical, Download, Copy } from 'lucide-react';

export function RightInspector() {
  const project = useOrdinStore((s) => s.project);
  const ui = useOrdinStore((s) => s.ui);
  const set = useOrdinStore((s) => s);
  const sp = project.data.species;
  const nmds = project.analyses.nmds as any;

  return (
    <div className="w-[340px] shrink-0 bg-[#252526] border-l border-[#2d2d30] flex flex-col overflow-hidden">
      {/* tabs */}
      <div className="h-9 flex items-center gap-1 px-2 border-b border-[#2d2d30] shrink-0">
        {([
          { id: 'details', label: 'Details', icon: Info },
          { id: 'env', label: 'Env', icon: Table },
          { id: 'sql', label: 'SQL', icon: Database },
        ] as const).map((t) => {
          const Icon = t.icon;
          const active = ui.inspectorTab === t.id;
          return (
            <button
              key={t.id}
              onClick={() => set.setInspectorTab(t.id)}
              className={`flex-1 h-7 rounded-md flex items-center justify-center gap-1.5 text-xs font-medium ${active ? 'bg-[#2e8b57] text-white' : 'text-[#858585] hover:bg-[#2a2a2a] hover:text-white'}`}
            >
              <Icon size={13} /> {t.label}
            </button>
          );
        })}
      </div>

      <div className="flex-1 overflow-auto p-3 space-y-3">
        {ui.inspectorTab === 'details' && (
          <>
            <Card className="p-3">
              <div className="flex items-center gap-2">
                <FlaskConical size={16} className="text-[#2e8b57]" />
                <h3 className="font-semibold text-sm">Project</h3>
                <Badge variant="success" className="ml-auto">
                  {project.version}
                </Badge>
              </div>
              <div className="mt-2 space-y-1.5 text-xs">
                <div className="flex justify-between">
                  <span className="text-[#858585]">Name</span>
                  <span className="font-medium">{project.meta.name}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-[#858585]">Matrix</span>
                  <span>{sp ? `${sp.rownames.length} × ${sp.columns.length}` : '— empty —'}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-[#858585]">Analyses</span>
                  <span>{Object.keys(project.analyses).length} run</span>
                </div>
              </div>
              <div className="mt-3 flex gap-2">
                <Button variant="subtle" className="flex-1 text-xs h-7" onClick={() => navigator.clipboard?.writeText(JSON.stringify(project, null, 2))}>
                  <Copy size={12} className="mr-1" /> Copy .ordin.json
                </Button>
                <Button variant="outline" className="flex-1 text-xs h-7" onClick={() => set.setPanel('results')}>
                  <Download size={12} className="mr-1" /> Export
                </Button>
              </div>
            </Card>

            {nmds ? (
              <Card className="p-3">
                <h4 className="text-xs font-semibold tracking-widest text-[#858585]">LAST ORDINATION</h4>
                <div className="mt-2 text-sm font-medium">NMDS — {nmds.distance} • stress {nmds.stress?.toFixed?.(3)}</div>
                <div className="text-xs text-[#858585]">via webR worker (vegan::metaMDS) • deck.gl scatter</div>
                <img src="/assets/plots/nmds.png" alt="NMDS preview" className="mt-3 w-full rounded bg-white p-1" />
              </Card>
            ) : (
              <Card className="p-3 border-dashed bg-[#1e1e1e]">
                <div className="text-xs text-[#858585]">No ordination yet — go to <b className="text-[#cccccc]">Ordination</b> → Run NMDS. deck.gl will render the biplot here and in the main canvas.</div>
              </Card>
            )}

            <Card className="p-3">
              <h4 className="text-xs font-semibold tracking-widest text-[#858585]">REPRODUCIBILITY</h4>
              <pre className="mt-2 bg-[#1e1e1e] p-2 rounded text-[11px] leading-relaxed overflow-auto">
                {`# webR (same as desktop R)
library(vegan); library(iNEXT)
ord <- metaMDS(species, k=2, distance="bray")
# DuckDB SQL on ecology tables
SELECT Management, AVG(Moisture) FROM read_csv('dune_env.csv') GROUP BY 1`}
              </pre>
            </Card>
          </>
        )}

        {ui.inspectorTab === 'env' && (
          <>
            <Card className="p-3">
              <h3 className="font-semibold text-sm flex items-center gap-1.5">
                <Table size={14} className="text-[#ffa500]" /> Environment
              </h3>
              {!project.data.env ? (
                <div className="text-xs text-[#858585] mt-2">No env table — import or load dune.</div>
              ) : (
                <div className="mt-2 overflow-auto max-h-[320px] border border-[#2d2d30] rounded">
                  <table className="w-full text-xs font-mono">
                    <thead className="sticky top-0 bg-[#2d2d30]">
                      <tr>
                        <th className="p-1.5 text-left text-[#858585]">Site</th>
                        {project.data.env.columns.slice(0, 3).map((c) => (
                          <th key={c} className="p-1.5 text-left">
                            {c}
                          </th>
                        ))}
                      </tr>
                    </thead>
                    <tbody>
                      {project.data.env.rownames.slice(0, 8).map((rn, i) => (
                        <tr key={rn} className="border-t border-[#2d2d30]">
                          <td className="p-1.5 font-semibold">{rn}</td>
                          {project.data.env!.columns.slice(0, 3).map((c, j) => (
                            <td key={c} className="p-1.5">
                              {project.data.env!.rows[i][j]}
                            </td>
                          ))}
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </Card>
            <div className="text-[11px] text-[#858585]">If env has <code>lon/lat</code>, a collapsed MapLibre site viewer appears in Data — otherwise this table + SQL is the primary site view.</div>
          </>
        )}

        {ui.inspectorTab === 'sql' && (
          <>
            <Card className="p-3">
              <h3 className="font-semibold text-sm flex items-center gap-1.5">
                <Database size={14} className="text-[#4a90e2]" /> SQL Workspace
              </h3>
              <div className="text-xs text-[#858585] mt-1">DuckDB-WASM in-browser — no server. Same engine GeoLibre uses, here on ecology tables.</div>
              <pre className="mt-3 bg-[#1e1e1e] p-2 rounded text-[11px] overflow-auto">
                {`SELECT Management,
  COUNT(*) AS n,
  AVG(Shannon) AS mean_H
FROM read_csv('dune_species.csv', header=true)
JOIN read_csv('dune_env.csv', header=true) USING (rowid)
GROUP BY Management;`}
              </pre>
              <Button variant="subtle" className="w-full mt-2 h-7 text-xs" onClick={() => set.setPanel('data')}>
                Open in Data → SQL
              </Button>
            </Card>
            <Card className="p-3">
              <div className="text-xs font-semibold text-[#858585]">TIPS</div>
              <ul className="list-disc pl-4 text-xs text-[#858585] space-y-1 mt-2">
                <li>
                  <code className="text-[#cccccc]">read_parquet('bci.parquet')</code> for large matrices
                </li>
                <li>Use <code className="text-[#cccccc]">.ordin.json</code> to snapshot query + results</li>
                <li>webR + DuckDB run in Workers — UI never blocks</li>
              </ul>
            </Card>
          </>
        )}
      </div>

      <div className="p-2 border-t border-[#2d2d30] text-[11px] text-[#858585]">Tauri • Vite • Zustand • DuckDB-WASM • deck.gl • webR • .ordin.json</div>
    </div>
  );
}
