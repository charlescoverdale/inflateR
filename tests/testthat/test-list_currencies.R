test_that("list_currencies returns correct structure", {
  result <- list_currencies()
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 13)
  expect_named(result, c("currency", "country", "cpi_start", "cpi_end",
                          "deflator_start", "deflator_end"))
})

test_that("list_currencies contains all expected currencies", {
  result <- list_currencies()
  expected <- c("GBP", "AUD", "USD", "EUR", "CAD", "JPY", "CNY", "CHF",
                "NZD", "INR", "KRW", "BRL", "NOK")
  expect_equal(result$currency, expected)
})

test_that("list_currencies year ranges are plausible", {
  result <- list_currencies()
  expect_true(all(result$cpi_start >= 1960))
  expect_true(all(result$cpi_end >= 2020))
  expect_true(all(result$deflator_start >= 1960))
  expect_true(all(result$deflator_end >= 2020))
})

test_that("list_currencies shows China CPI starting later", {
  result <- list_currencies()
  cny <- result[result$currency == "CNY", ]
  expect_true(cny$cpi_start > 1960)
})

test_that("list_currencies shows Brazil CPI starting later", {
  result <- list_currencies()
  brl <- result[result$currency == "BRL", ]
  expect_true(brl$cpi_start > 1960)
})
