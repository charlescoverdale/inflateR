# Fetch official CPI data from the World Bank WDI API and save as bundled .rda files
#
# Indicator: FP.CPI.TOTL — Consumer Price Index (World Bank, base 2010 = 100)
# Source: World Bank Open Data — https://data.worldbank.org/indicator/FP.CPI.TOTL
#
# Run this script to refresh the bundled data:
#   Rscript data-raw/cpi_data.R
#
# Requires the WDI package: install.packages("WDI")

library(WDI)

# Country codes
# Note: Euro area aggregate (XC) has no CPI data in WDI.
# Germany (DE) is used as the EUR proxy — it is the largest Eurozone economy
# and was the monetary anchor (Deutsche Mark) prior to the Euro.
country_codes <- c(
  GB = "GBP",
  AU = "AUD",
  US = "USD",
  DE = "EUR",
  CA = "CAD",
  JP = "JPY",
  CN = "CNY"
)

message("Fetching CPI data from World Bank WDI...")

raw <- WDI(
  country   = names(country_codes),
  indicator = "FP.CPI.TOTL",
  start     = 1960,
  end       = 2024
)

# Rename columns for clarity
names(raw)[names(raw) == "FP.CPI.TOTL"] <- "index_2010"
names(raw)[names(raw) == "iso2c"]        <- "iso2c"

# Helper: process one country into a clean data frame rescaled to 2020 = 100
process_country <- function(iso, currency) {
  df <- raw[raw$iso2c == iso, c("year", "index_2010")]
  df <- df[!is.na(df$index_2010), ]
  df <- df[order(df$year), ]

  # Rescale: 2020 = 100
  base_2020 <- df$index_2010[df$year == 2020]
  if (length(base_2020) == 0 || is.na(base_2020)) {
    stop(paste("No 2020 data available for", currency))
  }
  df$index <- round((df$index_2010 / base_2020) * 100, 2)
  df$index_2010 <- NULL

  message(sprintf("  %s (%s): %d years of data (%d - %d)",
                  currency, iso, nrow(df), min(df$year), max(df$year)))
  df
}

# Process each currency
uk_cpi  <- process_country("GB", "GBP")
aud_cpi <- process_country("AU", "AUD")
usd_cpi <- process_country("US", "USD")
eur_cpi <- process_country("DE", "EUR")
cad_cpi <- process_country("CA", "CAD")
jpy_cpi <- process_country("JP", "JPY")
cny_cpi <- process_country("CN", "CNY")

# Save
save(uk_cpi,  file = "data/uk_cpi.rda")
save(aud_cpi, file = "data/aud_cpi.rda")
save(usd_cpi, file = "data/usd_cpi.rda")
save(eur_cpi, file = "data/eur_cpi.rda")
save(cad_cpi, file = "data/cad_cpi.rda")
save(jpy_cpi, file = "data/jpy_cpi.rda")
save(cny_cpi, file = "data/cny_cpi.rda")

message("Done. CPI data saved to data/")
