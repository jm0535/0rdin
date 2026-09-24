// @ordin/core — Types, schema, and Zustand store (mirrors @geolibre/core)
import { create } from 'zustand';
import { immer } from 'zustand/middleware/immer';
import { z } from 'zod';

// --- Project file (.ordin.json) — single source of truth, like .geolibre.json ---
export const SpeciesMatrixSchema = z.object({
  columns: z.array(z.string()),
  rownames: z.array(z.string()),
  matrix: z.array(z.array(z.number())),
});
export const EnvTableSchema = z.object({
  columns: z.array(z.string()),
  rownames: z.array(z.string()),
  rows: z.array(z.array(z.string())),
});
export type SpeciesMatrix = z.infer<typeof SpeciesMatrixSchema>;
export type EnvTable = z.infer<typeof EnvTableSchema>;

export type PanelId = 'dashboard' | 'data' | 'diversity' | 'ordination' | 'tests' | 'beta' | 'results' | 'settings' | 'help';

export type OrdinProject = {
  version: '4.0';
  meta: { name: string; created: string; modified: string };
  data: {
    species: SpeciesMatrix | null;
    env: EnvTable | null;
  };
  analyses: {
    nmds?: { stress: number; points: [number, number][]; method: string; distance: string };
    pca?: { eigenvalues: number[]; variance: number[]; scores: [number, number][] };
    // stubs for parity — filled as webR completes
    ca?: unknown; dca?: unknown; pcoa?: unknown; cca?: unknown; rda?: unknown; dbrda?: unknown; cap?: unknown;
    permanova?: unknown; anosim?: unknown; mantel?: unknown; envfit?: unknown;
    inext?: unknown; indices?: unknown;
    beta?: { sor: number; sim: number; sne: number; turnover_pct: number; nestedness_pct: number };
  };
  view: { activePanel: PanelId; mapStyle: string; theme: 'dark' | 'light' };
};

export const defaultProject = (): OrdinProject => ({
  version: '4.0',
  meta: { name: 'Untitled', created: new Date().toISOString(), modified: new Date().toISOString() },
  data: { species: null, env: null },
  analyses: {},
  view: { activePanel: 'dashboard', mapStyle: 'https://demotiles.maplibre.org/style.json', theme: 'dark' },
});

// --- Zustand store (single, like GeoLibre's useStore) ---
type OrdinState = {
  project: OrdinProject;
  // actions
  setPanel: (p: PanelId) => void;
  setSpecies: (s: SpeciesMatrix | null) => void;
  setEnv: (e: EnvTable | null) => void;
  loadSample: (name: 'dune' | 'varespec' | 'BCI') => Promise<void>;
  runNMDS: (opts: { k: number; distance: string }) => Promise<void>;
  clearData: () => void;
  // webr status
  webrReady: boolean;
  setWebRReady: (v: boolean) => void;
};

export const useOrdinStore = create<OrdinState>()(
  immer((set, get) => ({
    project: defaultProject(),
    webrReady: false,
    setWebRReady: (v) => set((s) => { s.webrReady = v; }),
    setPanel: (p) => set((s) => { s.project.view.activePanel = p; }),
    setSpecies: (s) => set((st) => { st.project.data.species = s; st.project.meta.modified = new Date().toISOString(); }),
    setEnv: (e) => set((st) => { st.project.data.env = e; }),
    clearData: () => set((st) => { st.project.data.species = null; st.project.data.env = null; st.project.analyses = {}; }),
    loadSample: async (name) => {
      // In web preview we fetch precomputed JSON; in Tauri we read local CSV via FS
      const res = await fetch('/assets/sample-results.json');
      const j = await res.json();
      const d = j.dune;
      set((st) => {
        st.project.data.species = { columns: d.species.columns, rownames: d.species.rownames, matrix: d.species.matrix };
        st.project.data.env = { columns: d.env.columns, rownames: d.env.rownames, rows: d.env.rows };
        st.project.meta.name = name;
      });
    },
    runNMDS: async ({ k, distance }) => {
      // Delegates to webR worker — here we simulate with the precomputed result for now
      const res = await fetch('/assets/sample-results.json');
      const j = await res.json();
      const n = j.nmds;
      // Simple MDS fallback if webR not ready: use points from JSON
      set((st) => {
        st.project.analyses.nmds = { stress: n.stress, points: j._points?.nmds ?? [[0,0]], method: 'nmds', distance };
      });
      void k; // keep param for real webR bridge
    },
  }))
);
