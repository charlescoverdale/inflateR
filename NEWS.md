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
