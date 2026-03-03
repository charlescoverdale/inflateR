#' Adjust a monetary value using a GDP deflator
#'
#' Converts an amount between two years using GDP deflator data sourced from
#' the World Bank Development Indicators (indicator: NY.GDP.DEFL.ZS). Suitable
#' for adjusting GDP figures, government expenditure, and other macroeconomic
#' aggregates. For adjusting personal or consumer values (wages, prices of goods),
#' use \code{\link{adjust_inflation}} which uses CPI instead.
#'
#' @param amount Numeric. The original monetary amount.
#' @param from_year Integer. The year the amount is from.
#' @param currency Character. A currency code or country name. Accepted codes:
#'   `"GBP"`, `"AUD"`, `"USD"`, `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"`, `"CHF"`.
#'   Country names are also accepted, e.g. `"Australia"`, `"United States"`,
#'   `"Japan"`, `"Switzerland"` (case-insensitive).
#' @param to_year Integer. The target year to adjust to. Defaults to the
#'   latest available year in the deflator series.
#'
#' @return A numeric value representing the deflator-adjusted amount.
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
#' @export
adjust_real <- function(amount, from_year, currency, to_year = NULL) {

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
    "switzerland"    = "CHF", "swiss"       = "CHF",
    "new zealand"    = "NZD", "nz"          = "NZD",
    "india"          = "INR",
    "south korea"    = "KRW", "korea"       = "KRW",
    "brazil"         = "BRL",
    "norway"         = "NOK", "norwegian"   = "NOK"
  )

  lookup <- country_lookup[tolower(trimws(currency))]
  if (!is.na(lookup)) currency <- lookup

  currency <- toupper(currency)

  valid <- c("GBP", "AUD", "USD", "EUR", "CAD", "JPY", "CNY", "CHF",
             "NZD", "INR", "KRW", "BRL", "NOK")
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
    CHF = chf_gdp_def,
    NZD = nzd_gdp_def,
    INR = inr_gdp_def,
    KRW = krw_gdp_def,
    BRL = brl_gdp_def,
    NOK = nok_gdp_def
  )

  min_year <- min(deflator_data$year)
  max_year <- max(deflator_data$year)

  if (is.null(to_year)) {
    to_year <- min(as.integer(format(Sys.Date(), "%Y")), max_year)
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
