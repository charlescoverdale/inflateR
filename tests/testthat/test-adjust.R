test_that("adjust_inflation works for all currencies", {
  currencies <- c("GBP", "AUD", "USD", "EUR", "CAD", "JPY", "CNY", "CHF",
                  "NZD", "INR", "KRW", "BRL", "NOK")
  for (cur in currencies) {
    result <- adjust_inflation(100, 2000, cur, to_year = 2020)
    expect_type(result, "double")
    expect_true(is.finite(result))
    expect_true(result > 0)
  }
})

test_that("adjust_inflation gives known value for GBP", {
  # £12 in 1963 → 2020: 12 * (100 / 5.71)
  result <- adjust_inflation(12, 1963, "GBP", to_year = 2020)
  expect_equal(result, round(12 * (100 / 5.71), 2))
})

test_that("adjust_inflation gives known value for USD", {
  result <- adjust_inflation(100, 2000, "USD", to_year = 2020)
  expect_equal(result, round(100 * (100 / 66.53), 2))
})

test_that("adjust_inflation accepts country names (case-insensitive)", {
  r1 <- adjust_inflation(100, 2000, "GBP", to_year = 2020)
  r2 <- adjust_inflation(100, 2000, "United Kingdom", to_year = 2020)
  r3 <- adjust_inflation(100, 2000, "uk", to_year = 2020)
  r4 <- adjust_inflation(100, 2000, "britain", to_year = 2020)
  r5 <- adjust_inflation(100, 2000, "ENGLAND", to_year = 2020)
  expect_equal(r1, r2)
  expect_equal(r1, r3)
  expect_equal(r1, r4)
  expect_equal(r1, r5)
})

test_that("adjust_inflation aliases work for all countries", {
  expect_equal(
    adjust_inflation(100, 2000, "australia", to_year = 2020),
    adjust_inflation(100, 2000, "AUD", to_year = 2020)
  )
  expect_equal(
    adjust_inflation(100, 2000, "us", to_year = 2020),
    adjust_inflation(100, 2000, "USD", to_year = 2020)
  )
  expect_equal(
    adjust_inflation(100, 2000, "america", to_year = 2020),
    adjust_inflation(100, 2000, "USD", to_year = 2020)
  )
  expect_equal(
    adjust_inflation(100, 2000, "eurozone", to_year = 2020),
    adjust_inflation(100, 2000, "EUR", to_year = 2020)
  )
  expect_equal(
    adjust_inflation(100, 2000, "swiss", to_year = 2020),
    adjust_inflation(100, 2000, "CHF", to_year = 2020)
  )
  expect_equal(
    adjust_inflation(100, 2000, "nz", to_year = 2020),
    adjust_inflation(100, 2000, "NZD", to_year = 2020)
  )
  expect_equal(
    adjust_inflation(100, 2000, "korea", to_year = 2020),
    adjust_inflation(100, 2000, "KRW", to_year = 2020)
  )
  expect_equal(
    adjust_inflation(100, 2000, "norwegian", to_year = 2020),
    adjust_inflation(100, 2000, "NOK", to_year = 2020)
  )
})

test_that("adjust_inflation errors on invalid currency", {
  expect_error(adjust_inflation(100, 2000, "ZZZ"),
               "currency must be one of")
})

test_that("adjust_inflation errors on out-of-range years", {
  expect_error(adjust_inflation(100, 1800, "GBP"), "from_year must be between")
  expect_error(adjust_inflation(100, 2000, "GBP", to_year = 3000),
               "to_year must be between")
})

test_that("from_year == to_year returns original amount", {
  expect_equal(adjust_inflation(42.50, 2010, "GBP", to_year = 2010), 42.50)
})

test_that("adjust_inflation is vectorised over amount", {
  result <- adjust_inflation(c(100, 200), 2000, "GBP", to_year = 2020)
  expect_length(result, 2)
  expect_equal(result[2], result[1] * 2)
})

test_that("round parameter works", {
  full <- adjust_inflation(100, 2000, "GBP", to_year = 2020, round = NULL)
  r2 <- adjust_inflation(100, 2000, "GBP", to_year = 2020, round = 2)
  r0 <- adjust_inflation(100, 2000, "GBP", to_year = 2020, round = 0)
  expect_equal(r2, round(full, 2))
  expect_equal(r0, round(full, 0))
})
