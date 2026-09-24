import { useOrdinStore } from '@ordin/core';
import { Dialog, Button, Card } from '@ordin/ui';
import { Upload, FileSpreadsheet, Database, X } from 'lucide-react';
import { useState } from 'react';

export function ImportDialog() {
  const open = useOrdinStore((s) => s.ui.importOpen);
  const setOpen = useOrdinStore((s) => s.setImportOpen);
  const setSpecies = useOrdinStore((s) => s.setSpecies);
  const loadSample = useOrdinStore((s) => s.loadSample);
  const [dragOver, setDragOver] = useState(false);

  const handleFile = async (file: File) => {
    const text = await file.text();
    const lines = text.split('\n').filter(Boolean);
    if (lines.length < 2) return;
    const header = lines[0].split(',').map((s) => s.trim().replace(/^"|"$/g, ''));
    const rownames = lines.slice(1).map((l) => l.split(',')[0].replace(/^"|"$/g, ''));
    const matrix = lines.slice(1).map((l) => l.split(',').slice(1).map((v) => Number(v.trim().replace(/^"|"$/g, '')) || 0));
    setSpecies({ columns: header.slice(1), rownames, matrix });
    setOpen(false);
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <div className="flex items-center justify-between px-4 py-3 border-b border-[#2d2d30] shrink-0">
        <h2 className="font-semibold flex items-center gap-2">
          <Upload size={16} className="text-[#2e8b57]" /> Import — popup
        </h2>
        <button onClick={() => setOpen(false)} className="w-7 h-7 grid place-items-center rounded hover:bg-[#2a2a2a] text-[#858585]">
          <X size={14} />
        </button>
      </div>

      <div className="p-4 space-y-4 overflow-auto">
        <div
          onDragOver={(e) => {
            e.preventDefault();
            setDragOver(true);
          }}
          onDragLeave={() => setDragOver(false)}
          onDrop={async (e) => {
            e.preventDefault();
            setDragOver(false);
            const f = e.dataTransfer.files?.[0];
            if (f) await handleFile(f);
          }}
          className={`rounded-xl border-2 border-dashed p-8 flex flex-col items-center gap-2 text-center transition-colors ${dragOver ? 'border-[#2e8b57] bg-[#2e8b5720]' : 'border-[#3e3e42] hover:bg-[#2a2a2a]/50'}`}
        >
          <span className="w-10 h-10 grid place-items-center rounded-full bg-[#2e8b57]/15 text-[#2e8b57]">
            <Upload size={18} />
          </span>
          <div className="text-sm font-medium">Drop CSV / Parquet here</div>
          <div className="text-xs text-[#858585]">or click to browse — file is queried in-browser via DuckDB-WASM (no upload)</div>
          <label className="mt-2 cursor-pointer">
            <span className="inline-flex items-center rounded-md bg-[#2e8b57] text-white px-3 py-1.5 text-sm hover:bg-[#257a4a]">Browse…</span>
            <input type="file" accept=".csv,.txt,.tsv,.parquet" className="hidden" onChange={async (e) => e.target.files?.[0] && (await handleFile(e.target.files[0]))} />
          </label>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <Card className="p-3">
            <div className="text-xs font-semibold tracking-widest text-[#858585] flex items-center gap-1.5">
              <FileSpreadsheet size={12} /> SAMPLES
            </div>
            <div className="mt-2 flex gap-2">
              {(['dune', 'varespec', 'BCI'] as const).map((n) => (
                <Button
                  key={n}
                  variant="outline"
                  className="flex-1 h-7 text-xs"
                  onClick={async () => {
                    await loadSample(n);
                    setOpen(false);
                  }}
                >
                  {n}
                </Button>
              ))}
            </div>
            <div className="text-[11px] text-[#858585] mt-2">Bundled as CSV + Parquet via DuckDB.</div>
          </Card>
          <Card className="p-3">
            <div className="text-xs font-semibold tracking-widest text-[#858585] flex items-center gap-1.5">
              <Database size={12} /> SQL WORKSPACE
            </div>
            <pre className="mt-2 bg-[#1e1e1e] p-2 rounded text-[11px] overflow-auto">
              {`SELECT * FROM read_csv('your.csv', header=true) LIMIT 5;`}
            </pre>
            <div className="text-[11px] text-[#858585] mt-2">Same pattern GeoLibre exposes — here on ecology tables.</div>
          </Card>
        </div>

        <div className="flex justify-between items-center pt-1">
          <span className="text-xs text-[#858585]">Tip: also press ⌘K → “Import file…”.</span>
          <Button variant="ghost" onClick={() => setOpen(false)}>
            Close
          </Button>
        </div>
      </div>
    </Dialog>
  );
}
