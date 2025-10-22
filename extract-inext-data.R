# Extract iNEXT example datasets for Ördin

library(iNEXT)

# Spider data (comes as a list, extract first dataset)
data(spider)
spider_matrix <- spider[[1]]  # Get first site's data
# Convert list to data frame
if (is.list(spider)) {
  # Spider is a list of abundance vectors
  max_species <- max(sapply(spider, length))
  spider_df <- data.frame(matrix(0, nrow = length(spider), ncol = max_species))
  rownames(spider_df) <- names(spider)
  for (i in seq_along(spider)) {
    spider_df[i, 1:length(spider[[i]])] <- spider[[i]]
  }
  colnames(spider_df) <- paste0("Species_", 1:ncol(spider_df))
  spider_df <- cbind(Site = rownames(spider_df), spider_df)
  rownames(spider_df) <- NULL
  write.csv(spider_df, "sample-data/spider-abundance.csv", row.names = FALSE)
  cat("✓ Spider dataset exported\n")
}

# Bird data
data(bird)
bird_df <- as.data.frame(t(bird))
bird_df <- cbind(Site = rownames(bird_df), bird_df)
rownames(bird_df) <- NULL
write.csv(bird_df, "sample-data/bird-abundance.csv", row.names = FALSE)
cat("✓ Bird dataset exported\n")

# Ciliates data (also a list format)
data(ciliates)
if (is.list(ciliates) && !is.data.frame(ciliates)) {
  # Ciliates is a list, extract and convert
  max_species <- max(sapply(ciliates, length))
  ciliates_df <- data.frame(matrix(0, nrow = length(ciliates), ncol = max_species))
  rownames(ciliates_df) <- names(ciliates)
  for (i in seq_along(ciliates)) {
    ciliates_df[i, 1:length(ciliates[[i]])] <- ciliates[[i]]
  }
  colnames(ciliates_df) <- paste0("Species_", 1:ncol(ciliates_df))
  ciliates_df <- cbind(Site = rownames(ciliates_df), ciliates_df)
  rownames(ciliates_df) <- NULL
} else {
  ciliates_df <- as.data.frame(t(ciliates))
  ciliates_df <- cbind(Site = rownames(ciliates_df), ciliates_df)
  rownames(ciliates_df) <- NULL
}
write.csv(ciliates_df, "sample-data/ciliates-abundance.csv", row.names = FALSE)
cat("✓ Ciliates dataset exported\n")

cat("\n========================================\n")
cat("All iNEXT example datasets exported!\n")
cat("Files created in sample-data/ folder:\n")
cat("  - spider-abundance.csv\n")
cat("  - bird-abundance.csv\n")
cat("  - ciliates-abundance.csv\n")
cat("========================================\n")
