// @ordin/map — MapLibre lifecycle (mirrors @geolibre/map)
import * as maplibregl from 'maplibre-gl';
import 'maplibre-gl/dist/maplibre-gl.css';

export type MapProps = {
  style: string;
  center?: [number, number];
  zoom?: number;
  onLoad?: (map: maplibregl.Map) => void;
};

export function createMap(container: HTMLElement, opts: MapProps): maplibregl.Map {
  const map = new maplibregl.Map({
    container,
    style: opts.style,
    center: opts.center ?? [147.18, -6.6], // PNG (Ördin's PNG University) — default like GeoLibre's world view
    zoom: opts.zoom ?? 5,
    attributionControl: false,
  });
  map.addControl(new maplibregl.NavigationControl(), 'top-right');
  map.addControl(new maplibregl.AttributionControl({ compact: true }), 'bottom-right');
  if (opts.onLoad) map.once('load', () => opts.onLoad!(map));
  return map;
}

export { maplibregl };
