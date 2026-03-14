#' Adjust a monetary value using a GDP deflator
#'
#' Converts an amount between two years using GDP deflator data sourced from
#' the World Bank Development Indicators (indicator: NY.GDP.DEFL.ZS). Suitable
#' for adjusting GDP figures, government expenditure, and other macroeconomic
#' aggregates. For adjusting personal or consumer values (wages, prices of goods),
#' use \code{\link{adjust_inflation}} which uses CPI instead.
#'
#' @param amount Numeric (scalar or vector). The original monetary amount(s).
#' @param from_year Integer. The year the amount is from.
#' @param currency Character. A currency code or country name. Accepted codes:
#'   `"GBP"`, `"AUD"`, `"USD"`, `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"`, `"CHF"`,
#'   `"NZD"`, `"INR"`, `"KRW"`, `"BRL"`, `"NOK"`.
#'   Country names are also accepted, e.g. `"Australia"`, `"United States"`,
#'   `"Japan"`, `"Switzerland"` (case-insensitive).
#' @param to_year Integer. The target year to adjust to. Defaults to the
#'   latest available year in the deflator series.
#' @param round Integer or `NULL`. Number of decimal places to round to
#'   (default 2). Use `NULL` for full precision.
#'
#' @return A numeric value (or vector) representing the deflator-adjusted amount.
#'
#' @details
#' The GDP deflator measures price changes across all goods and services
#' produced in an economy, unlike CPI which tracks a fixed consumer basket.
#' Key differences from CPI:
#' \itemize{
#'   \item Covers all domestic production, not just consumer goods
#'   \item Excludes imported goods (CPI includes them)
#'   \item Updates its basket automatically (CPI uses a fixed basket)
#'   \item Published annually/quarterly (CPI is monthly)
#' }
#' Use the GDP deflator when comparing macroeconomic aggregates (GDP, government
#' spending, investment) across time. Use \code{\link{adjust_inflation}} for
#' personal or consumer values.
#'
#' @examples
#' # Adjust UK GDP from 1990 to today using GDP deflator
#' adjust_real(500000, 1990, "GBP")
#'
#' # Compare US government spending in 2000 vs 2020 terms
#' adjust_real(1000000, 2000, "USD", to_year = 2020)
#'
#' @family GDP deflator adjustment
#' @export
adjust_real <- function(amount, from_year, currency, to_year = NULL,
                        round = 2) {
  currency <- resolve_currency(currency)
  index_data <- get_index_data(currency, "deflator")
  to_year <- resolve_default_year(to_year, index_data)
  adjusted <- compute_adjustment(amount, index_data, from_year, to_year,
                                 currency)
  apply_round(adjusted, round)
}
