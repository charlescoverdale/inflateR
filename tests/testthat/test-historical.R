test_that("historical_value works for all currencies", {
  currencies <- c("GBP", "AUD", "USD", "EUR", "CAD", "JPY", "CNY", "CHF",
                  "NZD", "INR", "KRW", "BRL", "NOK")
  for (cur in currencies) {
    result <- historical_value(100, 2000, cur, from_year = 2020)
    expect_type(result, "double")
    expect_true(is.finite(result))
    expect_true(result > 0)
  }
})

test_that("historical_value accepts country names", {
  r1 <- historical_value(100, 2000, "GBP", from_year = 2020)
  r2 <- historical_value(100, 2000, "uk", from_year = 2020)
  expect_equal(r1, r2)
})

test_that("historical_value errors on invalid currency", {
  expect_error(historical_value(100, 2000, "NOPE"), "currency must be one of")
})

test_that("historical_value errors on out-of-range years", {
  expect_error(historical_value(100, 1800, "GBP", from_year = 2020),
               "to_year must be between")
  expect_error(historical_value(100, 2000, "GBP", from_year = 3000),
               "from_year must be between")
})

test_that("from_year == to_year returns original amount", {
  expect_equal(historical_value(42.50, 2010, "GBP", from_year = 2010), 42.50)
})

test_that("historical_value is the inverse of adjust_inflation", {
  fwd <- adjust_inflation(100, 2000, "GBP", to_year = 2020, round = NULL)
  inv <- historical_value(fwd, 2000, "GBP", from_year = 2020, round = NULL)
  expect_equal(inv, 100, tolerance = 1e-10)
})

test_that("historical_value is vectorised over amount", {
  result <- historical_value(c(100, 200), 2000, "GBP", from_year = 2020)
  expect_length(result, 2)
  expect_equal(result[2], result[1] * 2)
})

test_that("historical_value round parameter works", {
  full <- historical_value(100, 2000, "GBP", from_year = 2020, round = NULL)
  r2 <- historical_value(100, 2000, "GBP", from_year = 2020, round = 2)
  expect_equal(r2, round(full, 2))
})
