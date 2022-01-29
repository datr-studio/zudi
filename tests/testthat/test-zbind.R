test_that("zbind binds dataframes", {
  x <- zbind(list(mtcars, mtcars, mtcars))
  expect_equal(nrow(x), nrow(mtcars) * 3)
})

test_that("zbind binds lists", {
  x <- list(a = 1, b = 1:5)
  y <- zbind(list(x, x, x))
  expect_equal(nrow(y), 15)
})