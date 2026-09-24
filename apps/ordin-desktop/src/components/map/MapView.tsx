import { useEffect, useRef } from 'react';
import { createMap } from '@ordin/map';
import { useOrdinStore } from '@ordin/core';

export function MapView() {
  const ref = useRef<HTMLDivElement>(null);
  const style = useOrdinStore((s) => s.project.view.mapStyle);
  const species = useOrdinStore((s) => s.project.data.species);

  useEffect(() => {
    if (!ref.current) return;
    const map = createMap(ref.current, { style });
    // Add demo sites as geojson when data present
    const addSites = () => {
      if (!species) return;
      // Fake lon/lat around PNG for demo — real app would read from env columns
      const feats = species.rownames.map((id, i) => ({
        type: 'Feature' as const,
        properties: { id, richness: species.matrix[i]?.filter((v) => v > 0).length ?? 0 },
        geometry: { type: 'Point' as const, coordinates: [147.18 + (i % 5) * 0.12 - 0.24, -6.6 + Math.floor(i / 5) * 0.12 - 0.24] },
      }));
      const geojson = { type: 'FeatureCollection' as const, features: feats };
      if (map.getSource('sites')) map.removeLayer('sites-circle'), map.removeSource('sites');
      map.addSource('sites', { type: 'geojson', data: geojson as any });
      map.addLayer({ id: 'sites-circle', type: 'circle', source: 'sites', paint: { 'circle-radius': 6, 'circle-color': '#2e8b57', 'circle-stroke-color': '#fff', 'circle-stroke-width': 1 } });
    };
    map.on('load', addSites);
    return () => map.remove();
  }, [style, species]);

  return <div ref={ref} className="w-full h-[280px] rounded border border-[#3e3e42]" />;
}
