# Convert a present-day value to its historical equivalent

Takes a monetary amount from a recent year and returns what it would
have been worth in a specified historical year, using bundled CPI data
sourced from the World Bank Development Indicators. Supports GBP, AUD,
USD, EUR, CAD, JPY, CNY, CHF, NZD, INR, KRW, BRL, and NOK.

## Usage

``` r
historical_value(amount, to_year, currency, from_year = NULL, round = 2)
```

## Arguments

- amount:

  Numeric (scalar or vector). The monetary amount(s) in the reference
  year.

- to_year:

  Integer. The historical year to convert back to.

- currency:

  Character. Currency code (`"GBP"`, `"AUD"`, `"USD"`, `"EUR"`, `"CAD"`,
  `"JPY"`, `"CNY"`, `"CHF"`, `"NZD"`, `"INR"`, `"KRW"`, `"BRL"`,
  `"NOK"`) or country name (`"Australia"`, `"United States"`, etc.) —
  case-insensitive.

- from_year:

  Integer. The year the amount is from. Defaults to the latest year
  available in the data.

- round:

  Integer or `NULL`. Number of decimal places to round to (default 2).
  Use `NULL` for full precision.

## Value

A numeric value (or vector) representing the historical equivalent
amount.

## See also

Other CPI adjustment:
[`adjust_inflation()`](https://charlescoverdale.github.io/inflateR/reference/adjust_inflation.md)

## Examples

``` r
# What would £100 today have been worth in 1963?
historical_value(100, 1963, "GBP")
#> [1] 4.68

# What would USD 500 in 2020 have been worth in 1980?
historical_value(500, 1980, "USD", from_year = 2020)
#> [1] 159.2
```
