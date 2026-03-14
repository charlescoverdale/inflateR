test_that("inflation_rate returns sensible cumulative values", {
  # US inflation 2000-2020: (100 / 66.53) - 1 ≈ 0.503
  result <- inflation_rate(2000, 2020, "USD")
  expect_equal(result, (100 / 66.53) - 1, tolerance = 0.001)
  expect_true(result > 0.4 && result < 0.6)
})

test_that("inflation_rate annualised works", {
  cum <- inflation_rate(2000, 2020, "USD")
  ann <- inflation_rate(2000, 2020, "USD", annualise = TRUE)
  # Annualised should be much smaller than cumulative

  expect_true(ann < cum)
  expect_true(ann > 0.01 && ann < 0.05)
  # Check the math: (1 + ann)^20 ≈ 1 + cum
  expect_equal((1 + ann)^20, 1 + cum, tolerance = 1e-10)
})

test_that("inflation_rate same year returns 0", {
  expect_equal(inflation_rate(2010, 2010, "GBP"), 0)
  expect_equal(inflation_rate(2010, 2010, "GBP", annualise = TRUE), 0)
})

test_that("inflation_rate works for all currencies", {
  currencies <- c("GBP", "AUD", "USD", "EUR", "CAD", "JPY", "CNY", "CHF",
                  "NZD", "INR", "KRW", "BRL", "NOK")
  for (cur in currencies) {
    result <- inflation_rate(2000, 2020, cur)
    expect_type(result, "double")
    expect_true(is.finite(result))
  }
})

test_that("inflation_rate accepts country names", {
  r1 <- inflation_rate(2000, 2020, "GBP")
  r2 <- inflation_rate(2000, 2020, "britain")
  expect_equal(r1, r2)
})

test_that("inflation_rate errors on invalid inputs", {
  expect_error(inflation_rate(2000, 2020, "ZZZ"), "currency must be one of")
  expect_error(inflation_rate(1800, 2020, "GBP"), "from_year must be between")
  expect_error(inflation_rate(2000, 3000, "GBP"), "to_year must be between")
})

test_that("inflation_rate can show deflation", {
  # Japan had near-zero/negative inflation — check a deflationary period
  result <- inflation_rate(1998, 2010, "JPY")
  expect_type(result, "double")
  # Just verify it's a small number (could be negative)
  expect_true(abs(result) < 0.5)
})
