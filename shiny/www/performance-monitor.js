// Ördin v3.0 - Performance Monitor
// Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
// Monitor and optimize app performance

const PerformanceMonitor = {
  metrics: {
    pageLoad: 0,
    jsExecution: 0,
    renderTime: 0,
    memoryUsage: 0
  },
  
  /**
   * Initialize performance monitoring
   */
  init() {
    if (window.performance && window.performance.timing) {
      this.measurePageLoad();
    }
    
    if (window.performance && window.performance.memory) {
      this.measureMemory();
    }
    
    this.setupObservers();
  },
  
  /**
   * Measure page load time
   */
  measurePageLoad() {
    window.addEventListener('load', () => {
      const timing = window.performance.timing;
      this.metrics.pageLoad = timing.loadEventEnd - timing.navigationStart;
      this.logMetric('Page Load', this.metrics.pageLoad + 'ms');
    });
  },
  
  /**
   * Measure memory usage
   */
  measureMemory() {
    if (window.performance.memory) {
      this.metrics.memoryUsage = window.performance.memory.usedJSHeapSize / 1048576; // MB
      this.logMetric('Memory Usage', this.metrics.memoryUsage.toFixed(2) + 'MB');
    }
  },
  
  /**
   * Setup mutation observers for render tracking
   */
  setupObservers() {
    const observer = new MutationObserver((mutations) => {
      this.measureRenderTime(mutations);
    });
    
    observer.observe(document.body, {
      childList: true,
      subtree: true
    });
  },
  
  /**
   * Measure render time
   * @param {Array} mutations - DOM mutations
   */
  measureRenderTime(mutations) {
    if (mutations.length > 10) {
      const start = performance.now();
      // Allow rendering to complete
      requestAnimationFrame(() => {
        const end = performance.now();
        this.metrics.renderTime = end - start;
      });
    }
  },
  
  /**
   * Log metric to console (development only)
   * @param {string} name - Metric name
   * @param {string} value - Metric value
   */
  logMetric(name, value) {
    if (console && console.debug) {
      console.debug(`[Performance] ${name}: ${value}`);
    }
  },
  
  /**
   * Get all metrics
   * @returns {Object} - Performance metrics
   */
  getMetrics() {
    return { ...this.metrics };
  },
  
  /**
   * Check if performance is degraded
   * @returns {boolean} - True if performance issues detected
   */
  isPerformanceDegraded() {
    return (
      this.metrics.pageLoad > 5000 || // > 5s page load
      this.metrics.memoryUsage > 100 || // > 100MB memory
      this.metrics.renderTime > 100 // > 100ms render
    );
  },
  
  /**
   * Get performance recommendations
   * @returns {Array<string>} - Performance recommendations
   */
  getRecommendations() {
    const recommendations = [];
    
    if (this.metrics.pageLoad > 5000) {
      recommendations.push('Consider code splitting to reduce initial load time');
    }
    
    if (this.metrics.memoryUsage > 100) {
      recommendations.push('High memory usage detected. Clear unused data');
    }
    
    if (this.metrics.renderTime > 100) {
      recommendations.push('Slow rendering detected. Optimize DOM operations');
    }
    
    return recommendations;
  }
};

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', () => {
  PerformanceMonitor.init();
  
  // Log metrics after 2 seconds
  setTimeout(() => {
    const metrics = PerformanceMonitor.getMetrics();
    console.log('[Ördin] Performance Metrics:', metrics);
    
    if (PerformanceMonitor.isPerformanceDegraded()) {
      const recommendations = PerformanceMonitor.getRecommendations();
      console.warn('[Ördin] Performance Recommendations:', recommendations);
    }
  }, 2000);
});

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
  module.exports = PerformanceMonitor;
}
