# Calculate the inflation rate between two years

Returns the cumulative or annualised inflation rate between two years,
using bundled CPI data sourced from the World Bank Development
Indicators.

## Usage

``` r
inflation_rate(from_year, to_year = NULL, currency, annualise = FALSE)
```

## Arguments

- from_year:

  Integer. The starting year.

- to_year:

  Integer. The ending year. Defaults to the latest available year in the
  data.

- currency:

  Character. A currency code or country name (case-insensitive). See
  [`adjust_inflation`](https://charlescoverdale.github.io/inflateR/reference/adjust_inflation.md)
  for accepted values.

- annualise:

  Logical. If `TRUE`, returns the annualised (compound annual) rate. If
  `FALSE` (default), returns the cumulative rate.

## Value

A numeric value representing the inflation rate as a proportion (e.g.
0.35 means 35\\

## Examples

``` r
# Cumulative US inflation from 2000 to 2020
inflation_rate(2000, 2020, "USD")
#> [1] 0.5030813

# Annualised UK inflation from 1990 to 2020
inflation_rate(1990, 2020, "GBP", annualise = TRUE)
#> [1] 0.02298728
```
