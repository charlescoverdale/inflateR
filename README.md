# inflateR

Convert historical monetary values into their present-day equivalents using bundled CPI data. Supports GBP, AUD, USD, EUR, CAD, JPY, and CNY.

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
| `currency` | Character. One of `"GBP"`, `"AUD"`, `"USD"`, `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"` |
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
adjust_inflation(12, 1963, "EUR")  #> 385.26
adjust_inflation(12, 1963, "CAD")  #> 272.89
adjust_inflation(12, 1963, "JPY")  #> 123.43
```

### Chinese yuan (data available from 1978)

```r
adjust_inflation(100, 1985, "CNY")
#> [1] 742.86
```

## Data

CPI data is bundled inside the package. All indices use 2020 as the base year (2020 = 100). Values are approximate annual averages.

| Dataset | Currency | Coverage | Source |
|---|---|---|---|
| `uk_cpi` | GBP | 1948–2024 | Bank of England / ONS |
| `aud_cpi` | AUD | 1948–2024 | Australian Bureau of Statistics |
| `usd_cpi` | USD | 1948–2024 | Bureau of Labor Statistics |
| `eur_cpi` | EUR | 1960–2024 | Eurostat |
| `cad_cpi` | CAD | 1948–2024 | Statistics Canada |
| `jpy_cpi` | JPY | 1948–2024 | Statistics Bureau of Japan |
| `cny_cpi` | CNY | 1978–2024 | National Bureau of Statistics of China |

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

### `eur_cpi` — Euro Area

**Source:** [Eurostat — Harmonised Index of Consumer Prices (HICP)](https://ec.europa.eu/eurostat/web/hicp)

Eurostat publishes HICP data for the Euro area as a whole. The Euro was introduced in 1999, so pre-1999 values in this package are a GDP-weighted composite proxy based on major Eurozone economies (Germany, France, Italy, Spain, and others).

**Limitations:**
- Pre-1999 data is a backward-calculated estimate, not an official Eurostat series
- Individual Eurozone countries had very different inflation experiences — southern European countries (Italy, Spain, Portugal) had significantly higher inflation in the 1970s–80s than Germany
- The Euro area composition has changed over time (from 11 members in 1999 to 20 today), affecting comparability

---

### `cad_cpi` — Canada

**Source:** [Statistics Canada — Consumer Price Index](https://www.statcan.gc.ca/en/subjects-start/prices_and_price_indexes/consumer_price_indexes)

Statistics Canada has published CPI data since 1914. Annual averages of the all-items CPI are used here.

**Limitations:**
- The introduction of the **Goods and Services Tax (GST)** in January 1991 caused a one-time step increase in measured prices, similar to Australia's GST in 2000
- The series reflects national averages; regional variation (particularly between provinces) can be significant

---

### `jpy_cpi` — Japan

**Source:** [Statistics Bureau of Japan — Consumer Price Index](https://www.stat.go.jp/english/data/cpi/index.htm)

Japan's CPI is published monthly by the Statistics Bureau. Annual averages are used here.

**Limitations:**
- Japan experienced a prolonged period of **deflation and near-zero inflation from approximately 1995 to 2020**. This means year-on-year adjustments within this period will be very small, and prices in 2000 may appear higher than prices in 2015 in index terms
- Japan's 1997 and 2014 consumption tax increases caused one-time price level jumps visible in the data
- Post-war data (1948–1955) reflects rapid stabilisation after wartime hyperinflation and should be treated with caution

---

### `cny_cpi` — China

**Source:** [National Bureau of Statistics of China — Consumer Price Index](https://www.stats.gov.cn/english/)

China's modern CPI series begins with the reform and opening-up period in 1978. Pre-1978 data does not exist in a reliable, internationally comparable form.

**Limitations:**
- **Data only available from 1978** — no pre-reform era data is included
- China experienced two significant inflation spikes: 1988–1989 (~20% annual inflation) and 1993–1995 (~25% annual inflation). Comparisons spanning these periods will show large adjustments
- The NBS methodology has evolved considerably since 1978 and may not be fully consistent across the entire series
- The CPI basket weightings have changed substantially as China's economy transformed from rural/agricultural to urban/industrial

---

### General Limitations

- **Data is static** — CPI values are bundled at the time the package was built and are not updated automatically. The data runs to 2024.
- **Annual averages** — monthly price fluctuations are smoothed into a single annual figure, which may differ from point-in-time comparisons.
- **Not for legal or financial use** — for precise financial, legal, or actuarial calculations, always source data directly from the official statistical agencies linked above.
