# Check ciliates data structure
d <- read.csv('sample-data/ciliates-abundance.csv', row.names=1)

cat('=== CILIATES DATA STRUCTURE ===\n')
cat('Sites (rows):', nrow(d), '\n')
cat('Species (columns):', ncol(d), '\n\n')

cat('Total individuals per site:\n')
print(rowSums(d))
cat('\n')

cat('Species with at least 1 individual:', sum(colSums(d) > 0), '\n')
cat('Species with ALL zeros:', sum(colSums(d) == 0), '\n\n')

# Test iNEXT with this data
library(iNEXT)

cat('=== TESTING iNEXT ===\n')
# Transpose for iNEXT (sites as columns)
d_t <- t(d)

tryCatch({
  result <- iNEXT(d_t, q=c(0,1,2), datatype="abundance", knots=40, nboot=50)
  cat('SUCCESS: iNEXT ran successfully!\n')
  cat('iNextEst dimensions:', dim(result$iNextEst), '\n')
  print(head(result$iNextEst))
}, error = function(e) {
  cat('ERROR:', e$message, '\n')
})
