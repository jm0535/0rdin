# Ördin Data Format Guide

Quick reference for preparing your biodiversity data for analysis in Ördin.

---

## 📊 Three Supported Data Formats

### 1. **Abundance Data** (Individual Counts)

**When to use**: When you have **counts of individuals** from sampling

**Format**:
```csv
Site,Species_1,Species_2,Species_3
Forest_A,45,23,12
Forest_B,38,19,8
Grassland,52,31,15
```

**Characteristics**:
- ✅ First column: Site names
- ✅ Other columns: Species names
- ✅ Values: Integer counts (0, 1, 2, 3, ...)
- ✅ Represents: Number of individuals collected

**Example datasets**:
- `spider-abundance.csv` - Spider counts from pitfall traps
- `bird-abundance.csv` - Bird counts from point counts

**In Ördin**: Select "Abundance (counts)"

---

### 2. **Incidence_raw** (Presence/Absence)

**When to use**: When you only know if species are **present or absent**

**Format**:
```csv
Site,Species_1,Species_2,Species_3
Desert_A,0,1,1
Desert_B,1,0,1
Desert_C,0,0,1
```

**Characteristics**:
- ✅ First column: Site names
- ✅ Other columns: Species names
- ✅ Values: **Binary only** (0 = absent, 1 = present)
- ✅ Represents: Occurrence records

**Example datasets**:
- `ciliates-abundance.csv` *(misnamed, actually incidence!)*

**In Ördin**: 
- Select "Incidence (presence/absence)"
- App will **auto-detect** if all values are 0/1

---

### 3. **Incidence_freq** (Sampling Units)

**When to use**: When you have **multiple sampling units per site**

**Format**:
```csv
Site,SamplingUnits,Species_1,Species_2,Species_3
Forest_50m,599,330,263,236
Forest_500m,230,133,131,123
Forest_1000m,150,99,96,80
```

**Characteristics**:
- ✅ First column: Site names
- ✅ **Second column: MUST be named "SamplingUnits"**
- ✅ Other columns: Species names
- ✅ SamplingUnits value: Total number of sampling units (traps, quadrats, etc.)
- ✅ Species values: Number of sampling units where species was found

**Example datasets**:
- `ant-incidence.csv` - Ant occurrence across multiple traps

**In Ördin**: 
- Select "Incidence (presence/absence)"
- App will **auto-detect** SamplingUnits column

---

## 🎯 Quick Decision Tree

**START HERE**: What type of data do you have?

1. **Do you have counts of individuals?**
   - YES → Use **Abundance** format
   - NO → Continue to Q2

2. **Do you have sampling units (traps, quadrats, plots)?**
   - YES → Use **Incidence_freq** format
   - NO → Continue to Q3

3. **Do you only know presence/absence?**
   - YES → Use **Incidence_raw** format

---

## ⚙️ Auto-Detection Features

Ördin automatically detects your data format:

### ✅ Detection Rules

1. **Has "SamplingUnits" column?** 
   - → **incidence_freq**
   - Warning shown: "Detected incidence_freq with sampling units"

2. **All values are 0 or 1?**
   - → **incidence_raw**
   - Warning shown: "Auto-detected binary data (0/1)"

3. **Otherwise?**
   - → **abundance**

### 🔔 Automatic Corrections

If you select the wrong type, Ördin will:
- Show a **warning notification**
- **Auto-correct** to the detected format
- Display the **actual format** in plot subtitle

---

## 📝 Data Preparation Checklist

### General Requirements (All Formats)
- ✅ CSV file format
- ✅ First row: column headers
- ✅ First column: site names (unique)
- ✅ No missing values (use 0 for absences)
- ✅ All species columns: numeric values only
- ✅ Minimum 2 sites
- ✅ Minimum 3 species

### Abundance-Specific
- ✅ Values: Non-negative integers (0, 1, 2, ...)
- ✅ Minimum 5 individuals per site
- ✅ At least 10-20 total individuals recommended

### Incidence_raw-Specific
- ✅ Values: **Only 0 and 1**
- ✅ Minimum 3 occurrences per site
- ✅ At least 5-10 species with presence

### Incidence_freq-Specific
- ✅ **Second column MUST be named "SamplingUnits"**
- ✅ SamplingUnits: Integer > 0
- ✅ Species values: 0 to SamplingUnits (inclusive)
- ✅ Minimum 3 sampling units per site

---

## 🔧 Common Issues and Solutions

### Issue 1: "Data too sparse"
**Problem**: 99%+ of cells are zero  
**Solution**: 
- Filter out rare species
- Combine similar sites
- Use incidence instead of abundance

### Issue 2: "Insufficient sample size"
**Problem**: Too few individuals/occurrences  
**Solution**:
- Increase sampling effort
- Pool data from multiple time periods
- Use presence/absence instead

### Issue 3: Wrong format detection
**Problem**: App detects wrong format  
**Solution**:
- Check for typos in column names
- Ensure "SamplingUnits" is spelled exactly right
- Verify all species columns are numeric

### Issue 4: Incidence_freq not detected
**Problem**: Has sampling units but not recognized  
**Solution**:
- Column 2 MUST be named exactly: `SamplingUnits`
- Case-insensitive: "samplingunits" also works
- No spaces or special characters

---

## 📖 Example Conversions

### Converting Abundance → Incidence_raw

```r
# R code to convert
abundance_data <- read.csv("my_abundance.csv", row.names = 1)
incidence_data <- ifelse(abundance_data > 0, 1, 0)
write.csv(incidence_data, "my_incidence.csv", row.names = TRUE)
```

### Converting Abundance → Incidence_freq

```r
# If you have 10 sampling units per site
sites <- rownames(abundance_data)
sampling_units <- rep(10, nrow(abundance_data))

incidence_freq <- data.frame(
  Site = sites,
  SamplingUnits = sampling_units,
  abundance_data
)

write.csv(incidence_freq, "my_incidence_freq.csv", row.names = FALSE)
```

---

## 🎓 Statistical Background

### Why Different Formats?

**Abundance**: 
- Assumes equal sampling effort
- Sensitive to abundance differences
- Best for: Well-sampled, countable organisms

**Incidence_raw**:
- Ignores abundance
- Presence/absence only
- Best for: Difficult to count, detection/non-detection

**Incidence_freq**:
- Accounts for unequal sampling
- Uses replicate sampling units
- Best for: Complex sampling designs, multiple traps/quadrats

### iNEXT Differences

- **Abundance**: Rarefies by individuals
- **Incidence**: Rarefies by sampling units
- **Both**: Produce Hill numbers (q=0,1,2)

---

## 📚 Further Reading

- [iNEXT official documentation](https://github.com/JohnsonHsieh/iNEXT)
- `INCIDENCE-VS-ABUNDANCE.md` - Conceptual guide
- `ESTIMATES-AND-RAREFACTION-TYPES.md` - Technical details
- `INCIDENCE-DATA-FIX.md` - Implementation details

---

## ✅ Quick Test

**Test your understanding**: What format is this?

```csv
Site,SamplingUnits,Sp1,Sp2,Sp3
A,50,12,8,3
B,45,10,7,2
```

<details>
<summary>Answer</summary>

**incidence_freq** - Has SamplingUnits column with counts per unit
</details>

```csv
Site,Sp1,Sp2,Sp3
A,1,0,1
B,0,1,1
```

<details>
<summary>Answer</summary>

**incidence_raw** - Binary values only (0/1)
</details>

```csv
Site,Sp1,Sp2,Sp3
A,45,23,67
B,38,19,52
```

<details>
<summary>Answer</summary>

**abundance** - Count values (non-binary integers)
</details>

---

**Need help?** Check the error messages in Ördin - they provide specific guidance!
