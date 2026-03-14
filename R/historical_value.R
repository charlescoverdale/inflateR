#' Convert a present-day value to its historical equivalent
#'
#' Takes a monetary amount from a recent year and returns what it would have
#' been worth in a specified historical year, using bundled CPI data sourced
#' from the World Bank Development Indicators. Supports GBP, AUD, USD, EUR,
#' CAD, JPY, CNY, CHF, NZD, INR, KRW, BRL, and NOK.
#'
#' @param amount Numeric (scalar or vector). The monetary amount(s) in the
#'   reference year.
#' @param to_year Integer. The historical year to convert back to.
#' @param currency Character. Currency code (`"GBP"`, `"AUD"`, `"USD"`,
#'   `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"`, `"CHF"`, `"NZD"`, `"INR"`, `"KRW"`,
#'   `"BRL"`, `"NOK"`) or country name
#'   (`"Australia"`, `"United States"`, etc.) — case-insensitive.
#' @param from_year Integer. The year the amount is from. Defaults to the
#'   latest year available in the data.
#' @param round Integer or `NULL`. Number of decimal places to round to
#'   (default 2). Use `NULL` for full precision.
#'
#' @return A numeric value (or vector) representing the historical equivalent
#'   amount.
#'
#' @examples
#' # What would £100 today have been worth in 1963?
#' historical_value(100, 1963, "GBP")
#'
#' # What would USD 500 in 2020 have been worth in 1980?
#' historical_value(500, 1980, "USD", from_year = 2020)
#'
#' @family CPI adjustment
#' @export
historical_value <- function(amount, to_year, currency, from_year = NULL,
                             round = 2) {
  currency <- resolve_currency(currency)
  index_data <- get_index_data(currency, "cpi")
  from_year <- resolve_default_year(from_year, index_data)
  adjusted <- compute_adjustment(amount, index_data, from_year, to_year,
                                 currency)
  apply_round(adjusted, round)
}
