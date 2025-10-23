# Create sample datasets from vegan package for Ördin testing
# Author: Jimmy Moses

library(vegan)

# Load dune meadow vegetation data
data(dune)
data(dune.env)

# Add Site column as first column
df_species <- data.frame(Site = paste0("Site_", 1:nrow(dune)), dune)
df_env <- data.frame(Site = paste0("Site_", 1:nrow(dune.env)), dune.env)

# Export to CSV
write.csv(df_species, "sample_data_species.csv", row.names = FALSE)
write.csv(df_env, "sample_data_environment.csv", row.names = FALSE)

cat("\n✓ Sample datasets created successfully!\n")
cat("  - sample_data_species.csv:", nrow(df_species), "sites ×", ncol(df_species)-1, "species\n")
cat("  - sample_data_environment.csv:", nrow(df_env), "sites ×", ncol(df_env)-1, "variables\n")
cat("\nDataset description:\n")
cat("  Source: Dune meadow vegetation (vegan package)\n")
cat("  Species data: Abundance of 30 plant species at 20 sites\n")
cat("  Environment: A1 (soil thickness), Moisture, Management, Use, Manure\n")
