# 🌿 Getting Started with Ördin

Welcome to **Ördin 4** — a community ecology workbench that runs real R
(`vegan`, `iNEXT`, `betapart`) in your browser and on your desktop.

## What is Ördin?

- **iNEXT** rarefaction, extrapolation and Hill numbers
- **vegan** ordination (NMDS, PCA, CA, DCA, PCoA, CCA, RDA, db-RDA, CAP), tests
  (PERMANOVA, PERMDISP, ANOSIM, Mantel, envfit) and diversity indices
- **betapart / adespatial** beta-diversity partitioning
- Clustering, k-means, traits (CWM, RLQ, fourth-corner)
- Real-time plot customisation and publication-quality export
- Reproducible `.ordin` project files with provenance for every result

**No R installation.** R is compiled to WebAssembly and shipped with the app.

---

## 🚀 Use it (2 minutes)

### Option A — the web app

Open <https://ordin.in4metrix.dev>. The first load fetches the R runtime and
caches it; afterwards it works offline. Install it as a desktop PWA from your
browser's address bar if you like.

### Option B — the desktop app

Download the installer for your platform from the
[Releases page](https://github.com/jm0535/0rdin/releases):

- **Windows** — run the `.exe`
- **macOS** — open the `.dmg` and drag Ördin to Applications
- **Debian/Ubuntu** — `sudo dpkg -i ordin_4.0.0_amd64.deb`
- **Fedora/RHEL** — `sudo dnf install ordin-4.0.0-1.x86_64.rpm`

---

## 🛠️ Run from source (developers)

```bash
# 1. Node.js >= 22 — https://nodejs.org
node --version

# 2. Clone and install
git clone https://github.com/jm0535/0rdin.git
cd 0rdin
npm install

# 3. Start the dev server
npm run dev        # http://localhost:9054
```

Desktop shell: `npm run tauri:dev` (needs the
[Tauri prerequisites](https://tauri.app/start/prerequisites/)).

Full developer workflow: [`docs/DEVELOPMENT.md`](../docs/DEVELOPMENT.md).

---

## 📊 Your first analysis

1. **Data (1)** — click *Import*, or load the bundled `dune` dataset.
2. **Diversity (2)** — set `q = 0, 1, 2`, datatype `abundance`, run. You get
   rarefaction/extrapolation curves with bootstrap confidence intervals.
3. **Ordination (4)** — NMDS with Bray-Curtis, `k = 2`. Check the stress value
   (< 0.1 good, < 0.2 usable).
4. **Tests (5)** — PERMANOVA on a grouping variable, then PERMDISP to confirm
   dispersion homogeneity.
5. Export the figure (SVG/PNG) and tables (CSV/JSON), or save the whole session
   as a `.ordin` project.

Sample datasets live in [`sample-data/`](../sample-data).

---

## 📐 Data format

Sites in rows, taxa in columns, site ids in the first column:

```csv
Site,Species_A,Species_B,Species_C
Site1,12,0,3
Site2,5,7,0
```

Environmental data goes in a separate file sharing the site column; traits are
taxa × traits. Details:
[`docs/guides/DATA-STRUCTURE-GUIDE.md`](../docs/guides/DATA-STRUCTURE-GUIDE.md).

---

## ⌨️ Shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl/Cmd + K` | Command palette |
| `Ctrl/Cmd + B` | Toggle left sidebar |
| `Ctrl/Cmd + I` | Toggle right inspector |

---

## 🆘 Troubleshooting

| Symptom | Fix |
|---|---|
| Results labelled preview/mock | The page is not cross-origin isolated — use the deployed site, the desktop app or the local dev server |
| Analysis unavailable on first run | The R runtime is still downloading; wait for the status bar to say *ready* |
| `npm install` fails | `rm -rf node_modules package-lock.json && npm install` (Node ≥ 22) |
| Port 9054 in use | `npm run dev -- --port 5173` |
| Import rejected | Check for non-numeric cells, blank rows or a missing site column |

---

## 📚 Next steps

- [Documentation index](../docs/DOCS-INDEX.md)
- [Quick Start](../docs/QUICKSTART.md) · [Workflow](../docs/WORKFLOW.md) · [Features](../docs/FEATURES-OVERVIEW.md)
- [Architecture](../docs/ARCHITECTURE.md) · [Development](../docs/DEVELOPMENT.md) · [API](../docs/API.md)
- [Contributing](CONTRIBUTING.md)

Questions? Open an [issue](https://github.com/jm0535/0rdin/issues) or a
[discussion](https://github.com/jm0535/0rdin/discussions).
