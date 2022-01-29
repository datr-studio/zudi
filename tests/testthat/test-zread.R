test_that("get file type works", {
  # Setup
  pattern <- "type_eg-"
  on.exit(purrr::walk(list.files(".", pattern = pattern), unlink))
  feather::write_feather(mtcars, paste0(pattern, 1, ".fe"))
  feather::write_feather(mtcars, paste0(pattern, 2))
  data.table::fwrite(mtcars, paste0(pattern, 3, ".tsv"))
  data.table::fwrite(mtcars, paste0(pattern, 4, ".csv", delim = ","))
  data.table::fwrite(mtcars, paste0(pattern, 5, ".xlsx"))
  # End Setup

  expect_equal(get_file_type(paste0(pattern, 1, ".fe")), "feather")
  expect_equal(get_file_type(paste0(pattern, 2)), "feather")
  expect_equal(get_file_type(paste0(pattern, 3, ".tsv")), "delim")
  expect_equal(get_file_type(paste0(pattern, 4, ".csv")), "delim")
  expect_error(get_file_type(paste0(pattern, 5, ".xlsx")))
})



test_that("zread works for feathers", {
  # Setup
  pattern <- "fe_eg-"
  on.exit(purrr::walk(list.files(".", pattern = pattern), unlink))
  for (i in 1:3) {
    feather::write_feather(mtcars, paste0(pattern, i, ".fe"))
  }
  # End Setup

  x <- zread(".", pattern = pattern, parallel = FALSE)
  expect_equal(nrow(x), nrow(mtcars) * 3)
})


test_that("zread works for delims", {
  # Setup
  pattern <- "fe_eg-"
  on.exit(purrr::walk(list.files(".", pattern = pattern), unlink))
  for (i in 1:3) {
    data.table::fwrite(mtcars, paste0(pattern, i, ".csv"))
  }
  # End Setup

  x <- zread(".", pattern = pattern, parallel = FALSE, cache = FALSE)
  expect_equal(nrow(x), nrow(mtcars) * 3)
})