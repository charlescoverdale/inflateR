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
#' @param amount Numeric. The monetary amount in the reference year.
#' @param to_year Integer. The historical year to convert back to.
#' @param currency Character. Currency code (`"GBP"`, `"AUD"`, `"USD"`,
#'   `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"`, `"CHF"`) or country name
#'   (`"Australia"`, `"United States"`, etc.) — case-insensitive.
#' @param from_year Integer. The year the amount is from. Defaults to the
#'   latest year available in the deflator series.
#'
#' @return A numeric value representing the historical equivalent amount.
#'
#' @examples
#' # What would UK GDP of £2 trillion today have been in 1990 terms?
#' historical_real(2e12, 1990, "GBP")
#'
#' # What would USD 1 trillion in 2020 have been worth in 2000?
#' historical_real(1e12, 2000, "USD", from_year = 2020)
#'
#' @export
historical_real <- function(amount, to_year, currency, from_year = NULL) {

  country_lookup <- c(
    "united kingdom" = "GBP", "uk"          = "GBP", "britain"      = "GBP",
    "great britain"  = "GBP", "england"     = "GBP",
    "australia"      = "AUD",
    "united states"  = "USD", "usa"         = "USD", "us"           = "USD",
    "america"        = "USD",
    "europe"         = "EUR", "euro area"   = "EUR", "eurozone"     = "EUR",
    "germany"        = "EUR",
    "canada"         = "CAD",
    "japan"          = "JPY",
    "china"          = "CNY",
    "switzerland"    = "CHF", "swiss"       = "CHF"
  )

  lookup <- country_lookup[tolower(trimws(currency))]
  if (!is.na(lookup)) currency <- lookup

  currency <- toupper(currency)

  valid <- c("GBP", "AUD", "USD", "EUR", "CAD", "JPY", "CNY", "CHF")
  if (!currency %in% valid) {
    stop(paste0("currency must be one of: ", paste(valid, collapse = ", "),
                "\nOr use a country name e.g. \"Australia\", \"United States\"."))
  }

  deflator_data <- switch(currency,
    GBP = uk_gdp_def,
    AUD = aud_gdp_def,
    USD = usd_gdp_def,
    EUR = eur_gdp_def,
    CAD = cad_gdp_def,
    JPY = jpy_gdp_def,
    CNY = cny_gdp_def,
    CHF = chf_gdp_def
  )

  min_year <- min(deflator_data$year)
  max_year <- max(deflator_data$year)

  if (is.null(from_year)) {
    from_year <- min(as.integer(format(Sys.Date(), "%Y")), max_year)
  }

  if (!from_year %in% deflator_data$year) {
    stop(paste0("from_year must be between ", min_year, " and ", max_year,
                " for ", currency))
  }

  if (!to_year %in% deflator_data$year) {
    stop(paste0("to_year must be between ", min_year, " and ", max_year,
                " for ", currency))
  }

  index_from <- deflator_data$index[deflator_data$year == from_year]
  index_to   <- deflator_data$index[deflator_data$year == to_year]

  adjusted <- amount * (index_to / index_from)

  round(adjusted, 2)
}
