# Adjust a monetary value using a GDP deflator

Converts an amount between two years using GDP deflator data sourced
from the World Bank Development Indicators (indicator: NY.GDP.DEFL.ZS).
Suitable for adjusting GDP figures, government expenditure, and other
macroeconomic aggregates. For adjusting personal or consumer values
(wages, prices of goods), use
[`adjust_inflation`](https://charlescoverdale.github.io/inflateR/reference/adjust_inflation.md)
which uses CPI instead.

## Usage

``` r
adjust_real(amount, from_year, currency, to_year = NULL, round = 2)
```

## Arguments

- amount:

  Numeric (scalar or vector). The original monetary amount(s).

- from_year:

  Integer. The year the amount is from.

- currency:

  Character. A currency code or country name. Accepted codes: `"GBP"`,
  `"AUD"`, `"USD"`, `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"`, `"CHF"`,
  `"NZD"`, `"INR"`, `"KRW"`, `"BRL"`, `"NOK"`. Country names are also
  accepted, e.g. `"Australia"`, `"United States"`, `"Japan"`,
  `"Switzerland"` (case-insensitive).

- to_year:

  Integer. The target year to adjust to. Defaults to the latest
  available year in the deflator series.

- round:

  Integer or `NULL`. Number of decimal places to round to (default 2).
  Use `NULL` for full precision.

## Value

A numeric value (or vector) representing the deflator-adjusted amount.

## Details

The GDP deflator measures price changes across all goods and services
produced in an economy, unlike CPI which tracks a fixed consumer basket.
Key differences from CPI:

- Covers all domestic production, not just consumer goods

- Excludes imported goods (CPI includes them)

- Updates its basket automatically (CPI uses a fixed basket)

- Published annually/quarterly (CPI is monthly)

Use the GDP deflator when comparing macroeconomic aggregates (GDP,
government spending, investment) across time. Use
[`adjust_inflation`](https://charlescoverdale.github.io/inflateR/reference/adjust_inflation.md)
for personal or consumer values.

## See also

Other GDP deflator adjustment:
[`historical_real()`](https://charlescoverdale.github.io/inflateR/reference/historical_real.md)

## Examples

``` r
# Adjust UK GDP from 1990 to today using GDP deflator
adjust_real(500000, 1990, "GBP")
#> [1] 1214416

# Compare US government spending in 2000 vs 2020 terms
adjust_real(1000000, 2000, "USD", to_year = 2020)
#> [1] 1428890
```
