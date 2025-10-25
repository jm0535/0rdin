// Ördin v3.0 - Statistical Interpretation Module
// Author: Jimmy Moses (jmoses@pnguot.ac.pg)
// Critical Fix #2: Auto-interpret statistical results

// ===========================
// NMDS STRESS INTERPRETATION
// ===========================

/**
 * Interpret NMDS stress value (Clarke 1993 guidelines)
 * @param {number} stress - NMDS stress value
 * @returns {Object} interpretation object
 */
function interpretNMDSStress(stress) {
    if (stress < 0.05) {
        return {
            level: 'excellent',
            grade: 'A+',
            message: 'Excellent representation (stress < 0.05)',
            detail: 'The ordination configuration is very reliable. Distances in the plot closely match the original dissimilarities between samples.',
            recommendation: 'Results can be interpreted with high confidence.',
            color: '#2e8b57',
            citation: 'Clarke, K.R. (1993). Non-parametric multivariate analyses...'
        };
    } else if (stress < 0.10) {
        return {
            level: 'good',
            grade: 'A',
            message: 'Good representation (stress < 0.10)',
            detail: 'The configuration is usable and provides a good representation of the community structure.',
            recommendation: 'Interpretation is generally reliable for ecological conclusions.',
            color: '#2e8b57',
            citation: 'Clarke, K.R. (1993)'
        };
    } else if (stress < 0.20) {
        return {
            level: 'fair',
            grade: 'B',
            message: 'Fair representation (stress < 0.20)',
            detail: 'The configuration should be used with caution. Some distortion of original distances is present.',
            recommendation: 'Consider: (1) increasing dimensions (k), (2) trying different distance metric, or (3) checking for outliers.',
            color: '#d4a017',
            citation: 'Clarke, K.R. (1993)'
        };
    } else {
        return {
            level: 'poor',
            grade: 'C',
            message: 'Poor representation (stress ≥ 0.20)',
            detail: 'The configuration may be misleading. Substantial distortion of original distances is present.',
            recommendation: 'DO NOT interpret this ordination. Try: (1) increase k to 3+, (2) use different distance metric, (3) check for outliers/errors in data, (4) consider alternative ordination method (PCoA, CA).',
            color: '#ff6b6b',
            citation: 'Clarke, K.R. (1993)'
        };
    }
}

/**
 * Generate HTML for NMDS stress interpretation box
 * @param {number} stress - NMDS stress value
 * @returns {string} HTML string
 */
function generateStressInterpretationHTML(stress) {
    const interp = interpretNMDSStress(stress);
    
    return `
        <div style="background: ${interp.color}20; border-left: 3px solid ${interp.color}; padding: 16px; margin: 20px 0;">
            <h4 style="color: ${interp.color}; margin: 0 0 8px 0; font-size: 14px;">
                ${interp.message} [Grade: ${interp.grade}]
            </h4>
            <p style="color: #ccc; font-size: 12px; margin: 0 0 12px 0; line-height: 1.6;">
                ${interp.detail}
            </p>
            <p style="color: ${interp.color}; font-size: 12px; margin: 0; line-height: 1.6; font-weight: 600;">
                📌 Recommendation: ${interp.recommendation}
            </p>
            <p style="color: #666; font-size: 10px; margin: 12px 0 0 0; font-style: italic;">
                Based on: ${interp.citation}
            </p>
        </div>
    `;
}

// ===========================
// PERMANOVA INTERPRETATION
// ===========================

/**
 * Interpret PERMANOVA p-value with effect size (R²)
 * @param {number} pValue - p-value from PERMANOVA
 * @param {number} rSquared - R² (proportion of variance explained)
 * @returns {Object} interpretation object
 */
function interpretPERMANOVA(pValue, rSquared) {
    // Statistical significance
    let significance;
    if (pValue < 0.001) {
        significance = {
            text: 'highly significant',
            stars: '***',
            color: '#2e8b57'
        };
    } else if (pValue < 0.01) {
        significance = {
            text: 'very significant',
            stars: '**',
            color: '#2e8b57'
        };
    } else if (pValue < 0.05) {
        significance = {
            text: 'significant',
            stars: '*',
            color: '#2e8b57'
        };
    } else if (pValue < 0.10) {
        significance = {
            text: 'marginally significant',
            stars: '†',
            color: '#d4a017'
        };
    } else {
        significance = {
            text: 'not significant',
            stars: 'ns',
            color: '#888'
        };
    }
    
    // Effect size (Cohen 1988 guidelines adapted for ecology)
    let effectSize;
    if (rSquared < 0.01) {
        effectSize = {
            magnitude: 'negligible',
            interpretation: 'Very small effect. Groups barely differ.',
            color: '#888'
        };
    } else if (rSquared < 0.06) {
        effectSize = {
            magnitude: 'small',
            interpretation: 'Small but detectable effect. Ecological importance may be limited.',
            color: '#007acc'
        };
    } else if (rSquared < 0.14) {
        effectSize = {
            magnitude: 'moderate',
            interpretation: 'Moderate effect. Groups show meaningful differences in composition.',
            color: '#d4a017'
        };
    } else {
        effectSize = {
            magnitude: 'large',
            interpretation: 'Large effect. Groups are substantially different in composition.',
            color: '#2e8b57'
        };
    }
    
    // Combined interpretation
    const varExplained = (rSquared * 100).toFixed(1);
    
    return {
        significance,
        effectSize,
        summary: `The effect is ${significance.text} (p = ${pValue.toFixed(3)}${significance.stars}) with a ${effectSize.magnitude} effect size (R\u00b2 = ${rSquared.toFixed(3)}, ${varExplained}% of variance explained).`,
        ecological: effectSize.interpretation,
        warning: pValue < 0.05 && rSquared < 0.06 ? 'Note: Statistically significant but small effect size. Be cautious about biological/ecological importance.' : null
    };
}

/**
 * Generate HTML for PERMANOVA interpretation
 * @param {number} pValue - p-value
 * @param {number} rSquared - R² value
 * @returns {string} HTML string
 */
function generatePERMANOVAInterpretationHTML(pValue, rSquared) {
    const interp = interpretPERMANOVA(pValue, rSquared);
    
    let html = `
        <div style="background: #252526; border-left: 3px solid ${interp.effectSize.color}; padding: 16px; margin: 20px 0;">
            <h4 style="color: ${interp.significance.color}; margin: 0 0 8px 0; font-size: 14px;">
                📊 Interpretation
            </h4>
            <p style="color: #ccc; font-size: 12px; margin: 0 0 12px 0; line-height: 1.6;">
                ${interp.summary}
            </p>
            <p style="color: ${interp.effectSize.color}; font-size: 12px; margin: 0; line-height: 1.6;">
                <strong>Ecological meaning:</strong> ${interp.ecological}
            </p>
    `;
    
    if (interp.warning) {
        html += `
            <div style="background: #d4a01720; border: 1px solid #d4a017; padding: 8px; margin-top: 12px;">
                <p style="color: #d4a017; font-size: 11px; margin: 0; line-height: 1.6;">
                    ⚠️ ${interp.warning}
                </p>
            </div>
        `;
    }
    
    html += `
            <p style="color: #666; font-size: 10px; margin: 12px 0 0 0; font-style: italic;">
                Effect size based on Cohen (1988) guidelines adapted for community ecology
            </p>
        </div>
    `;
    
    return html;
}

// ===========================
// R² INTERPRETATION
// ===========================

/**
 * Interpret R² (variance explained) for ordination/regression
 * @param {number} rSquared - R² value (0-1)
 * @param {string} context - 'constrained ordination', 'regression', etc.
 * @returns {Object} interpretation
 */
function interpretRSquared(rSquared, context = 'constrained ordination') {
    const percent = (rSquared * 100).toFixed(1);
    
    let interpretation;
    if (rSquared < 0.10) {
        interpretation = {
            quality: 'weak',
            message: `Weak explanatory power (${percent}%)`,
            detail: 'Environmental variables explain little of the community variation. Most variation is unexplained.',
            color: '#888'
        };
    } else if (rSquared < 0.30) {
        interpretation = {
            quality: 'moderate',
            message: `Moderate explanatory power (${percent}%)`,
            detail: 'Environmental variables explain a moderate portion of community variation. This is typical for ecological data.',
            color: '#007acc'
        };
    } else if (rSquared < 0.60) {
        interpretation = {
            quality: 'good',
            message: `Good explanatory power (${percent}%)`,
            detail: 'Environmental variables explain a substantial portion of community variation.',
            color: '#2e8b57'
        };
    } else {
        interpretation = {
            quality: 'excellent',
            message: `Excellent explanatory power (${percent}%)`,
            detail: 'Environmental variables explain most of the community variation. Unusually high for ecological data - verify results.',
            color: '#2e8b57'
        };
    }
    
    return interpretation;
}

// ===========================
// P-VALUE CONTEXT
// ===========================

/**
 * Provide context for p-values (ASA 2016 statement)
 * @param {number} pValue - p-value
 * @returns {Object} contextualized interpretation
 */
function contextualizePValue(pValue) {
    const formatted = pValue.toFixed(3);
    
    if (pValue < 0.001) {
        return {
            interpretation: 'Very strong evidence against null hypothesis',
            context: 'Extremely unlikely to observe this pattern by chance alone',
            warning: null
        };
    } else if (pValue < 0.05) {
        return {
            interpretation: 'Evidence against null hypothesis',
            context: 'Pattern is unlikely under null hypothesis (< 5% chance)',
            warning: 'p < 0.05 is conventional threshold, not a bright line. Consider effect size and biological importance.'
        };
    } else if (pValue < 0.10) {
        return {
            interpretation: 'Weak evidence against null hypothesis',
            context: 'Pattern could plausibly occur by chance (5-10% probability)',
            warning: 'Marginal significance. Interpret cautiously and consider replication.'
        };
    } else {
        return {
            interpretation: 'Insufficient evidence against null hypothesis',
            context: 'Pattern is consistent with chance variation',
            warning: 'Absence of evidence is not evidence of absence. Lack of significance could reflect small sample size or small effect.'
        };
    }
}

// Export functions
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        interpretNMDSStress,
        generateStressInterpretationHTML,
        interpretPERMANOVA,
        generatePERMANOVAInterpretationHTML,
        interpretRSquared,
        contextualizePValue
    };
}
