#' Adjust a historical monetary value for inflation
#'
#' Converts an amount from a historical year into its equivalent value in a
#' target year, using bundled CPI data sourced from the World Bank Development
#' Indicators. Supports GBP, AUD, USD, EUR, CAD, JPY, CNY, and CHF.
#'
#' @param amount Numeric. The original monetary amount.
#' @param from_year Integer. The year the amount is from.
#' @param currency Character. A currency code or country name. Accepted codes:
#'   `"GBP"`, `"AUD"`, `"USD"`, `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"`, `"CHF"`.
#'   Country names are also accepted, e.g. `"Australia"`, `"United States"`,
#'   `"Japan"`, `"Switzerland"` (case-insensitive).
#' @param to_year Integer. The target year to adjust to. Defaults to the
#'   current year.
#'
#' @return A numeric value representing the inflation-adjusted amount.
#'
#' @examples
#' # What is £12 from 1963 worth today?
#' adjust_inflation(12, 1963, "GBP")
#'
#' # What is AUD 50 from 1980 worth in 2000?
#' adjust_inflation(50, 1980, "AUD", to_year = 2000)
#'
#' @export
adjust_inflation <- function(amount, from_year, currency, to_year = NULL) {

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

  if (is.null(to_year)) {
    to_year <- min(as.integer(format(Sys.Date(), "%Y")), max_year)
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
