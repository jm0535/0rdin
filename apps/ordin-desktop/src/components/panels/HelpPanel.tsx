export function HelpPanel() {
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">Help — SQL Workspace</h2>
      <div className="bg-[#1e1e1e] p-3 rounded text-xs">
        <pre>{`SELECT * FROM read_parquet('https://example.com/dune.parquet') LIMIT 5;\n-- DuckDB-WASM runs entirely in the browser, like GeoLibre's SQL Workspace`}</pre>
      </div>
    </div>
  );
}
