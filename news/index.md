# Changelog

## inflateR 0.2.0

### Bundled data now runs to 2025

Refreshed from the World Bank Development Indicators. Every series gains
2025 except US CPI, which the World Bank has not yet published beyond
2024. The US GDP deflator does reach 2025.

**Results will change.** Two separate reasons:

- Any call that does not name a `to_year` defaults to the latest year
  available, which has moved from 2024 to 2025. For example
  `adjust_inflation(12, 1963, "Australia")` returned 212.02 and now
  returns 218.09. Pass an explicit `to_year` if you need the old answer.
- The World Bank revised history for several GDP deflator series. The
  largest is CHF, where 42 years move by a median of 2.4% and up to
  13.8%. USD moves by about 1.4% across 60 years, and JPY, NOK, NZD and
  INR move by smaller amounts. CPI series are essentially unrevised.

### Brazil now starts at 1990, not 1980

Rebasing to 2020 = 100 pushes Brazil’s hyperinflation years so far below
the base that four decimal places cannot represent them, and they were
being stored as exactly zero. A zero index divides, so
`adjust_inflation(100, 1985, 2020, currency = "BRL")` returned `Inf`
rather than refusing the request. Those years are now dropped, so the
ordinary coverage check rejects them with a message naming the real
range. 40 stored values were affected across `brl_cpi` and
`brl_gdp_def`.

### Fixes to data-raw/cpi_data.R

- The script rounded the rebased index to 2 decimal places, but the
  shipped data carries 4: 1078 of 1644 values had more precision than
  re-running the script would have produced. Anyone refreshing the data
  would have silently degraded it, and flattened Brazil’s early years to
  zero. Now rounds to 4.
- The end year was hardcoded to 2024 in two places. It now derives from
  the system date, so the script does not need editing at each World
  Bank release.

### Test fixes surfaced by the refresh

- Three “known value” tests hardcoded index constants (5.71, 66.53,
  69.9844) and so failed the moment the World Bank revised history. They
  now read the index from the bundled data, which tests the arithmetic
  without turning every refresh into a failure that says nothing about
  the code.

- Three vectorisation tests asserted `result[2] == result[1] * 2` on
  rounded output. With per-element rounding `round(2x, 2)` need not
  equal `2 * round(x, 2)`, so the assertion was unsound and happened to
  hold only for the old data. They now pass `round = NULL`; the `round`
  argument keeps its own separate tests.

### New functionality

- Added
  [`inflation_rate()`](https://charlescoverdale.github.io/inflateR/reference/inflation_rate.md)
  for calculating cumulative or annualised inflation rates between any
  two years
- Added
  [`list_currencies()`](https://charlescoverdale.github.io/inflateR/reference/list_currencies.md)
  to show all supported currencies and their data coverage
- Added `round` parameter to all four adjustment functions (`round = 2`
  default preserves backward compatibility; use `round = NULL` for full
  precision)
- All adjustment functions now accept vector `amount` inputs
- Refactored internal code: extracted shared helpers to eliminate 4x
  code duplication across functions
- Added comprehensive test suite (80+ tests covering all functions, all
  13 currencies, error handling, inverse properties, and vectorisation)
- Updated `data-raw/cpi_data.R` to cover all 13 currencies and both CPI
  and GDP deflator series in a single script

## inflateR 0.1.3

CRAN release: 2026-03-04

- Added 5 new currencies: NZD (New Zealand), INR (India), KRW (South
  Korea), BRL (Brazil), NOK (Norway)
- Bundled CPI and GDP deflator data for all new currencies (World Bank
  series)
- BRL CPI coverage begins 1980; all other new series cover 1960–2024

## inflateR 0.1.2

- Added
  [`adjust_real()`](https://charlescoverdale.github.io/inflateR/reference/adjust_real.md)
  for GDP deflator-based adjustment (World Bank NY.GDP.DEFL.ZS)
- Bundled GDP deflator data (1960–2024) for all 8 supported currencies
- [`adjust_real()`](https://charlescoverdale.github.io/inflateR/reference/adjust_real.md)
  accepts the same currency codes and country names as
  [`adjust_inflation()`](https://charlescoverdale.github.io/inflateR/reference/adjust_inflation.md)

## inflateR 0.1.0

- Initial release
- Supports inflation adjustment for GBP, AUD, USD, EUR, CAD, JPY, CNY,
  and CHF
- Bundled CPI data from 1960–2024 for all currencies (CNY from 1986)
- Currency codes and country names both accepted as input
  (case-insensitive)
- Data sourced from the World Bank Development Indicators (FP.CPI.TOTL),
  rescaled to 2020 = 100
