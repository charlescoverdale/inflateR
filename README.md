# inflateR

Convert historical monetary values into their present-day equivalents using bundled CPI data. Supports British pounds (GBP), Australian dollars (AUD), and US dollars (USD).

## Installation

```r
devtools::install_github("charlescoverdale/inflateR")
```

## Usage

```r
library(inflateR)

adjust_inflation(amount, from_year, currency, to_year = NULL)
```

### Arguments

| Argument | Description |
|---|---|
| `amount` | Numeric. The original monetary amount |
| `from_year` | Integer. The year the amount is from |
| `currency` | Character. One of `"GBP"`, `"AUD"`, or `"USD"` |
| `to_year` | Integer. Target year (defaults to latest available year) |

## Examples

### What is £12 from 1963 worth today?

```r
adjust_inflation(12, 1963, "GBP")
#> [1] 296
```

### What is $50 USD from 1980 worth today?

```r
adjust_inflation(50, 1980, "USD")
#> [1] 283.35
```

### What is AUD 100 from 1990 worth today?

```r
adjust_inflation(100, 1990, "AUD")
#> [1] 257.33
```

### Adjust to a specific year (not just today)

```r
adjust_inflation(100, 1970, "GBP", to_year = 2000)
#> [1] 918.92
```

### Compare the same amount across currencies

```r
adjust_inflation(12, 1963, "GBP")  #> 296.00
adjust_inflation(12, 1963, "AUD")  #> 351.43
adjust_inflation(12, 1963, "USD")  #> 197.68
```

## Data

CPI data is bundled inside the package and covers 1948–2024 for all three currencies. Index base: 2020 = 100.

| Dataset | Coverage | Source |
|---|---|---|
| `uk_cpi` | 1948–2024 | Bank of England |
| `aud_cpi` | 1948–2024 | Australian Bureau of Statistics (ABS) |
| `usd_cpi` | 1948–2024 | Bureau of Labor Statistics (BLS) |

## License

MIT
