import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import wasm from 'vite-plugin-wasm';
import path from 'path';

export default defineConfig({
  plugins: [react(), wasm()],
  server: {
    host: '0.0.0.0',
    port: 9054,
    cors: true,
    hmr: { host: 'localhost' },
    allowedHosts: true,
    // COOP/COEP needed for SharedArrayBuffer (DuckDB/webR) breaks E2B iframe preview;
    // keep preview unblocked. Tauri prod sets these in tauri.conf.json instead.
    // headers: { 'Cross-Origin-Opener-Policy': 'same-origin', 'Cross-Origin-Embedder-Policy': 'require-corp' },
  },
  preview: { host: '0.0.0.0', port: 9054, cors: true, allowedHosts: true },
  optimizeDeps: { exclude: ['webr', '@duckdb/duckdb-wasm'] },
  assetsInclude: ['**/*.wasm'],
  resolve: {
    alias: {
      '@ordin/core': path.resolve(__dirname, '../../packages/core/src/index.ts'),
      '@ordin/map': path.resolve(__dirname, '../../packages/map/src/index.ts'),
      '@ordin/processing': path.resolve(__dirname, '../../packages/processing/src/index.ts'),
      '@ordin/ui': path.resolve(__dirname, '../../packages/ui/src/index.ts'),
    },
  },
});
