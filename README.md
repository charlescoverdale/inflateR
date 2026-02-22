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

CPI data is bundled inside the package and covers 1948–2024 for all three currencies. All indices use 2020 as the base year (2020 = 100). Values are approximate annual averages.

---

### `uk_cpi` — United Kingdom

**Source:** [Bank of England Research Datasets](https://www.bankofengland.co.uk/statistics/research-datasets) and [Office for National Statistics (ONS)](https://www.ons.gov.uk/economy/inflationandpriceindices)

The UK CPI series was officially adopted in 2003 as the Bank of England's inflation target measure. Prior to this, the **Retail Price Index (RPI)** was the primary measure of inflation. For years before 1988, this package uses RPI as a proxy for CPI, which is standard practice in historical comparisons.

**Limitations:**
- Pre-1988 values are based on RPI, which uses a different methodology to CPI (RPI typically runs 0.5–1% higher than CPI)
- RPI and CPI differ in their treatment of housing costs — CPI excludes owner-occupier housing costs, RPI includes them
- For years before 1948, no data is available in this package

---

### `aud_cpi` — Australia

**Source:** [Australian Bureau of Statistics (ABS) — Consumer Price Index, Australia](https://www.abs.gov.au/statistics/economy/price-indexes-and-inflation/consumer-price-index-australia)

The ABS has published quarterly CPI data since 1948. Annual averages are used here. The series covers all groups across eight capital cities combined.

**Limitations:**
- The introduction of the **Goods and Services Tax (GST)** in July 2000 caused a one-time step increase in the price level of approximately 2.5–3%. This is reflected in the data but means year-on-year comparisons across 1999–2000 will show an outsized jump that is tax-driven rather than purely inflation-driven
- Prior to 1948, no official CPI series exists for Australia
- The series reflects capital city averages and may not represent regional price changes accurately

---

### `usd_cpi` — United States

**Source:** [U.S. Bureau of Labor Statistics (BLS) — CPI-U (All Urban Consumers)](https://www.bls.gov/cpi/)

The CPI-U is the most widely cited US inflation measure, covering approximately 93% of the US population. Annual averages of the monthly CPI-U series are used here.

**Limitations:**
- The BLS CPI-U series extends back to 1913, but this package only includes data from 1948 onwards for consistency with the other currencies
- The BLS has made several methodological changes over the decades (e.g. shift to geometric mean aggregation in 1999, changes to housing cost measurement), which affect comparability across long time periods
- The CPI-U covers urban consumers only; rural consumers are excluded

---

### General Limitations

- **Data is static** — CPI values are bundled at the time the package was built and are not updated automatically. The data runs to 2024.
- **Annual averages** — monthly price fluctuations are smoothed into a single annual figure, which may differ from point-in-time comparisons.
- **Not for legal or financial use** — for precise financial, legal, or actuarial calculations, always source data directly from the official statistical agencies linked above.
