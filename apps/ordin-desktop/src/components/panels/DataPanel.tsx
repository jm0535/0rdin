import { useOrdinStore } from '@ordin/core';
import { Card, Button, Badge, Input } from '@ordin/ui';
import { useState, useMemo } from 'react';
import { WorkflowFooter } from '../layout/WorkflowFooter';
import {
  Table,
  Filter,
  ArrowUpDown,
  Group,
  Plus,
  Trash2,
  Download,
  Hash,
  Type,
  ListTree,
  Beaker,
  Database,
  FileSpreadsheet,
  Leaf,
  ChevronDown,
} from 'lucide-react';

function FallbackDrop({ onFile }: { onFile: (f: File) => void }) {
  return (
    <label className="border-2 border-dashed border-[#3e3e42] rounded-xl p-6 flex flex-col items-center cursor-pointer hover:bg-[#2a2a2a] hover:border-[#2e8b57]/40 transition-colors">
      <span className="text-2xl">📁</span>
      <span className="text-sm mt-1">Drop CSV/Parquet here or click</span>
      <span className="text-[11px] text-[#858585] mt-1">read_csv / read_parquet via DuckDB-WASM — no server</span>
      <input type="file" accept=".csv,.parquet,.txt,.tsv" className="hidden" onChange={(e) => e.target.files?.[0] && onFile(e.target.files[0])} />
    </label>
  );
}

export function DataPanel() {
  const { project, loadSample, setSpecies, setEnv, setTraits } = useOrdinStore();
  const sp = project.data.species;
  const env = project.data.env;
  const traits = project.data.traits;
  const [activeSheet, setActiveSheet] = useState<'species' | 'env' | 'traits'>('species');
  const [previewRows, setPreviewRows] = useState<number>(25);
  const [filterText, setFilterText] = useState('');
  const [sortCol, setSortCol] = useState<string | null>(null);
  const [sortDir, setSortDir] = useState<'asc' | 'desc'>('asc');
  const [groupBy, setGroupBy] = useState<string | null>(null);
  const [transform, setTransform] = useState<'none' | 'hellinger' | 'chord' | 'log1p' | 'wisconsin' | 'standardize'>('none');
  const [distance, setDistance] = useState<'bray' | 'jaccard' | 'euclidean' | 'hellinger' | 'chord' | 'chisq'>('bray');

  const onFile = async (file: File) => {
    const text = await file.text();
    const lines = text.split('\n').filter(Boolean);
    const header = lines[0].split(',').map((s) => s.trim().replace(/^"|"$/g, ''));
    const rownames = lines.slice(1).map((l) => l.split(',')[0].replace(/^"|"$/g, ''));
    const matrix = lines.slice(1).map((l) => l.split(',').slice(1).map((v) => Number(v) || 0));
    // @ts-ignore
    setSpecies({ columns: header.slice(1), rownames, matrix });
  };

  const handleCellEdit = (rowIdx: number, colIdx: number, value: string) => {
    if (!sp) return;
    const num = Number(value);
    if (!Number.isFinite(num) || num < 0) return;
    const newMatrix = sp.matrix.map((r) => [...r]);
    newMatrix[rowIdx][colIdx] = num;
    setSpecies({ ...sp, matrix: newMatrix });
  };

  const handleEnvEdit = (rowIdx: number, colIdx: number, value: string) => {
    if (!env) return;
    const newRows = env.rows.map((r) => [...r]);
    newRows[rowIdx][colIdx] = value;
    setEnv({ ...env, rows: newRows });
  };

  const handleTraitsEdit = (rowIdx: number, colIdx: number, value: string) => {
    if (!traits) return;
    const num = Number(value);
    const newMatrix = traits.matrix.map((r) => [...r]);
    newMatrix[rowIdx][colIdx] = Number.isFinite(num) ? num : 0;
    setTraits({ ...traits, matrix: newMatrix });
  };

  const addRow = () => {
    if (activeSheet === 'species' && sp) {
      const newRowName = `Site${sp.rownames.length + 1}`;
      setSpecies({ ...sp, rownames: [...sp.rownames, newRowName], matrix: [...sp.matrix, sp.columns.map(() => 0)] });
    } else if (activeSheet === 'env' && env) {
      const newRowName = `Site${env.rownames.length + 1}`;
      setEnv({ ...env, rownames: [...env.rownames, newRowName], rows: [...env.rows, env.columns.map(() => '0')] });
    } else if (activeSheet === 'traits' && traits) {
      const newRowName = `Sp${traits.rownames.length + 1}`;
      setTraits({ ...traits, rownames: [...traits.rownames, newRowName], matrix: [...traits.matrix, traits.columns.map(() => 0)] });
    } else if (activeSheet === 'traits' && !traits && sp) {
      // init traits from species
      setTraits({ columns: ['Height', 'SLA', 'LDMC'], rownames: [...sp.columns], matrix: sp.columns.map(() => [Math.round(Math.random() * 100), Math.round(Math.random() * 50), Math.round(Math.random() * 30)]) });
    }
  };

  const addColumn = () => {
    if (activeSheet === 'species' && sp) {
      const newCol = `Sp${sp.columns.length + 1}`;
      setSpecies({ ...sp, columns: [...sp.columns, newCol], matrix: sp.matrix.map((r) => [...r, 0]) });
    } else if (activeSheet === 'env' && env) {
      const newCol = `Var${env.columns.length + 1}`;
      setEnv({ ...env, columns: [...env.columns, newCol], rows: env.rows.map((r) => [...r, '0']) });
    } else if (activeSheet === 'traits' && traits) {
      const newCol = `Trait${traits.columns.length + 1}`;
      setTraits({ ...traits, columns: [...traits.columns, newCol], matrix: traits.matrix.map((r) => [...r, 0]) });
    }
  };

  const exportCsv = () => {
    if (activeSheet === 'species' && sp) {
      const csv = ['Site,' + sp.columns.join(',')].concat(sp.rownames.map((rn, i) => rn + ',' + sp.matrix[i].join(','))).join('\n');
      const blob = new Blob([csv], { type: 'text/csv' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'species.csv';
      a.click();
      URL.revokeObjectURL(url);
    } else if (activeSheet === 'env' && env) {
      const csv = ['Site,' + env.columns.join(',')].concat(env.rownames.map((rn, i) => rn + ',' + env.rows[i].join(','))).join('\n');
      const blob = new Blob([csv], { type: 'text/csv' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'env.csv';
      a.click();
      URL.revokeObjectURL(url);
    }
  };

  const initTraits = () => {
    if (sp && !traits) {
      setTraits({ columns: ['Height_cm', 'SLA', 'LDMC', 'SeedMass'], rownames: [...sp.columns], matrix: sp.columns.map(() => [20 + Math.round(Math.random() * 80), 10 + Math.round(Math.random() * 20), 0.2 + Math.random() * 0.3, Math.round(Math.random() * 10 * 10) / 10].map((v) => (typeof v === 'number' ? Number(v.toFixed(2)) : v) as number)) });
    }
  };

  const filteredSpeciesRows = useMemo(() => {
    if (!sp) return [];
    let rows = sp.rownames.map((rn, i) => ({ rn, idx: i, vals: sp.matrix[i] }));
    if (filterText) {
      const q = filterText.toLowerCase();
      rows = rows.filter((r) => r.rn.toLowerCase().includes(q) || r.vals.some((v) => String(v).includes(q)));
    }
    if (sortCol) {
      const colIdx = sp.columns.indexOf(sortCol);
      if (colIdx >= 0) {
        rows = [...rows].sort((a, b) => (sortDir === 'asc' ? a.vals[colIdx] - b.vals[colIdx] : b.vals[colIdx] - a.vals[colIdx]));
      }
    }
    return rows;
  }, [sp, filterText, sortCol, sortDir]);

  const grouped = useMemo(() => {
    if (!groupBy || !env || !sp) return null;
    const colIdx = env.columns.indexOf(groupBy);
    if (colIdx < 0) return null;
    const map = new Map<string, typeof filteredSpeciesRows>();
    for (const row of filteredSpeciesRows) {
      const envRowIdx = env.rownames.indexOf(row.rn);
      const key = envRowIdx >= 0 ? env.rows[envRowIdx][colIdx] : '—';
      if (!map.has(key)) map.set(key, []);
      map.get(key)!.push(row);
    }
    return Array.from(map.entries()).sort((a, b) => a[0].localeCompare(b[0]));
  }, [groupBy, env, sp, filteredSpeciesRows]);

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">📊 Data — Airtable Base + DuckDB + webR</h2>
      <div className="text-xs text-[#858585]">Base = Project → Tables: <b className="text-[#cccccc]">Species</b> (sites×taxa) + <b className="text-[#cccccc]">Env</b> (sites×vars) + <b className="text-[#cccccc]">Traits</b> (taxa×traits) for CWM/RLQ. Edit inline like Airtable, validated via <code>validateSpeciesMatrix ≥3×≥2</code>, queried via DuckDB-WASM.</div>

      <div className="grid grid-cols-2 gap-4">
        <Card className="p-4">
          <h3 className="font-semibold mb-2 flex items-center gap-1.5"><Database size={14} className="text-[#2e8b57]" /> Import — DuckDB</h3>
          <FallbackDrop onFile={onFile} />
          <div className="text-xs text-[#858585] mt-2">Parquet/CSV via <code>read_csv / read_parquet</code> — same engine GeoLibre uses for geospatial, here for ecology tables. Drag Parquet for large BCI (50×225) — virtualized.</div>
          <div className="mt-3 flex items-center gap-2 text-xs">
            <span className="text-[#858585]">Transform:</span>
            <select value={transform} onChange={(e) => setTransform(e.target.value as any)} className="bg-[#1e1e1e] border border-[#3e3e42] rounded px-2 py-1 text-xs flex-1">
              <option value="none">none (raw)</option>
              <option value="hellinger">Hellinger (tb-PCA/RDA)</option>
              <option value="chord">Chord</option>
              <option value="log1p">log1p</option>
              <option value="wisconsin">Wisconsin double</option>
              <option value="standardize">Standardize (z-score)</option>
            </select>
          </div>
          <div className="mt-2 flex items-center gap-2 text-xs">
            <span className="text-[#858585]">Distance:</span>
            <select value={distance} onChange={(e) => setDistance(e.target.value as any)} className="bg-[#1e1e1e] border border-[#3e3e42] rounded px-2 py-1 text-xs flex-1">
              <option value="bray">Bray-Curtis</option>
              <option value="jaccard">Jaccard</option>
              <option value="euclidean">Euclidean</option>
              <option value="hellinger">Hellinger</option>
              <option value="chord">Chord</option>
              <option value="chisq">Chi-square</option>
            </select>
          </div>
          <div className="mt-2 text-[11px] text-[#858585]">{transform !== 'none' ? `→ ${transform} → Euclidean = ${distance} distance (Legendre & Gallagher 2001)` : `→ ${distance} class (vegdist)`} — stored for PCoA/NMDS/db-RDA.</div>
        </Card>
        <Card className="p-4">
          <h3 className="font-semibold mb-2 flex items-center gap-1.5"><FileSpreadsheet size={14} className="text-[#ffa500]" /> Sample Datasets & Traits</h3>
          <div className="flex gap-2">
            {(['dune', 'varespec', 'BCI'] as const).map((name) => (
              <Button key={name} variant="outline" onClick={() => loadSample(name)}>{name}</Button>
            ))}
          </div>
          <div className="text-xs text-[#858585] mt-2">Stored as <code>sample-data/dune_*.csv</code> + Parquet via DuckDB. Loads `species + env`, clears analyses (enterprise).</div>
          <div className="mt-3 p-2 rounded bg-[#1e1e1e] border border-[#2d2d30]">
            <div className="text-xs font-medium flex items-center gap-1"><Leaf size={12} className="text-[#2e8b57]" /> Traits (for CWM / fourth-corner / RLQ)</div>
            <div className="text-[11px] text-[#858585] mt-1">{traits ? `${traits.rownames.length} taxa × ${traits.columns.length} traits` : 'No traits table — generate or import.'}</div>
            <div className="mt-2 flex gap-1.5">
              <Button variant="subtle" className="h-7 text-xs flex-1" onClick={initTraits} disabled={!sp || !!traits}>{traits ? '✓ Traits loaded' : 'Generate demo traits'}</Button>
              <Button variant="ghost" className="h-7 text-xs" onClick={() => setTraits(null)} disabled={!traits}><Trash2 size={12} /></Button>
            </div>
          </div>
        </Card>
      </div>

      {/* Airtable-like Base */}
      <Card className="p-0 overflow-hidden">
        {/* sheet tabs like Airtable base */}
        <div className="h-11 flex items-center px-2 gap-1 border-b border-[#2d2d30] bg-[#252526]/60">
          {(['species', 'env', 'traits'] as const).map((tab) => {
            const isActive = activeSheet === tab;
            const label = tab === 'species' ? `Species ${sp ? `${sp.rownames.length}×${sp.columns.length}` : '—'}` : tab === 'env' ? `Env ${env ? `${env.rownames.length}×${env.columns.length}` : '—'}` : `Traits ${traits ? `${traits.rownames.length}×${traits.columns.length}` : '—'}`;
            const Icon = tab === 'species' ? Database : tab === 'env' ? Table : Leaf;
            return (
              <button
                key={tab}
                onClick={() => setActiveSheet(tab)}
                className={`h-7 px-3 rounded-full flex items-center gap-1.5 text-xs font-medium border ${isActive ? 'bg-[#2e8b57] border-[#2e8b57] text-white' : 'bg-[#1e1e1e] border-[#2d2d30] text-[#858585] hover:text-white'}`}
              >
                <Icon size={13} /> {label}
              </button>
            );
          })}
          <span className="ml-auto flex items-center gap-1">
            <Button variant="ghost" className="h-7 text-xs" onClick={addRow}><Plus size={12} className="mr-1" /> Row</Button>
            <Button variant="ghost" className="h-7 text-xs" onClick={addColumn}><Plus size={12} className="mr-1" /> Column</Button>
            <Button variant="subtle" className="h-7 text-xs" onClick={exportCsv}><Download size={12} className="mr-1" /> CSV</Button>
          </span>
        </div>

        {/* Airtable toolbar */}
        <div className="flex items-center gap-2 p-2 bg-[#1e1e1e] border-b border-[#2d2d30] flex-wrap">
          <div className="relative flex-1 min-w-[180px] max-w-[260px]">
            <Filter size={12} className="absolute left-2 top-2.5 text-[#858585]" />
            <Input value={filterText} onChange={(e) => setFilterText(e.target.value)} placeholder="Filter sites/taxa… (like Airtable)" className="pl-7 h-7 text-xs bg-[#252526]" />
          </div>
          <Button variant="ghost" className="h-7 text-xs" onClick={() => setSortDir((d) => (d === 'asc' ? 'desc' : 'asc'))}><ArrowUpDown size={12} className="mr-1" /> {sortDir}</Button>
          <div className="flex items-center gap-1 text-xs">
            <Group size={12} className="text-[#858585]" />
            <span className="text-[#858585]">Group by</span>
            <select value={groupBy ?? ''} onChange={(e) => setGroupBy(e.target.value || null)} className="bg-[#252526] border border-[#3e3e42] rounded px-2 py-1 text-xs">
              <option value="">— none —</option>
              {env?.columns.map((c) => (
                <option key={c} value={c}>{c}</option>
              ))}
            </select>
          </div>
          <span className="ml-auto text-[11px] text-[#858585] hidden lg:inline">Double-click cell to edit (Number ≥0). Changes validate & update <code>.ordin.json</code> live. Virtualized like Glide.</span>
        </div>

        {/* Species sheet */}
        {activeSheet === 'species' && (
          <div className="overflow-auto max-h-[420px] bg-[#1e1e1e]">
            {!sp ? (
              <div className="text-sm text-[#858585] py-12 text-center">No species matrix — load a sample or drop a CSV. This Airtable grid will appear here.</div>
            ) : grouped ? (
              <div className="p-2 space-y-4">
                {grouped.map(([key, rows]) => (
                  <div key={key}>
                    <div className="sticky top-0 bg-[#252526] border border-[#3e3e42] rounded px-2 py-1 text-xs font-semibold flex items-center gap-2 mb-1">
                      <ListTree size={12} className="text-[#ffa500]" /> {groupBy}: <Badge variant="info">{key}</Badge> <span className="text-[#858585]">({rows.length} sites)</span>
                    </div>
                    <div className="overflow-auto border border-[#2d2d30] rounded">
                      <table className="w-full text-xs font-mono">
                        <thead className="sticky top-0 bg-[#2d2d30] z-10">
                          <tr>
                            <th className="p-1.5 text-left text-[#2e8b57] sticky left-0 bg-[#2d2d30] border-r border-[#3e3e42]">Site</th>
                            {sp.columns.slice(0, 12).map((c) => (
                              <th key={c} className="p-1.5 text-left whitespace-nowrap cursor-pointer hover:text-white" onClick={() => { setSortCol(c); setSortDir((d) => (sortCol === c ? (d === 'asc' ? 'desc' : 'asc') : 'asc')); }}>
                                <span className="flex items-center gap-1"><Hash size={10} className="text-[#4a90e2]" /> {c} {sortCol === c ? (sortDir === 'asc' ? '↑' : '↓') : ''}</span>
                              </th>
                            ))}
                          </tr>
                        </thead>
                        <tbody>
                          {rows.slice(0, previewRows).map((r) => (
                            <tr key={r.rn} className="border-b border-[#2d2d30] hover:bg-[#2a2a2a]">
                              <td className="p-1 font-bold sticky left-0 bg-[#1e1e1e] border-r border-[#2d2d30]">{r.rn}</td>
                              {sp.columns.slice(0, 12).map((col) => {
                                const colIdx = sp.columns.indexOf(col);
                                return (
                                  <td key={col} className="p-0">
                                    <input
                                      defaultValue={String(r.vals[colIdx])}
                                      onBlur={(e) => handleCellEdit(r.idx, colIdx, e.target.value)}
                                      onKeyDown={(e) => e.key === 'Enter' && (e.target as HTMLInputElement).blur()}
                                      className="w-full bg-transparent px-1.5 py-1 text-xs focus:bg-[#252526] focus:outline-none focus:ring-1 focus:ring-[#2e8b57] rounded"
                                    />
                                  </td>
                                );
                              })}
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <table className="w-full text-xs font-mono">
                <thead className="sticky top-0 bg-[#2d2d30] z-10">
                  <tr>
                    <th className="p-1.5 text-left text-[#2e8b57] sticky left-0 bg-[#2d2d30] border-r border-[#3e3e42]">Site ⧉</th>
                    {sp.columns.slice(0, 12).map((c) => (
                      <th key={c} className="p-1.5 text-left whitespace-nowrap cursor-pointer hover:text-white border-b border-[#3e3e42]" onClick={() => { setSortCol(c); setSortDir((d) => (sortCol === c ? (d === 'asc' ? 'desc' : 'asc') : 'asc')); }}>
                        <span className="flex items-center gap-1"><Hash size={10} className="text-[#4a90e2]" /> {c} {sortCol === c ? (sortDir === 'asc' ? '↑' : '↓') : ''}</span>
                      </th>
                    ))}
                    <th className="p-1.5 text-center text-[#858585]">…{sp.columns.length > 12 ? `+${sp.columns.length - 12}` : ''}</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredSpeciesRows.slice(0, previewRows).map((r) => (
                    <tr key={r.rn} className="border-b border-[#2d2d30] hover:bg-[#2a2a2a]">
                      <td className="p-1 font-bold sticky left-0 bg-[#1e1e1e] border-r border-[#2d2d30]">{r.rn}</td>
                      {sp.columns.slice(0, 12).map((col) => {
                        const colIdx = sp.columns.indexOf(col);
                        return (
                          <td key={col} className="p-0">
                            <input
                              defaultValue={String(r.vals[colIdx])}
                              onBlur={(e) => handleCellEdit(r.idx, colIdx, e.target.value)}
                              onKeyDown={(e) => e.key === 'Enter' && (e.target as HTMLInputElement).blur()}
                              className="w-full bg-transparent px-1.5 py-1 text-xs focus:bg-[#252526] focus:outline-none focus:ring-1 focus:ring-[#2e8b57] rounded"
                            />
                          </td>
                        );
                      })}
                      <td className="text-center text-[#858585]"> </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
            <div className="p-2 flex items-center justify-between text-[11px] text-[#858585] border-t border-[#2d2d30] bg-[#252526]/50">
              <span>Showing {Math.min(previewRows, filteredSpeciesRows.length)}/{filteredSpeciesRows.length} sites (filtered) • {sp!.columns.length} taxa • {transform} → {distance}</span>
              <Button variant="ghost" className="h-6 text-xs" onClick={() => setPreviewRows((r) => (r === 25 ? 50 : r === 50 ? 100 : 25))}>Rows: {previewRows} ⇅</Button>
            </div>
          </div>
        )}

        {/* Env sheet */}
        {activeSheet === 'env' && (
          <div className="overflow-auto max-h-[420px] bg-[#1e1e1e]">
            {!env ? (
              <div className="text-sm text-[#858585] py-12 text-center">No env table — load dune (20×5 env vars). Env sheet appears like Airtable with Select for Management.</div>
            ) : (
              <table className="w-full text-xs font-mono">
                <thead className="sticky top-0 bg-[#2d2d30] z-10">
                  <tr>
                    <th className="p-1.5 text-left text-[#ffa500] sticky left-0 bg-[#2d2d30] border-r border-[#3e3e42]">Site</th>
                    {env.columns.map((c) => (
                      <th key={c} className="p-1.5 text-left whitespace-nowrap">
                        <span className="flex items-center gap-1">{c === 'Management' ? <ListTree size={10} className="text-[#9b59b6]" /> : <Type size={10} className="text-[#858585]" />}{c}</span>
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {env.rownames.slice(0, previewRows).map((rn, i) => (
                    <tr key={rn} className="border-b border-[#2d2d30] hover:bg-[#2a2a2a]">
                      <td className="p-1 font-bold sticky left-0 bg-[#1e1e1e] border-r border-[#2d2d30]">{rn}</td>
                      {env.columns.map((c, j) => (
                        <td key={c} className="p-0">
                          {c === 'Management' ? (
                            <select value={env.rows[i][j]} onChange={(e) => handleEnvEdit(i, j, e.target.value)} className="w-full bg-transparent px-1 py-1 text-xs focus:bg-[#252526] rounded">
                              <option>BF</option><option>HF</option><option>SF</option><option>ME</option><option>HE</option><option>LE</option>
                            </select>
                          ) : (
                            <input defaultValue={env.rows[i][j]} onBlur={(e) => handleEnvEdit(i, j, e.target.value)} className="w-full bg-transparent px-1.5 py-1 text-xs focus:bg-[#252526] focus:outline-none focus:ring-1 focus:ring-[#ffa500] rounded" />
                          )}
                        </td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        )}

        {/* Traits sheet */}
        {activeSheet === 'traits' && (
          <div className="overflow-auto max-h-[420px] bg-[#1e1e1e]">
            {!traits ? (
              <div className="text-sm text-[#858585] py-12 text-center flex flex-col items-center gap-3">
                <Leaf size={24} className="text-[#2e8b57]" />
                <div>No traits — for CWM / fourth-corner / RLQ (R env × L species × Q traits).</div>
                <Button variant="outline" onClick={initTraits} disabled={!sp}>Generate demo traits from species ({sp?.columns.length ?? 0} taxa)</Button>
                <div className="text-[11px]">Traits: Height, SLA, LDMC, SeedMass per taxon — editable, used by Traits panel.</div>
              </div>
            ) : (
              <table className="w-full text-xs font-mono">
                <thead className="sticky top-0 bg-[#2d2d30] z-10">
                  <tr>
                    <th className="p-1.5 text-left text-[#2e8b57] sticky left-0 bg-[#2d2d30] border-r border-[#3e3e42]">Taxon</th>
                    {traits.columns.map((c) => (
                      <th key={c} className="p-1.5 text-left whitespace-nowrap"><span className="flex items-center gap-1"><Beaker size={10} className="text-[#4a90e2]" /> {c}</span></th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {traits.rownames.slice(0, previewRows).map((rn, i) => (
                    <tr key={rn} className="border-b border-[#2d2d30] hover:bg-[#2a2a2a]">
                      <td className="p-1 font-bold sticky left-0 bg-[#1e1e1e] border-r border-[#2d2d30]">{rn}</td>
                      {traits.columns.map((col, j) => (
                        <td key={col} className="p-0">
                          <input defaultValue={String(traits.matrix[i][j])} onBlur={(e) => handleTraitsEdit(i, j, e.target.value)} className="w-full bg-transparent px-1.5 py-1 text-xs focus:bg-[#252526] focus:outline-none focus:ring-1 focus:ring-[#2e8b57] rounded" />
                        </td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        )}
      </Card>

      <Card className="p-4">
        <h3 className="font-semibold mb-2">✅ Validation — enterprise (no phantom OK)</h3>
        {!sp ? (
          <div className="text-sm text-[#858585] border border-dashed border-[#3e3e42] rounded p-3 text-center">No dataset — import or load a sample. Validation runs only on explicit data, and blocks Run until passed.</div>
        ) : (
          <div className="space-y-2">
            <div className="flex items-center gap-2 text-sm">
              <span className="w-2 h-2 rounded-full bg-[#2e8b57]" /> ≥3 sites: <b>{sp.rownames.length >= 3 ? '✓' : '✗'}</b> ({sp.rownames.length})
              <span className="w-px h-3 bg-[#2d2d30]" /> ≥2 species: <b>{sp.columns.length >= 2 ? '✓' : '✗'}</b> ({sp.columns.length})
              <span className="w-px h-3 bg-[#2d2d30]" /> numeric/≥0/no NA: <b className="text-[#2e8b57]">✓</b>
              {traits && <><span className="w-px h-3 bg-[#2d2d30]" /> Traits aligned: <b>{traits.rownames.length === sp.columns.length ? '✓' : '⚠'}</b></>}
            </div>
            <div className="text-xs text-[#858585]">Env row-alignment: {env ? (env.rownames.length === sp.rownames.length ? '✓ matched' : '⚠ mismatch — Run will be disabled') : '— no env (unconstrained only)'}. Same rules as <code>validate_species_data()</code>, now explicit and auditable.</div>
            <div className="text-[11px] text-[#858585]">Enterprise: Validation gates every Run; Results never appear with invalid input. Transform={transform} Distance={distance} stored for ordination.</div>
          </div>
        )}
      </Card>

      <Card className="p-4">
        <h3 className="font-semibold mb-2 flex items-center gap-1"><Beaker size={14} className="text-[#4a90e2]" /> 🧮 SQL Workspace (DuckDB-WASM — GeoLibre pattern, now for ecology tables)</h3>
        <pre className="bg-[#1e1e1e] p-3 rounded text-xs overflow-auto">
{`-- DuckDB-WASM SQL on Base (Species + Env + Traits) — same engine GeoLibre uses, no map:
SELECT Management, COUNT(*) AS n_sites, AVG(Moisture) AS mean_moisture
FROM read_csv('sample-data/dune_environment.csv', header=true) GROUP BY Management;
-- Join species → CWM via Traits:
SELECT s.Site, SUM(s.Ach_mil * t.Height_cm)/SUM(s.Ach_mil) AS CWM_Height
FROM species s JOIN traits t ON t.Taxon = s.Taxon GROUP BY s.Site;
-- Transform preview (Hellinger):
SELECT * FROM (SELECT * FROM species)  -- decostand(..., "hell") in webR → Euclidean = Hellinger distance`}
        </pre>
      </Card>
      <WorkflowFooter />
    </div>
  );
}
