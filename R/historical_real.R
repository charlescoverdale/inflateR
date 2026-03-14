#' Convert a value to its historical equivalent using a GDP deflator
#'
#' Takes a monetary amount from a recent year and returns what it would have
#' been worth in a specified historical year, using GDP deflator data sourced
#' from the World Bank Development Indicators (indicator: NY.GDP.DEFL.ZS).
#' This is the inverse of \code{\link{adjust_real}}.
#'
#' For converting consumer or personal values, use
#' \code{\link{historical_value}} which uses CPI instead.
#'
#' @param amount Numeric (scalar or vector). The monetary amount(s) in the
#'   reference year.
#' @param to_year Integer. The historical year to convert back to.
#' @param currency Character. Currency code (`"GBP"`, `"AUD"`, `"USD"`,
#'   `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"`, `"CHF"`, `"NZD"`, `"INR"`, `"KRW"`,
#'   `"BRL"`, `"NOK"`) or country name
#'   (`"Australia"`, `"United States"`, etc.) — case-insensitive.
#' @param from_year Integer. The year the amount is from. Defaults to the
#'   latest year available in the deflator series.
#' @param round Integer or `NULL`. Number of decimal places to round to
#'   (default 2). Use `NULL` for full precision.
#'
#' @return A numeric value (or vector) representing the historical equivalent
#'   amount.
#'
#' @examples
#' # What would UK GDP of £2 trillion today have been in 1990 terms?
#' historical_real(2e12, 1990, "GBP")
#'
#' # What would USD 1 trillion in 2020 have been worth in 2000?
#' historical_real(1e12, 2000, "USD", from_year = 2020)
#'
#' @family GDP deflator adjustment
#' @export
historical_real <- function(amount, to_year, currency, from_year = NULL,
                            round = 2) {
  currency <- resolve_currency(currency)
  index_data <- get_index_data(currency, "deflator")
  from_year <- resolve_default_year(from_year, index_data)
  adjusted <- compute_adjustment(amount, index_data, from_year, to_year,
                                 currency)
  apply_round(adjusted, round)
}
