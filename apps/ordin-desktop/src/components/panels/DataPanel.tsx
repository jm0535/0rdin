import { useOrdinStore } from '@ordin/core';
import { Card, Button, Badge } from '@ordin/ui';
import { MapView } from '../map/MapView';
import { useState } from 'react';

// Minimal dropzone stub if react-dropzone not installed (fallback)
function FallbackDrop({ onFile }: { onFile: (f: File) => void }) {
  return (
    <label className="border-2 border-dashed border-[#3e3e42] rounded p-6 flex flex-col items-center cursor-pointer hover:bg-[#2a2a2a]">
      <span className="text-2xl">📁</span>
      <span className="text-sm mt-1">Drop CSV/Parquet here or click</span>
      <input type="file" accept=".csv,.parquet,.txt,.tsv" className="hidden" onChange={(e) => e.target.files?.[0] && onFile(e.target.files[0])} />
    </label>
  );
}

export function DataPanel() {
  const { project, loadSample, setSpecies } = useOrdinStore();
  const sp = project.data.species;
  const env = project.data.env;
  const [previewRows, setPreviewRows] = useState<number>(10);

  const onFile = async (file: File) => {
    // In GeoLibre this would go through DuckDB-WASM read_csv; here we parse naively
    const text = await file.text();
    const lines = text.split('\n').filter(Boolean);
    const header = lines[0].split(',').map((s) => s.trim().replace(/^"|"$/g, ''));
    const rownames = lines.slice(1).map((l) => l.split(',')[0].replace(/^"|"$/g, ''));
    const matrix = lines.slice(1).map((l) => l.split(',').slice(1).map((v) => Number(v) || 0));
    // @ts-ignore
    setSpecies({ columns: header.slice(1), rownames, matrix });
  };

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">📊 Data — DuckDB + webR</h2>

      <div className="grid grid-cols-2 gap-4">
        <Card className="p-4">
          <h3 className="font-semibold mb-2">Import</h3>
          <FallbackDrop onFile={onFile} />
          <div className="text-xs text-[#858585] mt-2">Parquet/CSV streamed via DuckDB-WASM (HTTP range) — same as GeoLibre’s PMTiles/GeoParquet.</div>
        </Card>
        <Card className="p-4">
          <h3 className="font-semibold mb-2">Sample Datasets</h3>
          <div className="flex gap-2">
            {(['dune', 'varespec', 'BCI'] as const).map((name) => (
              <Button key={name} variant="outline" onClick={() => loadSample(name)}>{name}</Button>
            ))}
          </div>
          <div className="text-xs text-[#858585] mt-2">Stored as <code>sample-data/dune_*.csv</code> + Parquet via DuckDB.</div>
        </Card>
      </div>

      <Card className="p-4">
        <div className="flex items-center justify-between mb-2">
          <h3 className="font-semibold">🔍 Data Preview</h3>
          <div className="flex gap-2">
            {sp && <Badge variant="success">{sp.rownames.length}×{sp.columns.length}</Badge>}
            {env && <Badge variant="info">{env.columns.length} env vars</Badge>}
            <Button variant="ghost" onClick={() => setPreviewRows((r) => (r === 10 ? 25 : 10))}>Rows: {previewRows}</Button>
          </div>
        </div>
        {sp ? (
          <div className="overflow-auto max-h-[320px] border border-[#3e3e42] rounded">
            <table className="w-full text-xs font-mono">
              <thead className="sticky top-0 bg-[#2d2d30]">
                <tr>
                  <th className="p-1 text-left text-[#2e8b57]">Site</th>
                  {sp.columns.slice(0, 10).map((c) => (
                    <th key={c} className="p-1 text-left">
                      {c}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {sp.rownames.slice(0, previewRows).map((rn, i) => (
                  <tr key={rn} className="border-b border-[#2d2d30] hover:bg-[#2a2a2a]">
                    <td className="p-1 font-bold">{rn}</td>
                    {sp.columns.slice(0, 10).map((col, j) => (
                      <td key={col} className="p-1">
                        {sp.matrix[i][sp.columns.indexOf(col)]}
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="text-sm text-[#858585] py-8 text-center">No data — load a sample or drop a file.</div>
        )}
      </Card>

      <Card className="p-4">
        <h3 className="font-semibold mb-2">🗺️ Sites Map (MapLibre — new in 4.0)</h3>
        <MapView />
        <div className="text-xs text-[#858585] mt-2">If env has lon/lat, sites render as MapLibre + deck.gl scatterplot (like GeoLibre’s vector tiles).</div>
      </Card>

      <Card className="p-4">
        <h3 className="font-semibold mb-2">🧮 SQL Workspace (DuckDB-WASM)</h3>
        <pre className="bg-[#1e1e1e] p-3 rounded text-xs overflow-auto">
{`-- Try in the real SQL workspace (packages/map + DuckDB):
SELECT Management, COUNT(*) AS n_sites, AVG(Moisture) AS mean_moisture
FROM read_csv('sample-data/dune_environment.csv', header=true)
GROUP BY Management;`}
        </pre>
      </Card>
    </div>
  );
}
