export function HelpPanel() {
  return (
    <div className="space-y-4">
      <h2 className="text-xl font-bold text-[#2e8b57]">Help — Community Ecology statistical workflows</h2>
      <p className="text-sm text-[#858585]">Ördin is a statistical app. DuckDB queries species/env tables, deck.gl draws ordination biplots, webR runs vegan/iNEXT/betapart in a Worker. MapLibre is only used if your env table has lon/lat — otherwise the Data panel shows validation + SQL, not a map.</p>
      <div className="bg-[#1e1e1e] p-3 rounded text-xs">
        <pre>{`SELECT Management, COUNT(*) AS n FROM read_csv('dune_environment.csv', header=true) GROUP BY Management;\n-- DuckDB-WASM runs entirely in the browser`}</pre>
      </div>
      <div className="text-xs text-[#858585]">Ordination plots are deck.gl scatters (NMDS/PCA/CCA biplots), not map tiles. The optional MapView is a secondary, collapsed panel.</div>
    </div>
  );
}
