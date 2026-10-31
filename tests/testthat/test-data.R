
test_that("every CPI series reaches the same latest year", {
  latest <- vapply(
    c("uk_cpi", "aud_cpi", "usd_cpi", "eur_cpi", "cad_cpi", "jpy_cpi",
      "cny_cpi", "chf_cpi", "nzd_cpi", "inr_cpi", "krw_cpi", "brl_cpi",
      "nok_cpi"),
    function(nm) max(get(nm, envir = asNamespace("inflateR"))$year),
    numeric(1)
  )
  expect_equal(unname(latest), rep(max(latest), length(latest)))
})

test_that("USD 2025 follows the BLS CPI-U annual change", {
  d <- usd_cpi
  ratio <- d$index[d$year == 2025] / d$index[d$year == 2024]
  expect_equal(ratio, 321.943 / 313.689, tolerance = 1e-5)
})
