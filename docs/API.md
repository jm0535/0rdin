# Ördin API Documentation

## Module: Data Management

### Functions

#### `dataManagementUI(id)`
Creates the UI components for data management.
- **Parameters:**
  - `id`: String, module identifier
- **Returns:** Shiny UI elements

#### `dataManagementServer(id)`
Server logic for data management.
- **Parameters:**
  - `id`: String, module identifier
- **Returns:** Reactive data object
- **Events:**
  - `input$dataFile`: Handles file uploads
  - `input$validateData`: Triggers data validation

### Reactive Values
- `data`: Holds the current dataset
- `validationStatus`: Current validation state

## Module: Diversity Analysis

### Functions

#### `diversityAnalysisUI(id)`
Creates the UI for diversity analysis.
- **Parameters:**
  - `id`: String, module identifier
- **Returns:** Shiny UI elements

#### `diversityAnalysisServer(id, data)`
Server logic for diversity calculations.
- **Parameters:**
  - `id`: String, module identifier
  - `data`: Reactive data source
- **Returns:** None
- **Events:**
  - `input$runInext`: Triggers iNEXT analysis
  - `input$runIndices`: Calculates diversity indices

### Analysis Types
1. **iNEXT Analysis**
   - Rarefaction/Extrapolation
   - Coverage-based curves
   - Hill numbers (q = 0, 1, 2)

2. **Diversity Indices**
   - Shannon diversity
   - Simpson diversity
   - Fisher's alpha
   - Pielou's evenness

## Module: Ordination

### Functions

#### `ordinationUI(id)`
Creates the UI for ordination analysis.
- **Parameters:**
  - `id`: String, module identifier
- **Returns:** Shiny UI elements

#### `ordinationServer(id, data)`
Server logic for ordination methods.
- **Parameters:**
  - `id`: String, module identifier
  - `data`: Reactive data source
- **Returns:** None
- **Events:**
  - `input$runOrdination`: Executes ordination analysis

### Ordination Methods
1. **NMDS**
   - Non-metric Multidimensional Scaling
   - Parameters: dimensions, distance measure

2. **PCA**
   - Principal Components Analysis
   - Parameters: scaling, centering

3. **CA/DCA**
   - (Detrended) Correspondence Analysis
   - Parameters: detrending, rescaling

4. **CCA/RDA**
   - Constrained analyses
   - Parameters: formula, scaling

5. **PCoA**
   - Principal Coordinates Analysis
   - Parameters: distance measure

### Data Transformations
- Hellinger
- Log(x+1)
- Square root
- Wisconsin double standardization

## Error Handling

### Validation Errors
- Invalid file format
- Missing values
- Negative abundances
- Zero-sum rows/columns

### Runtime Errors
- Memory limitations
- Convergence failures
- Singular matrices

## Export Formats
- CSV
- Excel (.xlsx)
- JSON
- PDF (plots)
