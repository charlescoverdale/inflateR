# Fetch official CPI and GDP deflator data from the World Bank WDI API
# and save as bundled .rda files
#
# CPI indicator: FP.CPI.TOTL — Consumer Price Index (World Bank, base 2010 = 100)
# GDP deflator indicator: NY.GDP.DEFL.ZS — GDP Deflator (World Bank, base 2015 = 100)
#
# Source: World Bank Open Data
#   https://data.worldbank.org/indicator/FP.CPI.TOTL
#   https://data.worldbank.org/indicator/NY.GDP.DEFL.ZS
#
# Run this script to refresh the bundled data:
#   Rscript data-raw/cpi_data.R
#
# Requires the WDI package: install.packages("WDI")

library(WDI)

# Fetch through the current year. The WDI API returns NA for years a country
# has not yet reported, and process_country() drops those, so asking for more
# than exists is harmless and means this script does not need editing each
# time the World Bank publishes.
end_year <- as.integer(format(Sys.Date(), "%Y"))

# Country codes
# Note: Euro area aggregate (XC) has no CPI data in WDI.
# Germany (DE) is used as the EUR proxy — it is the largest Eurozone economy
# and was the monetary anchor (Deutsche Mark) prior to the Euro.
country_map <- data.frame(
  iso2c    = c("GB", "AU", "US", "DE", "CA", "JP", "CN", "CH",
               "NZ", "IN", "KR", "BR", "NO"),
  currency = c("GBP", "AUD", "USD", "EUR", "CAD", "JPY", "CNY", "CHF",
               "NZD", "INR", "KRW", "BRL", "NOK"),
  prefix   = c("uk", "aud", "usd", "eur", "cad", "jpy", "cny", "chf",
               "nzd", "inr", "krw", "brl", "nok"),
  stringsAsFactors = FALSE
)

# ---- CPI data ---------------------------------------------------------------
message("Fetching CPI data from World Bank WDI...")

raw_cpi <- WDI(
  country   = country_map$iso2c,
  indicator = "FP.CPI.TOTL",
  start     = 1960,
  end       = end_year
)

names(raw_cpi)[names(raw_cpi) == "FP.CPI.TOTL"] <- "index_2010"

process_country <- function(raw, iso, currency, col = "index_2010") {
  df <- raw[raw$iso2c == iso, c("year", col)]
  names(df)[2] <- "index_raw"
  df <- df[!is.na(df$index_raw), ]
  df <- df[order(df$year), ]

  base_2020 <- df$index_raw[df$year == 2020]
  if (length(base_2020) == 0 || is.na(base_2020)) {
    stop(paste("No 2020 data available for", currency))
  }
  # Four decimal places, not two. Rebasing to 2020 = 100 pushes the early
  # years of a hyperinflation series close to zero: the smallest value in
  # the bundled data is BRL at 0.0003, which two decimals would flatten to
  # zero and turn into a divide-by-zero downstream. Output rounding is a
  # separate concern, handled by the `round` argument on the adjustment
  # functions.
  df$index <- round((df$index_raw / base_2020) * 100, 4)
  df$index_raw <- NULL

  # Drop years whose rebased index rounds to zero. Brazil's pre-1990 series
  # sits so far below the 2020 base after hyperinflation that four decimals
  # cannot represent it, and a zero index is worse than a missing one: it
  # divides, so adjust_inflation() returned Inf for those years rather than
  # refusing them. Dropping the rows lets the ordinary coverage check reject
  # the request with a message naming the real range.
  dropped <- sum(df$index == 0)
  if (dropped > 0) {
    message(sprintf("    dropping %d year(s) whose rebased index rounds to zero (%s)",
                    dropped, paste(range(df$year[df$index == 0]), collapse = "-")))
    df <- df[df$index > 0, ]
  }

  message(sprintf("  %s (%s): %d years (%d - %d)",
                  currency, iso, nrow(df), min(df$year), max(df$year)))
  df
}

# The World Bank has no 2025 US CPI: BLS collected no October 2025 prices
# during the lapse in appropriations, and the WDI series has not been
# extended. BLS did publish the 2025 annual average of CPI-U (from the
# eleven months collected), and the WDI US series is the CPI-U annual
# average, so missing complete years are chained on from BLS. Each
# appended year carries the BLS year-on-year change, so the WDI history is
# untouched.
extend_usd_from_bls <- function(df) {
  last_complete <- as.integer(format(Sys.Date(), "%Y")) - 1L
  if (max(df$year) >= last_complete) return(df)
  body <- jsonlite::toJSON(list(
    # An array, even for one series: BLS answers a scalar with HTTP 503.
    seriesid = list("CUUR0000SA0"),
    startyear = as.character(max(df$year)),
    endyear = as.character(last_complete),
    annualaverage = TRUE
  ), auto_unbox = TRUE)
  resp <- httr2::request("https://api.bls.gov/publicAPI/v1/timeseries/data/") |>
    httr2::req_user_agent("inflateR data-raw (https://github.com/charlescoverdale/inflateR)") |>
    httr2::req_body_raw(body, type = "application/json") |>
    httr2::req_perform()
  obs <- httr2::resp_body_json(resp)$Results$series[[1]]$data
  ann <- Filter(function(o) o$period == "M13", obs)
  avg <- stats::setNames(vapply(ann, function(o) as.numeric(o$value), numeric(1)),
                         vapply(ann, function(o) o$year, character(1)))
  for (yr in seq.int(max(df$year) + 1L, last_complete)) {
    prev <- as.character(yr - 1L)
    cur <- as.character(yr)
    if (!all(c(prev, cur) %in% names(avg))) break
    df <- rbind(df, data.frame(
      year = yr,
      index = round(df$index[df$year == yr - 1L] * avg[[cur]] / avg[[prev]], 4)
    ))
    message(sprintf("  USD: %d chained from BLS CPI-U annual average (%.3f / %.3f)",
                    yr, avg[[cur]], avg[[prev]]))
  }
  rownames(df) <- NULL
  df
}

for (i in seq_len(nrow(country_map))) {
  obj_name <- paste0(country_map$prefix[i], "_cpi")
  df <- process_country(raw_cpi, country_map$iso2c[i], country_map$currency[i])
  if (country_map$currency[i] == "USD") df <- extend_usd_from_bls(df)
  assign(obj_name, df)
  save(list = obj_name, file = paste0("data/", obj_name, ".rda"))
}

# ---- GDP deflator data -------------------------------------------------------
message("\nFetching GDP deflator data from World Bank WDI...")

raw_def <- WDI(
  country   = country_map$iso2c,
  indicator = "NY.GDP.DEFL.ZS",
  start     = 1960,
  end       = end_year
)

names(raw_def)[names(raw_def) == "NY.GDP.DEFL.ZS"] <- "index_2015"

for (i in seq_len(nrow(country_map))) {
  obj_name <- paste0(country_map$prefix[i], "_gdp_def")
  df <- process_country(raw_def, country_map$iso2c[i], country_map$currency[i],
                        col = "index_2015")
  assign(obj_name, df)
  save(list = obj_name, file = paste0("data/", obj_name, ".rda"))
}

message("\nDone. CPI and GDP deflator data saved to data/")
