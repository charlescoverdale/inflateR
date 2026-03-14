test_that("adjust_real works for all currencies", {
  currencies <- c("GBP", "AUD", "USD", "EUR", "CAD", "JPY", "CNY", "CHF",
                  "NZD", "INR", "KRW", "BRL", "NOK")
  for (cur in currencies) {
    result <- adjust_real(100, 2000, cur, to_year = 2020)
    expect_type(result, "double")
    expect_true(is.finite(result))
    expect_true(result > 0)
  }
})

test_that("adjust_real gives known value for USD", {
  result <- adjust_real(100, 2000, "USD", to_year = 2020)
  expect_equal(result, round(100 * (100 / 69.9844), 2))
})

test_that("adjust_real accepts country names", {
  r1 <- adjust_real(100, 2000, "GBP", to_year = 2020)
  r2 <- adjust_real(100, 2000, "United Kingdom", to_year = 2020)
  expect_equal(r1, r2)
})

test_that("adjust_real errors on invalid currency", {
  expect_error(adjust_real(100, 2000, "FAKE"), "currency must be one of")
})

test_that("adjust_real errors on out-of-range years", {
  expect_error(adjust_real(100, 1800, "GBP"), "from_year must be between")
  expect_error(adjust_real(100, 2000, "GBP", to_year = 3000),
               "to_year must be between")
})

test_that("from_year == to_year returns original amount", {
  expect_equal(adjust_real(42.50, 2010, "GBP", to_year = 2010), 42.50)
})

test_that("adjust_real is vectorised over amount", {
  result <- adjust_real(c(100, 200, 300), 2000, "USD", to_year = 2020)
  expect_length(result, 3)
  expect_equal(result[2], result[1] * 2)
})

test_that("adjust_real round parameter works", {
  full <- adjust_real(100, 2000, "GBP", to_year = 2020, round = NULL)
  r2 <- adjust_real(100, 2000, "GBP", to_year = 2020, round = 2)
  expect_equal(r2, round(full, 2))
})
