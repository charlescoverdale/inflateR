# Convert a value to its historical equivalent using a GDP deflator

Takes a monetary amount from a recent year and returns what it would
have been worth in a specified historical year, using GDP deflator data
sourced from the World Bank Development Indicators (indicator:
NY.GDP.DEFL.ZS). This is the inverse of
[`adjust_real`](https://charlescoverdale.github.io/inflateR/reference/adjust_real.md).

## Usage

``` r
historical_real(amount, to_year, currency, from_year = NULL)
```

## Arguments

- amount:

  Numeric. The monetary amount in the reference year.

- to_year:

  Integer. The historical year to convert back to.

- currency:

  Character. Currency code (`"GBP"`, `"AUD"`, `"USD"`, `"EUR"`, `"CAD"`,
  `"JPY"`, `"CNY"`, `"CHF"`) or country name (`"Australia"`,
  `"United States"`, etc.) — case-insensitive.

- from_year:

  Integer. The year the amount is from. Defaults to the latest year
  available in the deflator series.

## Value

A numeric value representing the historical equivalent amount.

## Details

For converting consumer or personal values, use
[`historical_value`](https://charlescoverdale.github.io/inflateR/reference/historical_value.md)
which uses CPI instead.

## Examples

``` r
# What would UK GDP of £2 trillion today have been in 1990 terms?
historical_real(2e12, 1990, "GBP")
#> [1] 823440738647

# What would USD 1 trillion in 2020 have been worth in 2000?
historical_real(1e12, 2000, "USD", from_year = 2020)
#> [1] 6.99844e+11
```
