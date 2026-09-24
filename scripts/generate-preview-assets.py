#!/usr/bin/env python3
"""Generate placeholder preview assets for Ördin 4.0 (GeoLibre stack) quickly."""
import json, pathlib, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

REPO = pathlib.Path(__file__).resolve().parents[1]
OUT = REPO / "apps/ordin-desktop/public/assets/plots"
OUT.mkdir(parents=True, exist_ok=True)

# read dune to keep stats realistic
sp = pd.read_csv(REPO / "sample-data/dune_species.csv", index_col=0)
env = pd.read_csv(REPO / "sample-data/dune_environment.csv", index_col=0)
X = sp.values.astype(float)

def placeholder(name, title, color="#2e8b57"):
    fig, ax = plt.subplots(figsize=(6,4))
    ax.set_facecolor("#f7f7f7")
    # simple scatter
    rng = np.random.default_rng(abs(hash(name)) % (2**31))
    pts = rng.normal(0,1, size=(20,2))
    ax.scatter(pts[:,0], pts[:,1], c=color, s=40, alpha=0.7, edgecolors="#333")
    ax.set_title(title, fontsize=12, fontweight="bold", color=color)
    ax.set_xlabel("Axis 1"); ax.set_ylabel("Axis 2")
    ax.grid(True, color="#e6e6e6")
    fig.tight_layout()
    fig.savefig(OUT / f"{name}.png", dpi=120, bbox_inches="tight")
    plt.close(fig)
    print(f"plot {name}.png")

for name, title, col in [
    ("nmds","NMDS — stress 0.186 (Good)","#2e8b57"),
    ("pca","PCA — PC1 23.4%","#4a90e2"),
    ("ca","CA — inertia 2.11","#9b59b6"),
    ("dca","DCA — length 6.66 SD","#ffa500"),
    ("pcoa","PCoA — PCoA1 37.4%","#2e8b57"),
    ("cca","CCA — constrained 63%","#4a90e2"),
    ("rda","RDA — constrained","#9b59b6"),
    ("dbrda","dbRDA — Bray","#2e8b57"),
    ("cap","CAP — groups","#ffa500"),
    ("permanova_variance","PERMANOVA","#2e8b57"),
    ("anosim","ANOSIM","#4a90e2"),
    ("mantel","Mantel","#9b59b6"),
    ("envfit","envfit","#2e8b57"),
    ("inext","iNEXT","#4a90e2"),
    ("indices","Indices","#2e8b57"),
    ("beta","Beta","#ffa500"),
]:
    placeholder(name, title, col)

# build JSON (reuse logic from earlier but simplified)
n, p = X.shape
sor, sim, sne = 0.6456, 0.5769, 0.0687
results = {
  "meta": {"dataset":"dune","sites":n,"species":p},
  "dune": {
    "species": {"columns": list(sp.columns), "rownames": [str(i) for i in sp.index], "matrix": X.astype(int).tolist()},
    "env": {"columns": list(env.columns), "rownames": [str(i) for i in env.index], "rows": env.astype(str).values.tolist()}
  },
  "nmds": {"stress":0.186,"grade":"Good","interpretation":"Stress below 0.20 indicates good 2-D representation."},
  "pca": {"table":{"headers":["Axis","Variance (%)","Cumulative (%)"],"rows":[["PC1","23.4","23.4"],["PC2","16.7","40.1"]]},"interpretation":"PCA.","summary":"PC1 23.4%"},
  "ca": {"table":{"headers":["Axis","Inertia (%)","Cumulative (%)"],"rows":[["CA1","25.3","25.3"]]},"interpretation":"CA.","summary":"inertia 2.11"},
  "dca": {"table":{"headers":["Axis","Length (SD)"],"rows":[["DCA1","6.66"]]},"interpretation":"DCA.","summary":"lengths"},
  "pcoa": {"table":{"headers":["Axis","Variance (%)","Cumulative (%)"],"rows":[["PCoA1","37.4","37.4"]]},"interpretation":"PCoA.","summary":"PCoA1"},
  "cca": {"table":{"headers":["Axis","Variance (%)","Cumulative (%)"],"rows":[["CCA1","63.7","63.7"]]},"interpretation":"CCA.","summary":"cca"},
  "rda": {"table":{"headers":["Axis","Variance (%)","Cumulative (%)"],"rows":[["RDA1","44.4","44.4"]]},"interpretation":"RDA.","summary":"RDA1"},
  "dbrda": {"table":{"headers":["Axis","Variance (%)","Cumulative (%)"],"rows":[["dbRDA1","52.5","52.5"]]},"interpretation":"dbRDA.","summary":"dbRDA1"},
  "cap": {"table":{"headers":["CAP axis","Eigenvalue (%)"],"rows":[["CAP1","61.2"]]},"interpretation":"CAP.","summary":"CAP"},
  "permanova_nmds": {"rows":[{"term":"Management","df":3,"r2":0.658,"F":10.28,"p":0.0033},{"term":"Moisture","df":1,"r2":0.439,"F":10.96,"p":0.0033},{"term":"Use","df":2,"r2":0.388,"F":3.49,"p":0.187},{"term":"Residual","df":13,"r2":None,"F":None,"p":None}],"interpretation":"Management explains 65.8%."},
  "anosim": {"R":0.258,"p":0.01,"interpretation":"ANOSIM R=0.258."},
  "mantel": {"r":0.5496,"p":0.0033,"interpretation":"Mantel r=0.5496."},
  "envfit": {"rows":[{"v":"A1","r2":0.21,"p":0.01},{"v":"Moisture","r2":0.41,"p":0.0033}],"interpretation":"envfit."},
  "diversity": {"inext_table": [["1",5,20,"0.80","1.2","0.8"]], "indices_table":[["BF","1.8","0.7","2.1","0.8"]], "site_indices":[["1","1.5","0.7","2.1","0.8"]], "indices_interpretation":"Shannon."},
  "beta": {"sor":round(sor,4),"sim":round(sim,4),"sne":round(sne,4),"turnover_pct":89.4,"nestedness_pct":10.6,"pairs":190,"interpretation":f"Beta sor {sor:.3f}."},
  "_points": {"nmds": [[0,0]]*20}
}
out_json = REPO / "apps/ordin-desktop/public/assets/sample-results.json"
out_json.parent.mkdir(parents=True, exist_ok=True)
out_json.write_text(json.dumps(results, indent=2))
print(f"json {out_json} {out_json.stat().st_size} bytes")
