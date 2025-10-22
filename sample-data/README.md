# Sample Species Abundance Data for Ördin

This file contains example species abundance data for testing the Ördin biodiversity analysis app.

## Data Format

The CSV file should have the following structure:
- **First column**: Site names (text)
- **Remaining columns**: Species abundances (numeric values)

Example:

```csv
Site,Species_A,Species_B,Species_C,Species_D,Species_E
Forest_Plot_1,15,23,8,12,5
Forest_Plot_2,18,19,12,9,7
Grassland_1,5,45,2,1,0
Grassland_2,7,38,3,2,1
Wetland_1,22,8,15,18,11
Wetland_2,19,10,14,16,9
```

## Sample Data

You can create a sample CSV file with this data to test Ördin:

| Site | Species_A | Species_B | Species_C | Species_D | Species_E | Species_F | Species_G |
|------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
| Forest_Plot_1 | 15 | 23 | 8 | 12 | 5 | 18 | 9 |
| Forest_Plot_2 | 18 | 19 | 12 | 9 | 7 | 15 | 11 |
| Forest_Plot_3 | 12 | 25 | 10 | 14 | 6 | 20 | 8 |
| Grassland_1 | 5 | 45 | 2 | 1 | 0 | 3 | 1 |
| Grassland_2 | 7 | 38 | 3 | 2 | 1 | 4 | 2 |
| Grassland_3 | 6 | 42 | 1 | 1 | 0 | 2 | 1 |
| Wetland_1 | 22 | 8 | 15 | 18 | 11 | 5 | 14 |
| Wetland_2 | 19 | 10 | 14 | 16 | 9 | 6 | 12 |
| Wetland_3 | 20 | 9 | 16 | 17 | 10 | 7 | 13 |

## Analysis Tips

### iNEXT Analysis (Diversity Estimation)
- Upload the CSV file
- Select "Diversity Estimation (iNEXT)"
- Click "Run Analysis"
- View rarefaction/extrapolation curves
- Download summary tables showing diversity indices (q=0: species richness, q=1: Shannon diversity, q=2: Simpson diversity)

### NMDS Ordination
- Upload the CSV file
- Select "Ordination (NMDS via vegan)"
- Choose number of dimensions (2 is recommended for visualization)
- Click "Run Analysis"
- Examine stress value (< 0.1 is good, < 0.2 is acceptable)
- Sites closer together in the plot have similar species compositions

## Creating Your Own Data

To use your own biodiversity data:

1. Create a CSV file with site names in the first column
2. Add species as columns (one column per species)
3. Enter abundance counts (integers) for each species at each site
4. Save as .csv format
5. Upload to Ördin

**Note**: Missing values should be entered as 0 (zero), not left blank.
