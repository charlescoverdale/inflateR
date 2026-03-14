test_that("historical_real works for all currencies", {
  currencies <- c("GBP", "AUD", "USD", "EUR", "CAD", "JPY", "CNY", "CHF",
                  "NZD", "INR", "KRW", "BRL", "NOK")
  for (cur in currencies) {
    result <- historical_real(100, 2000, cur, from_year = 2020)
    expect_type(result, "double")
    expect_true(is.finite(result))
    expect_true(result > 0)
  }
})

test_that("historical_real accepts country names", {
  r1 <- historical_real(100, 2000, "USD", from_year = 2020)
  r2 <- historical_real(100, 2000, "america", from_year = 2020)
  expect_equal(r1, r2)
})

test_that("historical_real errors on invalid currency", {
  expect_error(historical_real(100, 2000, "XYZ"), "currency must be one of")
})

test_that("historical_real errors on out-of-range years", {
  expect_error(historical_real(100, 1800, "GBP", from_year = 2020),
               "to_year must be between")
})

test_that("from_year == to_year returns original amount", {
  expect_equal(historical_real(42.50, 2010, "GBP", from_year = 2010), 42.50)
})

test_that("historical_real is the inverse of adjust_real", {
  fwd <- adjust_real(100, 2000, "USD", to_year = 2020, round = NULL)
  inv <- historical_real(fwd, 2000, "USD", from_year = 2020, round = NULL)
  expect_equal(inv, 100, tolerance = 1e-10)
})

test_that("historical_real is vectorised over amount", {
  result <- historical_real(c(100, 200), 2000, "USD", from_year = 2020,
                            round = NULL)
  expect_length(result, 2)
  expect_equal(result[2], result[1] * 2)
})

test_that("historical_real round parameter works", {
  full <- historical_real(100, 2000, "USD", from_year = 2020, round = NULL)
  r0 <- historical_real(100, 2000, "USD", from_year = 2020, round = 0)
  expect_equal(r0, round(full, 0))
})
