# inflateR 0.2.0

* Added `inflation_rate()` for calculating cumulative or annualised inflation rates between any two years
* Added `list_currencies()` to show all supported currencies and their data coverage
* Added `round` parameter to all four adjustment functions (`round = 2` default preserves backward compatibility; use `round = NULL` for full precision)
* All adjustment functions now accept vector `amount` inputs
* Refactored internal code: extracted shared helpers to eliminate 4x code duplication across functions
* Added comprehensive test suite (80+ tests covering all functions, all 13 currencies, error handling, inverse properties, and vectorisation)
* Updated `data-raw/cpi_data.R` to cover all 13 currencies and both CPI and GDP deflator series in a single script

# inflateR 0.1.3

* Added 5 new currencies: NZD (New Zealand), INR (India), KRW (South Korea), BRL (Brazil), NOK (Norway)
* Bundled CPI and GDP deflator data for all new currencies (World Bank series)
* BRL CPI coverage begins 1980; all other new series cover 1960–2024

# inflateR 0.1.2

* Added `adjust_real()` for GDP deflator-based adjustment (World Bank NY.GDP.DEFL.ZS)
* Bundled GDP deflator data (1960–2024) for all 8 supported currencies
* `adjust_real()` accepts the same currency codes and country names as `adjust_inflation()`

# inflateR 0.1.0

* Initial release
* Supports inflation adjustment for GBP, AUD, USD, EUR, CAD, JPY, CNY, and CHF
* Bundled CPI data from 1960–2024 for all currencies (CNY from 1986)
* Currency codes and country names both accepted as input (case-insensitive)
* Data sourced from the World Bank Development Indicators (FP.CPI.TOTL), rescaled to 2020 = 100
