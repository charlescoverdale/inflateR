# Adjust a historical monetary value for inflation

Converts an amount from a historical year into its equivalent value in a
target year, using bundled CPI data sourced from the World Bank
Development Indicators. Supports GBP, AUD, USD, EUR, CAD, JPY, CNY, CHF,
NZD, INR, KRW, BRL, and NOK.

## Usage

``` r
adjust_inflation(amount, from_year, currency, to_year = NULL)
```

## Arguments

- amount:

  Numeric. The original monetary amount.

- from_year:

  Integer. The year the amount is from.

- currency:

  Character. A currency code or country name. Accepted codes: `"GBP"`,
  `"AUD"`, `"USD"`, `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"`, `"CHF"`. Country
  names are also accepted, e.g. `"Australia"`, `"United States"`,
  `"Japan"`, `"New Zealand"`, `"India"`, `"Norway"` (case-insensitive).

- to_year:

  Integer. The target year to adjust to. Defaults to the current year.

## Value

A numeric value representing the inflation-adjusted amount.

## Examples

``` r
# What is £12 from 1963 worth today?
adjust_inflation(12, 1963, "GBP")
#> [1] 256.43

# What is AUD 50 from 1980 worth in 2000?
adjust_inflation(50, 1980, "AUD", to_year = 2000)
#> [1] 135.59
```
