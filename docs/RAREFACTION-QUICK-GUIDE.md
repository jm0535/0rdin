# Quick Guide: Choosing the Right Rarefaction Type in Ördin

## 🤔 Which rarefaction type should I use?

Use this decision tree to choose the right analysis for your data:

```
START: What kind of data do you have?
│
├─ I counted individuals (e.g., "15 beetles in plot A")
│  └─ USE: Individual-Based Rarefaction
│     • Data Type: "Abundance (counts)"
│     • Datasets: spider, bird, ciliates
│     • X-axis: Number of individuals
│
├─ I have trap/detection data (e.g., "species found in 35 of 50 traps")
│  └─ USE: Incidence-Based Rarefaction
│     • Data Type: "Incidence (presence/absence)"
│     • Datasets: ant
│     • X-axis: Number of sampling units
│
└─ I have multiple independent samples (e.g., "10 quadrats surveyed")
   └─ USE: Sample-Based Rarefaction
      • Data Type: "Abundance (counts)" (iNEXT handles internally)
      • Currently: Automatic in Ördin
      • X-axis: Number of samples
```

---

## 📊 Which plot type should I use?

After choosing your data type, select a plot type:

### Type 1: Sample-Size-Based ⭐ **MOST COMMON**
**Use when**: Standard rarefaction analysis

```
Perfect for:
✓ Comparing species richness across sites
✓ Standard ecological reports
✓ Most publications
✓ General biodiversity assessment

Shows:
• How richness increases with sampling
• Confidence intervals
• Extrapolation to predict more sampling
```

### Type 2: Sample Completeness
**Use when**: Evaluating survey quality

```
Perfect for:
✓ Checking if you sampled enough
✓ Planning future surveys
✓ Quality control
✓ Justifying sampling effort

Shows:
• What % of species you likely found
• How quickly you're finding new species
• When to stop sampling
```

### Type 3: Coverage-Based ⭐ **BEST FOR FAIR COMPARISON**
**Use when**: Sites have very different sampling

```
Perfect for:
✓ Comparing poorly vs. well-sampled sites
✓ Publication-quality comparisons
✓ Meta-analyses
✓ When sample sizes vary greatly

Shows:
• Diversity at equal "completeness"
• Fair comparison regardless of effort
• Most robust statistical comparison
```

---

## 🎯 Common Scenarios

### Scenario 1: Forest vs. Grassland Comparison
**Your data**: 
- Forest: 500 beetles counted, 45 species
- Grassland: 200 beetles counted, 30 species

**Question**: Which has higher diversity?

**Solution**:
1. Select: **"Abundance (counts)"**
2. Select: **"Sample-size-based (Type 1)"** or **"Coverage-based (Type 3)"**
3. Rarefy forest to 200 beetles (or compare at equal coverage)
4. Compare fairly!

---

### Scenario 2: Pitfall Trap Study
**Your data**:
- Site A: 50 trap-days, ant species detected in each
- Site B: 30 trap-days, ant species detected in each

**Question**: Is Site A more diverse?

**Solution**:
1. Select: **"Incidence (presence/absence)"**
2. Select: **"Sample-size-based (Type 1)"**
3. Rarefy Site A to 30 trap-days
4. Compare detection frequencies!

---

### Scenario 3: Did I Sample Enough?
**Your data**:
- Surveyed 100 individuals
- Found 25 species
- Budget allows 50 more individuals

**Question**: Should I keep sampling?

**Solution**:
1. Select: **"Abundance (counts)"**
2. Select: **"Sample completeness (Type 2)"**
3. Check coverage (if >90%, you're good!)
4. Use Type 1 extrapolation to predict 150 individuals

---

### Scenario 4: Multi-Site Comparison
**Your data**:
- 5 sites with very different sampling (100-800 individuals each)

**Question**: Which site is richest?

**Solution**:
1. Select: **"Abundance (counts)"**
2. Select: **"Coverage-based (Type 3)"** ⭐ BEST CHOICE
3. Compare at equal coverage (e.g., 70%)
4. Most fair comparison!

---

## 🔢 Understanding the Output

### Hill Numbers (q = 0, 1, 2)

Your results show **three diversity curves**:

```
q = 0 (Blue) - Species Richness
• Simple count of species
• All species weighted equally
• Sensitive to rare species
• "How many species are there?"

q = 1 (Green) - Shannon Diversity  
• Common species matter more
• Exponential of Shannon index
• Balanced measure
• "How many 'typical' species?"

q = 2 (Red) - Simpson Diversity
• Dominant species emphasized  
• Inverse Simpson index
• Evenness-focused
• "How many 'abundant' species?"
```

**Which to report?**
- **General audience**: q=0 (species richness) - easiest to understand
- **Ecologists**: q=1 (Shannon) - most balanced
- **Management**: q=2 (Simpson) - focuses on dominant species

---

## ⚡ Quick Tips

### ✅ DO:
- Use **Type 3 (coverage-based)** when sample sizes differ a lot
- Check **Type 2 (completeness)** before publishing
- Report **confidence intervals** (automatically included)
- Use **q=0, 1, 2** together for complete picture

### ❌ DON'T:
- Compare raw richness without rarefaction (unfair!)
- Ignore confidence intervals (overlapping = not different)
- Use only q=0 (you miss important diversity patterns)
- Extrapolate beyond 2x your sample size (unreliable)

---

## 📋 Checklist Before Publishing

```
□ Selected correct data type (abundance vs incidence)
□ Used appropriate plot type (Type 1 or 3 for comparisons)
□ Checked sample completeness (Type 2) - is it >70%?
□ Reported all three Hill numbers (q=0, 1, 2)
□ Included confidence intervals in figures
□ Noted when confidence intervals overlap (= not significantly different)
□ Extrapolation stays within 2x observed sample size
□ Cited iNEXT paper: Hsieh et al. (2016)
```

---

## 🎓 Statistical Interpretation

### Confidence Intervals:

```
If 95% CI overlap:
→ Sites are NOT significantly different
→ Don't claim one is "richer"

If 95% CI don't overlap:
→ Sites ARE significantly different (p<0.05)
→ Can claim difference in diversity
```

### Rarefaction vs Extrapolation:

```
Rarefaction (left of vertical line):
• Interpolation (resampling observed data)
• Very reliable
• Narrow confidence intervals
• Use for comparisons

Extrapolation (right of vertical line):
• Prediction (beyond observed data)
• Less reliable
• Wider confidence intervals  
• Use for planning, not definitive claims
```

### Coverage Values:

```
Coverage = 1.0 (100%): Perfect (impossible in nature!)
Coverage = 0.9 (90%): Excellent sampling
Coverage = 0.7 (70%): Good sampling  
Coverage = 0.5 (50%): Moderate (need more sampling)
Coverage < 0.5: Poor (definitely need more data)
```

---

## 🔬 Example Interpretation

**Your results**:
```
Plot Type 1: Sample-size-based
Site A: 35 species at 200 individuals (95% CI: 30-40)
Site B: 42 species at 200 individuals (95% CI: 38-46)
Confidence intervals overlap slightly
```

**Correct interpretation**:
> "At equal sampling effort (200 individuals), Site B showed slightly higher species richness (42 species) compared to Site A (35 species), though the difference was not statistically significant (95% confidence intervals overlapped). Both sites showed high sample completeness (>85% coverage), suggesting further sampling would yield few additional species."

**Incorrect interpretation**:
> "Site B has more species than Site A." ❌ (ignoring CI overlap)

---

## 📖 More Information

- **Detailed theory**: See `ESTIMATES-AND-RAREFACTION-TYPES.md`
- **Data formats**: See `INCIDENCE-VS-ABUNDANCE.md`  
- **Sample datasets**: Check `sample-data/README.md`
- **Implementation**: Read `docs/RAREFACTION-IMPLEMENTATION.md`

---

## 🆘 Troubleshooting

**Problem**: "My curves look weird"
- **Check**: Did you transpose your data? (sites should be columns for iNEXT)
- **Solution**: Ördin does this automatically, but verify your CSV format

**Problem**: "Confidence intervals are huge"
- **Check**: Sample size too small or too many rare species
- **Solution**: Collect more data or use coverage-based comparison

**Problem**: "I don't know if I sampled enough"
- **Check**: Type 2 plot - sample completeness
- **Solution**: If coverage <70%, you need more sampling

**Problem**: "Sites seem different but CI overlap"
- **Check**: You need more samples to detect the difference
- **Solution**: Can't claim significant difference; acknowledge uncertainty

---

**Remember**: When in doubt, use **Type 3 (Coverage-based)** for fairest comparison! 📊🌿
