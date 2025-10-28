// Ördin v3.0 - Input Validation Module
// Author: Jimmy Moses (jmoses@pnguot.ac.pg)
// Critical Fix #1: Input validation for all user-entered values

// ===========================
// VALIDATION FUNCTIONS
// ===========================

/**
 * Validate confidence level (0-1 range)
 * @param {string|number} value - User input
 * @returns {Object} {valid: boolean, message: string, value: number}
 */
function validateConfidenceLevel(value) {
    const parsed = parseFloat(value);
    
    if (isNaN(parsed)) {
        return {
            valid: false,
            message: "❌ Confidence level must be numeric",
            value: null
        };
    }
    
    if (parsed < 0 || parsed > 1) {
        return {
            valid: false,
            message: "❌ Confidence level must be between 0 and 1",
            value: null
        };
    }
    
    if (parsed < 0.5 || parsed > 0.999) {
        return {
            valid: true,
            message: "⚠️ Typical range is 0.90-0.99. Are you sure?",
            value: parsed,
            warning: true
        };
    }
    
    return {
        valid: true,
        message: "✓ Valid confidence level",
        value: parsed
    };
}

/**
 * Validate number of knots for rarefaction curves
 * @param {string|number} value - User input
 * @returns {Object} validation result
 */
function validateKnots(value) {
    const parsed = parseInt(value);
    
    if (isNaN(parsed)) {
        return {
            valid: false,
            message: "❌ Knots must be an integer",
            value: null
        };
    }
    
    if (parsed < 10 || parsed > 100) {
        return {
            valid: false,
            message: "❌ Knots must be between 10 and 100",
            value: null
        };
    }
    
    if (parsed < 20) {
        return {
            valid: true,
            message: "⚠️ Knots < 20 may produce jagged curves",
            value: parsed,
            warning: true
        };
    }
    
    if (parsed > 60) {
        return {
            valid: true,
            message: "⚠️ Knots > 60 may cause overfitting",
            value: parsed,
            warning: true
        };
    }
    
    return {
        valid: true,
        message: "✓ Valid knots value",
        value: parsed
    };
}

/**
 * Validate NMDS dimensions
 * @param {string|number} value - User input
 * @returns {Object} validation result
 */
function validateDimensions(value) {
    const parsed = parseInt(value);
    
    if (isNaN(parsed)) {
        return {
            valid: false,
            message: "❌ Dimensions must be an integer",
            value: null
        };
    }
    
    if (parsed < 1 || parsed > 6) {
        return {
            valid: false,
            message: "❌ Dimensions must be between 1 and 6",
            value: null
        };
    }
    
    if (parsed > 3) {
        return {
            valid: true,
            message: "ℹ️ Dimensions > 3 are hard to visualize",
            value: parsed,
            warning: true
        };
    }
    
    return {
        valid: true,
        message: "✓ Valid dimensions",
        value: parsed
    };
}

/**
 * Validate number of permutations for PERMANOVA/ANOSIM
 * @param {string|number} value - User input
 * @returns {Object} validation result
 */
function validatePermutations(value) {
    const parsed = parseInt(value);
    
    if (isNaN(parsed)) {
        return {
            valid: false,
            message: "❌ Permutations must be an integer",
            value: null
        };
    }
    
    if (parsed < 99 || parsed > 9999) {
        return {
            valid: false,
            message: "❌ Permutations must be between 99 and 9999",
            value: null
        };
    }
    
    if (parsed < 499) {
        return {
            valid: true,
            message: "⚠️ Permutations < 499 may lack precision. Recommend 999+",
            value: parsed,
            warning: true
        };
    }
    
    return {
        valid: true,
        message: "✓ Valid permutations",
        value: parsed
    };
}

/**
 * Validate sample size adequacy
 * @param {number} sampleSize - Number of samples
 * @returns {Object} validation result
 */
function validateSampleSize(sampleSize) {
    if (sampleSize < 3) {
        return {
            valid: false,
            message: "❌ At least 3 samples required for statistical analysis",
            value: sampleSize
        };
    }
    
    if (sampleSize < 10) {
        return {
            valid: true,
            message: "⚠️ Sample size < 10 may limit statistical power. Consider collecting more samples or using bootstrap methods.",
            value: sampleSize,
            warning: true
        };
    }
    
    if (sampleSize < 20) {
        return {
            valid: true,
            message: "ℹ️ Sample size is adequate. Larger samples (20+) improve reliability.",
            value: sampleSize,
            info: true
        };
    }
    
    return {
        valid: true,
        message: "✓ Sample size is good",
        value: sampleSize
    };
}

/**
 * Validate point size for plots
 * @param {string|number} value - User input
 * @returns {Object} validation result
 */
function validatePointSize(value) {
    const parsed = parseFloat(value);
    
    if (isNaN(parsed)) {
        return {
            valid: false,
            message: "❌ Point size must be numeric",
            value: null
        };
    }
    
    if (parsed < 0.5 || parsed > 10) {
        return {
            valid: false,
            message: "❌ Point size must be between 0.5 and 10",
            value: null
        };
    }
    
    return {
        valid: true,
        message: "✓ Valid point size",
        value: parsed
    };
}

/**
 * Validate alpha transparency (0-1)
 * @param {string|number} value - User input
 * @returns {Object} validation result
 */
function validateAlpha(value) {
    const parsed = parseFloat(value);
    
    if (isNaN(parsed)) {
        return {
            valid: false,
            message: "❌ Alpha must be numeric",
            value: null
        };
    }
    
    if (parsed < 0 || parsed > 1) {
        return {
            valid: false,
            message: "❌ Alpha must be between 0 and 1",
            value: null
        };
    }
    
    return {
        valid: true,
        message: "✓ Valid alpha",
        value: parsed
    };
}

// ===========================
// UI HELPER FUNCTIONS
// ===========================

/**
 * Show validation message to user
 * @param {string} message - Message to display
 * @param {string} type - 'error', 'warning', 'info', 'success'
 */
function showValidationMessage(message, type = 'error') {
    const colors = {
        error: '#ff6b6b',
        warning: '#d4a017',
        info: '#007acc',
        success: '#2e8b57'
    };
    
    const icons = {
        error: '❌',
        warning: '⚠️',
        info: 'ℹ️',
        success: '✓'
    };
    
    // Create or update validation message element
    let msgElement = document.getElementById('validation-message');
    if (!msgElement) {
        msgElement = document.createElement('div');
        msgElement.id = 'validation-message';
        msgElement.style.cssText = `
            position: fixed;
            top: 50px;
            right: 20px;
            padding: 12px 20px;
            border-radius: 4px;
            font-size: 13px;
            z-index: 10000;
            animation: slideIn 0.3s ease-out;
        `;
        document.body.appendChild(msgElement);
    }
    
    msgElement.style.background = colors[type] + '20';
    msgElement.style.border = `1px solid ${colors[type]}`;
    msgElement.style.color = colors[type];
    msgElement.textContent = `${icons[type]} ${message}`;
    
    // Auto-hide after 5 seconds
    setTimeout(() => {
        if (msgElement && msgElement.parentNode) {
            msgElement.remove();
        }
    }, 5000);
}

/**
 * Attach validation to input field
 * @param {HTMLElement} input - Input element
 * @param {Function} validator - Validation function
 */
function attachValidation(input, validator) {
    input.addEventListener('blur', function() {
        const result = validator(this.value);
        
        if (!result.valid) {
            this.style.borderColor = '#ff6b6b';
            showValidationMessage(result.message, 'error');
        } else if (result.warning) {
            this.style.borderColor = '#d4a017';
            showValidationMessage(result.message, 'warning');
        } else if (result.info) {
            this.style.borderColor = '#007acc';
            showValidationMessage(result.message, 'info');
        } else {
            this.style.borderColor = '#2e8b57';
        }
    });
    
    input.addEventListener('focus', function() {
        this.style.borderColor = '#3e3e42';
    });
}

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        validateConfidenceLevel,
        validateKnots,
        validateDimensions,
        validatePermutations,
        validateSampleSize,
        validatePointSize,
        validateAlpha,
        showValidationMessage,
        attachValidation
    };
}