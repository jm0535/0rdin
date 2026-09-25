# Development Guide — Ördin 4

For developers modifying, extending or contributing to Ördin. Read [`ARCHITECTURE.md`](ARCHITECTURE.md) first for the big picture.

## Prerequisites

| Tool | Version | Notes |
|---|---|---|
| Node.js | **≥ 22** | enforced by `engines` in `package.json` |
| npm | ≥ 10 | workspaces are required |
| Git | any recent | |
| Rust toolchain | stable | only for Tauri desktop builds |
| R | ≥ 4.4 | only for the legacy `shiny/` app and R CI scripts |

Linux desktop builds additionally need the [Tauri system dependencies](https://tauri.app/start/prerequisites/) (WebKitGTK, libsoup, etc.).

## Getting started

```bash
git clone https://github.com/jm0535/0rdin.git
cd 0rdin
npm install          # runs scripts/apply-dependency-patches.mjs afterwards
npm run dev          # http://localhost:9054
```

The dev server binds to `0.0.0.0:9054` so it can be reached from a VM, container or preview sandbox.

## Workspace scripts

| Script | Description |
|---|---|
| `npm run dev` | Vite dev server for `apps/ordin-desktop` |
| `npm run build` | `tsc -b` + Vite production build → `apps/ordin-desktop/dist` |
| `npm run preview` | Serve the production build on port 9054 |
| `npm run tauri:dev` | Tauri desktop shell in dev mode |
| `npm run tauri:build -w ordin-desktop` | Desktop bundles via `scripts/tauri-build.mjs` |
| `npm run typecheck` | `tsc --noEmit` in every workspace |
| `npm run lint` | ESLint (flat config) over `apps packages workers tests` |
| `npm test` | Workspace test suites |
| `npm run test:frontend` | `node --import tsx --test tests/*.test.ts` |
| `npm run legacy:start` | Start the legacy v3 Shiny/Electron app |

## Repository layout

```
apps/ordin-desktop/src
├── App.tsx                     # shell, hotkeys, panel routing
├── main.tsx                    # React root
├── components/layout/          # ActivityBar, Sidebar, RightInspector, StatusBar,
│                               # Toolbar, CommandPalette, ImportDialog,
│                               # PluginMarketplace, WorkflowFooter
├── components/panels/          # Dashboard, Data, Diversity, Ordination, Tests,
│                               # Beta, Classification, Traits, Results, Settings, Help
├── components/map/MapView.tsx  # optional MapLibre/deck.gl view
├── components/PlotCustomization.tsx
└── lib/downloadOrdin.ts        # .ordin project export

packages/core/src/index.ts        # zod schemas, OrdinProject, Zustand store
packages/processing/src/index.ts  # webR bridge + JS statistics
packages/ui/src/index.ts          # Button, Card, Badge, Input, Separator, Dialog, Sheet
packages/map/src/index.ts         # createMap()
```

## Conventions

- **TypeScript everywhere**, `strict` mode; no `any` in new public APIs.
- **State lives in the store.** Panels read with selectors (`useOrdinStore(s => …)`) and write through actions; never mutate `project` directly outside Immer producers.
- **Statistics live in `@ordin/processing`.** Components must not import `webr` directly.
- **Provenance is mandatory.** Any function returning results must set a `provenance` string, and panels must surface it.
- **Styling** uses Tailwind utility classes with the VS Code-inspired palette (`#121214` background, `#2d2d30` borders, `#2e8b57` accent).
- **Accessibility**: keyboard reachable controls, `aria-*` on custom widgets; the Playwright suite runs `@axe-core/playwright`.

## Adding a panel

1. Add the id to `PanelId` in `packages/core/src/index.ts` and, if it produces output, a slot under `OrdinProject['analyses']`.
2. Create `apps/ordin-desktop/src/components/panels/MyPanel.tsx`.
3. Register it in `App.tsx` (render switch) and `ActivityBar.tsx` (icon + label).
4. Add sidebar controls in `Sidebar.tsx` for the new panel id.
5. Put the computation in `packages/processing` — JS fast path and/or webR call with provenance.
6. Document the panel in `docs/FEATURES-OVERVIEW.md` and, if user-facing, add a guide in `docs/guides/`.

## Adding an R-backed analysis

```ts
export async function runMyAnalysisViaWebR(matrix: number[][]) {
  const webR = await getWebR();
  await webR.evalRVoid("library(vegan)");
  const shelter = await new webR.Shelter();
  try {
    await webR.objs.globalEnv.bind('m', matrix);
    const res = await shelter.evalR(`
      M <- do.call(rbind, m)
      fit <- vegan::myfun(M)
      list(stat = as.numeric(fit$stat))
    `);
    const out = await res.toJs();
    return { /* typed result */, provenance: 'REAL vegan::myfun via webR' };
  } finally {
    shelter.purge();
  }
}
```

Rules:
- Only use packages from the allow-list in [`ORDIN_STACK_AUDIT_2026-09-26.md`](ORDIN_STACK_AUDIT_2026-09-26.md) — every added package increases the WASM download.
- Always free shelters (`finally { shelter.purge() }`).
- Provide a JS fallback or a clear error when `crossOriginIsolated === false`.

## Testing

```bash
npm run typecheck
npm run lint
npm run test:frontend         # unit tests (node:test + tsx)
npx playwright test           # end-to-end + accessibility (installs browsers first)
```

CI workflows in `.github/workflows/`:

| Workflow | Purpose |
|---|---|
| `test.yml` | install, lint, typecheck, unit tests |
| `lint-js.yml` | dependency-free UTF-8/JS lint (`tools/lint-js.mjs`) |
| `test-r.yml` | legacy R suite, bootstrapped by `ci/install-r-packages.R` |

Manual QA checklist: [`development/TEST_CHECKLIST.md`](development/TEST_CHECKLIST.md).

## Debugging

- **webR never becomes ready** — check `crossOriginIsolated` in the console. Without COOP/COEP the app stays in mock mode by design.
- **Port 9054 busy** — `npm run dev -- --port 5173`.
- **Stale WASM assets** — clear the site's storage (DuckDB uses OPFS) and hard reload.
- **Type errors after editing a package** — run `npm run typecheck`; project references are built with `tsc -b`.
- **Native/desktop issues** — run `npm run tauri:dev` and read the Rust console output.

## Releasing

1. Update versions in `package.json` and `apps/ordin-desktop/package.json`.
2. Update [`CHANGELOG.md`](../CHANGELOG.md).
3. `npm run lint && npm run typecheck && npm test && npm run build`.
4. `npm run tauri:build -w ordin-desktop` for desktop artefacts.
5. Tag and push; attach bundles to the GitHub release. See [`setup/PUBLISH.md`](setup/PUBLISH.md).

Web deployment is automatic: pushing to `main` builds `apps/ordin-desktop` on Vercel using `vercel.json` (COOP/COEP headers included).

## Legacy v3 Shiny + Electron app

The `shiny/` and `src/` trees contain Ördin 3 (R Shiny UI inside an Electron shell). They are kept for reference and bug fixes only; new features go into the v4 app.

```bash
Rscript install-v3-packages.R    # install R dependencies
npm run legacy:start             # Electron + Shiny on port 9054
```

Legacy-specific documents are marked with a banner at the top of the file. Its module/service API is documented in [`API.md`](API.md#appendix--legacy-v3-shiny-api).
