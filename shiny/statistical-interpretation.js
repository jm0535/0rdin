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

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        interpretNMDSStress,
        generateStressInterpretationHTML
    };
}