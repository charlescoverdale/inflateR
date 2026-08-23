# CRAN submission comments: inflateR 0.2.0

## Reason for this submission

This is a feature release for inflateR 0.1.3, currently on CRAN.

## New functionality

* `inflation_rate()`: cumulative or annualised inflation between any two
  years.
* `list_currencies()`: the supported currencies and the span of data
  held for each.
* A `round` argument on all four adjustment functions. The default
  `round = 2` preserves the previous output exactly; `round = NULL`
  returns full precision.
* All four adjustment functions now accept a vector `amount`, so a
  column of values can be converted in one call rather than by
  `vapply()`.

## Internal changes

Shared logic behind the four adjustment functions has been extracted
into common helpers, removing what had become fourfold duplication. The
test suite has grown to over 80 tests, covering every function across
all 13 currencies, error handling, inverse round-trip properties, and
the new vectorised inputs. `data-raw/cpi_data.R` now builds both the CPI
and GDP deflator series for all 13 currencies in a single script.

## R CMD check results

0 errors | 0 warnings | 0 notes

Local check: macOS (aarch64), R 4.5.2, `devtools::check(cran = TRUE)`.

The local run emits "checking for future file timestamps: unable to
verify current time", which is the checking machine being unable to
reach worldclockapi.com rather than a package fault.

## Bundled data refreshed, and results change

The bundled World Bank CPI (FP.CPI.TOTL) and GDP deflator
(NY.GDP.DEFL.ZS) series have been refreshed. Every series now runs to
2025 except US CPI, which the World Bank has not published beyond 2024.

Numbers users get back will change, for two reasons, both documented in
NEWS.md:

* A call that does not name a `to_year` targets the latest year
  available, which has moved from 2024 to 2025.
* The World Bank revised history for several GDP deflator series. CHF is
  the largest, 42 years moving by a median of 2.4% and up to 13.8%. USD
  moves about 1.4% across 60 years. CPI series are essentially
  unrevised.

## A bug fixed by the refresh

Brazil's CPI and deflator series previously began in 1980 and 1960. Once
rebased to 2020 = 100, the hyperinflation years fall below the
resolution of the stored index and were held as exactly zero: 40 values
across the two datasets. A zero index divides, so
`adjust_inflation(100, 1985, 2020, currency = "BRL")` returned `Inf`
rather than refusing the request. Those years are now dropped, both
series begin in 1990, and the ordinary coverage check rejects an
out-of-range year with a message naming the real range.

The script that builds the data was rounding the rebased index to two
decimal places while the shipped data carried four, so re-running it
would have degraded 1078 of 1644 values and flattened Brazil's early
years to zero. That is fixed, and its hardcoded end year now derives
from the system date.

## Downstream dependencies

None.
