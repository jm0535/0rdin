// Ördin v3.0 - Help Content Lazy Loader
// Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
// Load help topics on-demand to improve initial page load

const HelpLoader = {
  loadedTopics: new Set(),
  
  /**
   * Load help topic on demand
   * @param {string} topic - Topic identifier
   * @returns {Promise<string>} - HTML content
   */
  async loadTopic(topic) {
    if (this.loadedTopics.has(topic)) {
      return this.getTopicFromCache(topic);
    }
    
    try {
      // Try loading from separate HTML file first
      const response = await fetch(`help/${topic}.html`);
      if (response.ok) {
        const content = await response.text();
        this.loadedTopics.add(topic);
        return content;
      }
      
      // Fall back to existing help-content.js
      const content = this.getTopicContent(topic);
      this.loadedTopics.add(topic);
      return content;
    } catch (error) {
      console.error(`Failed to load help topic: ${topic}`, error);
      // Fall back to help-content.js
      return this.getTopicContent(topic);
    }
  },
  
  /**
   * Get topic content (placeholder for future file-based loading)
   * @param {string} topic - Topic identifier
   * @returns {string} - HTML content
   */
  getTopicContent(topic) {
    // This would be replaced with actual file loading in optimization
    if (typeof getHelpContent === 'function') {
      return getHelpContent(topic);
    }
    return '<div class="help-content">Content not available</div>';
  },
  
  /**
   * Get cached topic content
   * @param {string} topic - Topic identifier
   * @returns {string} - HTML content
   */
  getTopicFromCache(topic) {
    return this.getTopicContent(topic);
  },
  
  /**
   * Preload specific topics
   * @param {Array<string>} topics - Array of topic identifiers
   */
  async preload(topics) {
    const promises = topics.map(topic => this.loadTopic(topic));
    await Promise.all(promises);
  },
  
  /**
   * Clear cache
   */
  clearCache() {
    this.loadedTopics.clear();
  }
};

// Auto-preload commonly accessed topics
document.addEventListener('DOMContentLoaded', () => {
  // Preload the most frequently accessed topics
  HelpLoader.preload(['quick-start', 'data-import', 'nmds-guide']);
});

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
  module.exports = HelpLoader;
}
