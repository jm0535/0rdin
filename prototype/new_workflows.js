// NEW CONSTRAINED ORDINATION WORKFLOWS

        'rda-analysis': {
            title: '🟢 RDA - Redundancy Analysis',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🟢 Redundancy Analysis (RDA)</h2>
                <p style="color: #888; margin-bottom: 30px;">Constrained ordination for linear responses (Euclidean distance)</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Load Required Datasets</h3>
                    <p style="color: #2e8b57;">✓ Species Data: species_data.csv (45 × 12)</p>
                    <p style="color: #888; margin-top: 8px;">⚠ Environmental Data Required</p>
                    <button style="background: #2e8b57; color: white; border: none; padding: 8px 16px; margin-top: 12px; cursor: pointer;">
                        📁 Load Environmental Data
                    </button>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Select Variables</h3>
                    <label style="display: block; margin-bottom: 8px; color: #888;">
                        <input type="checkbox" checked> pH
                    </label>
                    <label style="display: block; margin-bottom: 8px; color: #888;">
                        <input type="checkbox" checked> Temperature
                    </label>
                    <label style="display: block; margin-bottom: 8px; color: #888;">
                        <input type="checkbox"> Moisture
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Nitrogen
                    </label>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 3: Transformation</h3>
                    <label style="display: block; margin-bottom: 8px; color: #888;">
                        <input type="checkbox" checked> Center variables
                    </label>
                    <label style="display: block; color: #888;">
                        <input type="checkbox" checked> Scale variables
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run RDA
                </button>
            `
        },
        'cca-analysis': {
            title: '🟡 CCA - Canonical Correspondence Analysis',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🟡 Canonical Correspondence Analysis (CCA)</h2>
                <p style="color: #888; margin-bottom: 30px;">Constrained ordination for unimodal responses (chi-square distance)</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Load Environmental Data</h3>
                    <p style="color: #2e8b57;">✓ Species Data Loaded</p>
                    <button style="background: #2e8b57; color: white; border: none; padding: 8px 16px; margin-top: 12px; cursor: pointer;">
                        📁 Load Environmental Variables
                    </button>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Configure CCA</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Scaling:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Type 1 (distance scaling)</option>
                            <option>Type 2 (correlation scaling)</option>
                        </select>
                    </div>
                    <label style="display: block; color: #888;">
                        <input type="checkbox"> Hill's scaling
                    </label>
                </div>
                
                <button style="background: #2e8b57; color: white; border: 1px solid #3e3e42; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run CCA
                </button>
            `
        },
        'dbrda-analysis': {
            title: '🔴 db-RDA - Distance-based RDA',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔴 Distance-based Redundancy Analysis (db-RDA)</h2>
                <p style="color: #888; margin-bottom: 30px;">Constrained ordination for any distance matrix</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Select Distance Metric</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Distance Method:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Bray-Curtis</option>
                            <option>Jaccard</option>
                            <option>Euclidean</option>
                            <option>Manhattan</option>
                        </select>
                    </div>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Environmental Constraints</h3>
                    <p style="color: #888; font-size: 13px;">Select environmental variables to constrain the ordination</p>
                    <button style="background: #2a2a2a; border: 1px solid #3e3e42; color: #cccccc; padding: 8px 16px; margin-top: 12px; cursor: pointer;">
                        🌍 Load Environmental Data
                    </button>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run db-RDA
                </button>
            `
        },
        'cap-analysis': {
            title: '🔵 CAP - Constrained Analysis of Principal Coordinates',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔵 Constrained Analysis of Principal Coordinates (CAP)</h2>
                <p style="color: #888; margin-bottom: 30px;">Discriminant analysis using distance matrices</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 1: Define Groups</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Grouping Variable:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Site Type</option>
                            <option>Treatment</option>
                            <option>Season</option>
                        </select>
                    </div>
                </div>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Step 2: Distance Metric</h3>
                    <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                        <option>Bray-Curtis</option>
                        <option>Jaccard</option>
                    </select>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run CAP
                </button>
            `
        },

// STATISTICAL TESTS WORKFLOWS

        'permanova-test': {
            title: '🧪 PERMANOVA Test',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🧪 PERMANOVA (Permutational MANOVA)</h2>
                <p style="color: #888; margin-bottom: 30px;">Test for differences between groups using distance matrices</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Test Configuration</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Grouping Factor:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Site Type</option>
                            <option>Treatment</option>
                        </select>
                    </div>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Distance Method:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Bray-Curtis</option>
                            <option>Jaccard</option>
                        </select>
                    </div>
                    <div>
                        <label style="color: #888; display: block; margin-bottom: 4px;">Permutations:</label>
                        <input type="number" value="999" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run PERMANOVA
                </button>
            `
        },
        'anosim-test': {
            title: '📊 ANOSIM Test',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">📊 ANOSIM (Analysis of Similarities)</h2>
                <p style="color: #888; margin-bottom: 30px;">Non-parametric test for group differences</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Configuration</h3>
                    <div style="margin-bottom: 12px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Grouping:</label>
                        <select style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                            <option>Site</option>
                            <option>Treatment</option>
                        </select>
                    </div>
                    <div>
                        <label style="color: #888; display: block; margin-bottom: 4px;">Permutations:</label>
                        <input type="number" value="999" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run ANOSIM
                </button>
            `
        },
        'mantel-test': {
            title: '🔗 Mantel Test',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🔗 Mantel Test</h2>
                <p style="color: #888; margin-bottom: 30px;">Test correlation between two distance matrices</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Select Matrices</h3>
                    <p style="color: #888; font-size: 13px;">Matrix 1: Species composition (Bray-Curtis)</p>
                    <p style="color: #888; font-size: 13px;">Matrix 2: Environmental (Euclidean)</p>
                    <div style="margin-top: 16px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Permutations:</label>
                        <input type="number" value="999" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Run Mantel Test
                </button>
            `
        },
        'envfit-test': {
            title: '🌍 envfit - Environmental Variable Fitting',
            content: `
                <h2 style="color: #2e8b57; margin-bottom: 20px;">🌍 envfit - Fit Environmental Vectors</h2>
                <p style="color: #888; margin-bottom: 30px;">Overlay environmental variables on ordination</p>
                
                <div style="background: #252526; border: 1px solid #3e3e42; padding: 24px; margin-bottom: 20px;">
                    <h3 style="color: #cccccc; margin-bottom: 16px;">Select Variables to Fit</h3>
                    <label style="display: block; margin-bottom: 8px; color: #888;">
                        <input type="checkbox" checked> pH
                    </label>
                    <label style="display: block; margin-bottom: 8px; color: #888;">
                        <input type="checkbox" checked> Temperature
                    </label>
                    <label style="display: block; margin-bottom: 8px; color: #888;">
                        <input type="checkbox"> Moisture
                    </label>
                    <div style="margin-top: 16px;">
                        <label style="color: #888; display: block; margin-bottom: 4px;">Permutations:</label>
                        <input type="number" value="999" style="background: #1e1e1e; border: 1px solid #3e3e42; color: #cccccc; padding: 8px; width: 100%;">
                    </div>
                </div>
                
                <button style="background: #2e8b57; color: white; border: none; padding: 12px 24px; cursor: pointer; font-size: 14px; font-weight: 600;">
                    ▶ Fit Variables
                </button>
            `
        },
