# Extract ant incidence data from iNEXT package for Ördin

library(iNEXT)

# Load ant data (incidence-frequency format)
data(ant)

# Ant data format:
# - First entry in each list element: number of sampling units
# - Remaining entries: species incidence frequencies (how many times each species was detected)

# Create a directory for sample data if it doesn't exist
if (!dir.exists("sample-data")) {
  dir.create("sample-data")
}

# Extract ant data
if (is.list(ant)) {
  # Get maximum number of species across all sites
  max_species <- max(sapply(ant, function(x) length(x) - 1))  # -1 because first value is sampling units
  
  # Create data frame
  ant_df <- data.frame(matrix(0, nrow = length(ant), ncol = max_species + 1))
  rownames(ant_df) <- names(ant)
  
  # Fill in the data
  for (i in seq_along(ant)) {
    site_data <- ant[[i]]
    # First column: sampling units
    ant_df[i, 1] <- site_data[1]
    # Remaining columns: species incidence frequencies
    if (length(site_data) > 1) {
      ant_df[i, 2:(length(site_data))] <- site_data[-1]
    }
  }
  
  # Set column names
  colnames(ant_df) <- c("SamplingUnits", paste0("Species_", 1:max_species))
  
  # Add site names as first column
  ant_df <- cbind(Site = rownames(ant_df), ant_df)
  rownames(ant_df) <- NULL
  
  # Write to CSV
  write.csv(ant_df, "sample-data/ant-incidence.csv", row.names = FALSE)
  cat("✓ Exported ant-incidence.csv\n")
  cat("  Format: Incidence-frequency (First data column = sampling units, rest = species incidence frequencies)\n")
  cat("  Sites:", nrow(ant_df), "\n")
  cat("  Species:", max_species, "\n")
}

cat("\nAnt incidence data extraction complete!\n")
