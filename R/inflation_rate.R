#' Calculate the inflation rate between two years
#'
#' Returns the cumulative or annualised inflation rate between two years,
#' using bundled CPI data sourced from the World Bank Development Indicators.
#'
#' @param from_year Integer. The starting year.
#' @param to_year Integer. The ending year. Defaults to the latest available
#'   year in the data.
#' @param currency Character. A currency code or country name (case-insensitive).
#'   See \code{\link{adjust_inflation}} for accepted values.
#' @param annualise Logical. If `TRUE`, returns the annualised (compound annual)
#'   rate. If `FALSE` (default), returns the cumulative rate.
#'
#' @return A numeric value representing the inflation rate as a proportion
#'   (e.g. 0.35 means 35\%). Negative values indicate deflation.
#'
#' @examples
#' # Cumulative US inflation from 2000 to 2020
#' inflation_rate(2000, 2020, "USD")
#'
#' # Annualised UK inflation from 1990 to 2020
#' inflation_rate(1990, 2020, "GBP", annualise = TRUE)
#'
#' @export
inflation_rate <- function(from_year, to_year = NULL, currency,
                           annualise = FALSE) {
  currency <- resolve_currency(currency)
  index_data <- get_index_data(currency, "cpi")
  to_year <- resolve_default_year(to_year, index_data)

  min_year <- min(index_data$year)
  max_year <- max(index_data$year)

  if (!from_year %in% index_data$year) {
    stop(paste0("from_year must be between ", min_year, " and ", max_year,
                " for ", currency))
  }

  if (!to_year %in% index_data$year) {
    stop(paste0("to_year must be between ", min_year, " and ", max_year,
                " for ", currency))
  }

  index_from <- index_data$index[index_data$year == from_year]
  index_to   <- index_data$index[index_data$year == to_year]
  ratio <- index_to / index_from

  if (annualise) {
    n <- to_year - from_year
    if (n == 0) return(0)
    ratio^(1 / n) - 1
  } else {
    ratio - 1
  }
}
