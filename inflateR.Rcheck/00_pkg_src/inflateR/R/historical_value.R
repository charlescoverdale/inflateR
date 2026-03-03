#' Convert a present-day value to its historical equivalent
#'
#' Takes a monetary amount from a recent year and returns what it would have
#' been worth in a specified historical year, using bundled CPI data sourced
#' from the World Bank Development Indicators. Supports GBP, AUD, USD, EUR,
#' CAD, JPY, CNY, and CHF.
#'
#' @param amount Numeric. The monetary amount in the reference year.
#' @param to_year Integer. The historical year to convert back to.
#' @param currency Character. Currency code (`"GBP"`, `"AUD"`, `"USD"`,
#'   `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"`, `"CHF"`) or country name
#'   (`"Australia"`, `"United States"`, etc.) — case-insensitive.
#' @param from_year Integer. The year the amount is from. Defaults to the
#'   latest year available in the data.
#'
#' @return A numeric value representing the historical equivalent amount.
#'
#' @examples
#' # What would £100 today have been worth in 1963?
#' historical_value(100, 1963, "GBP")
#'
#' # What would USD 500 in 2020 have been worth in 1980?
#' historical_value(500, 1980, "USD", from_year = 2020)
#'
#' @export
historical_value <- function(amount, to_year, currency, from_year = NULL) {

  # Map country names to currency codes (case-insensitive)
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

  cpi_data <- switch(currency,
    GBP = uk_cpi,
    AUD = aud_cpi,
    USD = usd_cpi,
    EUR = eur_cpi,
    CAD = cad_cpi,
    JPY = jpy_cpi,
    CNY = cny_cpi,
    CHF = chf_cpi
  )

  min_year <- min(cpi_data$year)
  max_year <- max(cpi_data$year)

  if (is.null(from_year)) {
    from_year <- min(as.integer(format(Sys.Date(), "%Y")), max_year)
  }

  if (!from_year %in% cpi_data$year) {
    stop(paste0("from_year must be between ", min_year, " and ", max_year,
                " for ", currency))
  }

  if (!to_year %in% cpi_data$year) {
    stop(paste0("to_year must be between ", min_year, " and ", max_year,
                " for ", currency))
  }

  index_from <- cpi_data$index[cpi_data$year == from_year]
  index_to   <- cpi_data$index[cpi_data$year == to_year]

  adjusted <- amount * (index_to / index_from)

  round(adjusted, 2)
}
