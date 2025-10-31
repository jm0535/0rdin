# Ördin Global Constants
# Author: Jimmy Moses (jimmy.moses@pnguot.ac.pg)
# Global constants used throughout the application

# Application metadata
APP_NAME <- "Ördin"
APP_VERSION <- "3.0"
APP_AUTHOR <- "Jimmy Moses"
APP_EMAIL <- "jimmy.moses@pnguot.ac.pg"
APP_LICENSE <- "MIT"
APP_DESCRIPTION <- "An open-source cross-platform community ecology analysis software"

# Color palette
COLOR_PRIMARY <- "#2e8b57"
COLOR_SUCCESS <- "#2e8b57"
COLOR_WARNING <- "#d4a017"
COLOR_ERROR <- "#e74c3c"
COLOR_INFO <- "#4a90e2"
COLOR_DARK_BG <- "#252526"
COLOR_DARKER_BG <- "#1e1e1e"
COLOR_BORDER <- "#3e3e42"
COLOR_TEXT <- "#cccccc"
COLOR_TEXT_MUTED <- "#888888"

# UI dimensions
SIDEBAR_WIDTH <- "250px"
CONTENT_PADDING <- "24px"
PANEL_BORDER_RADIUS <- "6px"

# Notification durations (milliseconds)
NOTIFICATION_SUCCESS_DURATION <- 3000
NOTIFICATION_WARNING_DURATION <- 5000
NOTIFICATION_ERROR_DURATION <- 10000

# File upload
MAX_FILE_SIZE_MB <- 50
ACCEPTED_FILE_TYPES <- c(".csv", ".xlsx", ".xls", ".txt")

# Analysis thresholds
NMDS_STRESS_EXCELLENT <- 0.05
NMDS_STRESS_GOOD <- 0.10
NMDS_STRESS_FAIR <- 0.20

PVALUE_SIGNIFICANT <- 0.05
PVALUE_HIGHLY_SIGNIFICANT <- 0.01
PVALUE_VERY_HIGHLY_SIGNIFICANT <- 0.001

R2_HIGH <- 0.50
R2_MODERATE <- 0.25

ANOSIM_R_STRONG <- 0.75
ANOSIM_R_MODERATE <- 0.50

MANTEL_R_STRONG <- 0.70
MANTEL_R_MODERATE <- 0.40

# Distance methods
DISTANCE_METHODS <- c(
  "Bray-Curtis" = "bray",
  "Jaccard" = "jaccard",
  "Euclidean" = "euclidean",
  "Manhattan" = "manhattan",
  "Canberra" = "canberra",
  "Kulczynski" = "kulczynski",
  "Gower" = "gower"
)

# Export formats
EXPORT_FORMATS <- c("PNG" = "png", "PDF" = "pdf", "SVG" = "svg")

# Plot themes
PLOT_THEMES <- c("Clean" = "bw", "Minimal" = "minimal", "Dark" = "dark")

# Fonts
PLOT_FONTS <- c("Sans" = "sans", "Serif" = "serif", "Mono" = "mono")

# Point shapes (R base graphics)
POINT_SHAPES <- c(
  "Circle" = 21,
  "Square" = 22,
  "Diamond" = 23,
  "Triangle" = 24
)

# Validation messages
MSG_NO_DATA <- "No data loaded. Please upload or select a sample dataset."
MSG_NO_ENV_DATA <- "Environmental data required for this analysis."
MSG_NO_CATEGORICAL <- "No categorical variables found. This analysis requires grouping factors."
MSG_SUCCESS <- "Analysis completed successfully!"
MSG_ERROR_PREFIX <- "Error:"
MSG_WARNING_PREFIX <- "Warning:"

# Help text
HELP_NMDS <- "NMDS (Non-metric Multidimensional Scaling) is an ordination technique that attempts to represent dissimilarity between samples in low-dimensional space."
HELP_PERMANOVA <- "PERMANOVA tests whether group centroids differ in multivariate space using permutations."
HELP_ANOSIM <- "ANOSIM is a rank-based test for differences between groups, similar to PERMANOVA."
HELP_MANTEL <- "Mantel test examines correlation between two distance matrices using permutations."
HELP_ENVFIT <- "envfit overlays environmental variables as vectors or surfaces onto an ordination plot."
