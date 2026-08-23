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

## Notes on bundled data

The package bundles World Bank CPI (FP.CPI.TOTL) and GDP deflator
(NY.GDP.DEFL.ZS) series. The current vintage runs from 1960 to 2024,
except BRL CPI which begins in 1980.

## Downstream dependencies

None.
