# Internal helpers — not exported

# Country name → currency code mapping (case-insensitive)
.country_lookup <- c(
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

.valid_currencies <- c("GBP", "AUD", "USD", "EUR", "CAD", "JPY", "CNY", "CHF",
                        "NZD", "INR", "KRW", "BRL", "NOK")

#' Resolve a currency code or country name to an ISO currency code
#' @param currency Character. Currency code or country name.
#' @return Character. Uppercase currency code.
#' @noRd
resolve_currency <- function(currency) {
  lookup <- .country_lookup[tolower(trimws(currency))]
  if (!is.na(lookup)) currency <- lookup
  currency <- toupper(currency)

  if (!currency %in% .valid_currencies) {
    stop(paste0("currency must be one of: ", paste(.valid_currencies, collapse = ", "),
                "\nOr use a country name e.g. \"Australia\", \"United States\"."))
  }
  currency
}

#' Get index data for a currency
#' @param currency Character. An uppercase ISO currency code (already resolved).
#' @param type Character. One of "cpi" or "deflator".
#' @return A data frame with columns `year` and `index`.
#' @noRd
get_index_data <- function(currency, type = c("cpi", "deflator")) {
  type <- match.arg(type)
  if (type == "cpi") {
    switch(currency,
      GBP = uk_cpi,
      AUD = aud_cpi,
      USD = usd_cpi,
      EUR = eur_cpi,
      CAD = cad_cpi,
      JPY = jpy_cpi,
      CNY = cny_cpi,
      CHF = chf_cpi,
      NZD = nzd_cpi,
      INR = inr_cpi,
      KRW = krw_cpi,
      BRL = brl_cpi,
      NOK = nok_cpi
    )
  } else {
    switch(currency,
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
  }
}

#' Compute inflation/deflator adjustment
#' @param amount Numeric (scalar or vector). The monetary amount(s).
#' @param index_data Data frame with `year` and `index` columns.
#' @param from_year Integer. Source year.
#' @param to_year Integer. Target year.
#' @param currency Character. For error messages only.
#' @return Numeric. Adjusted amount(s), unrounded.
#' @noRd
compute_adjustment <- function(amount, index_data, from_year, to_year, currency) {
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

  amount * (index_to / index_from)
}

#' Resolve the default year (current year or max available)
#' @param year Integer or NULL. The user-supplied year.
#' @param index_data Data frame with `year` column.
#' @return Integer. The resolved year.
#' @noRd
resolve_default_year <- function(year, index_data) {
  if (is.null(year)) {
    min(as.integer(format(Sys.Date(), "%Y")), max(index_data$year))
  } else {
    year
  }
}

#' Apply rounding
#' @param x Numeric.
#' @param round Integer or NULL. Number of decimal places, or NULL for no rounding.
#' @return Numeric.
#' @noRd
apply_round <- function(x, round) {
  if (!is.null(round)) round(x, round) else x
}
