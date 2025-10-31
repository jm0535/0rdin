# Understanding Incidence vs. Abundance Data in Ördin

## Quick Comparison

| Feature | Abundance Data | Incidence Data |
|---------|---------------|----------------|
| **What it measures** | How many individuals | How often species detected |
| **Data values** | Counts (0, 1, 2, 3, ...) | Frequency (0 to sampling units) |
| **Example** | "10 spiders caught" | "Spider found in 35 of 50 traps" |
| **Best for** | Population sizes | Presence/absence studies |
| **iNEXT datatype** | `"abundance"` | `"incidence"` |

---

## Abundance Data (Counts)

### What it is:
- **Count** of individuals of each species at each site
- Direct measure of population size or density

### CSV Format:
```csv
Site,Species_A,Species_B,Species_C
Forest_1,15,23,8
Forest_2,18,19,12
Grassland_1,5,45,2
```

### Example:
- Site: Forest_1
- Species_A: 15 individuals counted
- Species_B: 23 individuals counted
- Species_C: 8 individuals counted

### When to use:
- Direct counting (e.g., quadrats, transects)
- Complete census of organisms
- Population abundance studies

### Sample datasets:
- `spider-abundance.csv`
- `bird-abundance.csv`
- `ciliates-abundance.csv`
- `example-biodiversity.csv`

---

## Incidence Data (Presence/Absence)

### What it is:
- **Frequency** of detection across sampling units
- Measures how often a species is found, not how many individuals

### CSV Format:
```csv
Site,SamplingUnits,Species_A,Species_B,Species_C
Forest_1,50,35,12,48
Forest_2,30,18,8,22
```

### Example:
- Site: Forest_1
- SamplingUnits: 50 trap-days (e.g., 10 traps × 5 days)
- Species_A: Detected in 35 of the 50 sampling units
- Species_B: Detected in 12 of the 50 sampling units
- Species_C: Detected in 48 of the 50 sampling units

### When to use:
- Trap studies (pitfall traps, camera traps)
- Occurrence records (presence/absence)
- Detection-based surveys
- Rare species studies

### Sample datasets:
- `ant-incidence.csv`

---

## Incidence-Frequency Format Explained

The incidence format has a special first data column:

### Structure:
```
Site Name | Sampling Units | Species 1 freq | Species 2 freq | ...
```

### Sampling Units:
- Number of independent sampling occasions
- Examples:
  - 50 trap-days (10 traps × 5 days)
  - 100 quadrat surveys
  - 30 camera-trap nights

### Species Frequencies:
- How many times the species was detected
- Range: 0 (never detected) to n (sampling units)
- NOT a count of individuals!

### Real Example (Ant Data):
```csv
Site,SamplingUnits,Species_1,Species_2,Species_3
h50m,599,330,263,236
```

**Interpretation:**
- Site: h50m (50 meters elevation)
- 599 total sampling units (trap-days)
- Species_1 detected in 330 of 599 units (55%)
- Species_2 detected in 263 of 599 units (44%)
- Species_3 detected in 236 of 599 units (39%)

---

## Using in Ördin

### Step 1: Select Data Type

When you upload your CSV, choose the correct data type:

- **"Abundance (counts)"**: For count data
- **"Incidence (presence/absence)"**: For frequency data

### Step 2: Run Analysis

iNEXT will automatically use the appropriate statistical model:

- **Abundance**: Rarefaction based on individuals
- **Incidence**: Rarefaction based on sampling units

### Step 3: Interpret Results

Both produce:
- Diversity indices (q=0, 1, 2)
- Rarefaction/extrapolation curves
- But calculated differently based on data type!

---

## Why Does This Matter?

### Different Statistical Assumptions

1. **Abundance data assumes**:
   - Random sampling of individuals
   - Population can be censused
   - Counts are accurate

2. **Incidence data assumes**:
   - Species detection varies
   - Sampling is repeated over units
   - Detection probability < 1

### Different Interpretations

**Abundance**: "How many individuals are there?"

**Incidence**: "How widespread is the species?"

### Real-World Example

Imagine studying butterflies:

**Abundance approach:**
- Count every butterfly in 10 plots
- Plot_1: 15 Monarchs, 8 Swallowtails
- Plot_2: 22 Monarchs, 5 Swallowtails

**Incidence approach:**
- Check 50 flowers for butterfly visits
- Monarch detected on 35 flowers
- Swallowtail detected on 12 flowers

Same ecosystem, different questions!

---

## Converting Between Formats

### Can I convert abundance to incidence?

**Yes!** You can convert counts to presence/absence:

```r
# If species count > 0, mark as present (1)
# If species count = 0, mark as absent (0)
```

But you lose population information.

### Can I convert incidence to abundance?

**No!** You can't infer counts from presence/absence.

---

## Tips for Choosing

### Use Abundance When:
- ✓ You can count individuals accurately
- ✓ Population size matters
- ✓ You have complete surveys
- ✓ Organisms are easy to count

### Use Incidence When:
- ✓ Counting is difficult/impossible
- ✓ Detection is the challenge
- ✓ Using traps or repeated surveys
- ✓ Studying rare/cryptic species

---

## Summary

- **Abundance** = "How many?"
- **Incidence** = "How often?"
- Both are valid biodiversity measures
- Choose based on your sampling method
- Ördin handles both automatically! 🎉

---

**Need help?** Check the sample datasets to see examples of each format!
