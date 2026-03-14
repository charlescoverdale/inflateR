#' Adjust a historical monetary value for inflation
#'
#' Converts an amount from a historical year into its equivalent value in a
#' target year, using bundled CPI data sourced from the World Bank Development
#' Indicators. Supports GBP, AUD, USD, EUR, CAD, JPY, CNY, CHF, NZD, INR,
#' KRW, BRL, and NOK.
#'
#' @param amount Numeric (scalar or vector). The original monetary amount(s).
#' @param from_year Integer. The year the amount is from.
#' @param currency Character. A currency code or country name. Accepted codes:
#'   `"GBP"`, `"AUD"`, `"USD"`, `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"`, `"CHF"`,
#'   `"NZD"`, `"INR"`, `"KRW"`, `"BRL"`, `"NOK"`.
#'   Country names are also accepted, e.g. `"Australia"`, `"United States"`,
#'   `"Japan"`, `"New Zealand"`, `"India"`, `"Norway"` (case-insensitive).
#' @param to_year Integer. The target year to adjust to. Defaults to the
#'   latest available year in the data.
#' @param round Integer or `NULL`. Number of decimal places to round to
#'   (default 2). Use `NULL` for full precision.
#'
#' @return A numeric value (or vector) representing the inflation-adjusted amount.
#'
#' @examples
#' # What is £12 from 1963 worth today?
#' adjust_inflation(12, 1963, "GBP")
#'
#' # What is AUD 50 from 1980 worth in 2000?
#' adjust_inflation(50, 1980, "AUD", to_year = 2000)
#'
#' # Full precision
#' adjust_inflation(100, 2000, "USD", to_year = 2020, round = NULL)
#'
#' @family CPI adjustment
#' @export
adjust_inflation <- function(amount, from_year, currency, to_year = NULL,
                             round = 2) {
  currency <- resolve_currency(currency)
  index_data <- get_index_data(currency, "cpi")
  to_year <- resolve_default_year(to_year, index_data)
  adjusted <- compute_adjustment(amount, index_data, from_year, to_year,
                                 currency)
  apply_round(adjusted, round)
}
