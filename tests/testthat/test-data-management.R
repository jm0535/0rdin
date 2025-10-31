library(testthat)
library(shiny)
library(readr)

test_that("data management module handles valid CSV files", {
  testServer(dataManagementServer, {
    # Create test CSV
    test_data <- data.frame(
      Species = c("sp1", "sp2", "sp3"),
      Site1 = c(1, 2, 3),
      Site2 = c(4, 5, 6)
    )
    temp_file <- tempfile(fileext = ".csv")
    write.csv(test_data, temp_file, row.names = FALSE)
    
    # Simulate file upload
    session$setInputs(dataFile = list(
      datapath = temp_file,
      name = "test.csv",
      type = "text/csv",
      size = file.info(temp_file)$size
    ))
    
    # Check if data was loaded correctly
    expect_true(!is.null(isolate(data())))
    expect_equal(nrow(isolate(data())), 3)
    expect_equal(ncol(isolate(data())), 3)
  })
})

test_that("data management module handles invalid files", {
  testServer(dataManagementServer, {
    # Create invalid CSV
    temp_file <- tempfile(fileext = ".csv")
    writeLines("invalid,data\na,b,c\n1,2", temp_file)
    
    # Expect error notification
    expect_error({
      session$setInputs(dataFile = list(
        datapath = temp_file,
        name = "invalid.csv",
        type = "text/csv",
        size = file.info(temp_file)$size
      ))
    })
  })
})

test_that("data validation works correctly", {
  testServer(dataManagementServer, {
    # Test valid data
    valid_data <- data.frame(
      Species = c("sp1", "sp2"),
      Site1 = c(1, 2),
      Site2 = c(3, 4)
    )
    result <- validateData(valid_data)
    expect_true(result$valid)
    
    # Test invalid data (negative values)
    invalid_data <- data.frame(
      Species = c("sp1", "sp2"),
      Site1 = c(-1, 2),
      Site2 = c(3, 4)
    )
    result <- validateData(invalid_data)
    expect_false(result$valid)
  })
})
