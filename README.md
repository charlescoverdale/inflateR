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
#> [1] 256.43
```

### What is $50 USD from 1980 worth today?

```r
adjust_inflation(50, 1980, "USD")
#> [1] 190.33
```

### What is AUD 100 from 1990 worth today?

```r
adjust_inflation(100, 1990, "AUD")
#> [1] 241.39
```

### Adjust to a specific year (not just today)

```r
adjust_inflation(100, 1970, "GBP", to_year = 2000)
#> [1] 872.45
```

### Compare the same amount across currencies

```r
adjust_inflation(12, 1963, "GBP")  #> 256.43
adjust_inflation(12, 1963, "AUD")  #> 212.02
adjust_inflation(12, 1963, "USD")  #> 122.94
adjust_inflation(12, 1963, "EUR")  #>  60.62
adjust_inflation(12, 1963, "CAD")  #> 119.73
adjust_inflation(12, 1963, "JPY")  #>  60.24
```

### Chinese yuan (data available from 1986)

```r
adjust_inflation(100, 1990, "CNY")
#> [1] 327.65
```

## Data

CPI data is sourced from the [World Bank Development Indicators](https://data.worldbank.org/indicator/FP.CPI.TOTL) (indicator: `FP.CPI.TOTL`) and bundled inside the package. All indices are rescaled so that 2020 = 100.

| Dataset | Currency | Coverage | Source |
|---|---|---|---|
| `uk_cpi` | GBP | 1960–2024 | World Bank (United Kingdom) |
| `aud_cpi` | AUD | 1960–2024 | World Bank (Australia) |
| `usd_cpi` | USD | 1960–2024 | World Bank (United States) |
| `eur_cpi` | EUR | 1960–2024 | World Bank (Germany, proxy for EUR) |
| `cad_cpi` | CAD | 1960–2024 | World Bank (Canada) |
| `jpy_cpi` | JPY | 1960–2024 | World Bank (Japan) |
| `cny_cpi` | CNY | 1986–2024 | World Bank (China) |

---

### `uk_cpi` — United Kingdom

**Source:** [World Bank — FP.CPI.TOTL (United Kingdom)](https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=GB)

**Limitations:**
- Data available from 1960 onwards
- For years before 1960, no data is available in this package

---

### `aud_cpi` — Australia

**Source:** [World Bank — FP.CPI.TOTL (Australia)](https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=AU)

**Limitations:**
- Data available from 1960 onwards
- The introduction of the **Goods and Services Tax (GST)** in July 2000 caused a one-time step increase in the price level of approximately 2.5–3%, visible in the data

---

### `usd_cpi` — United States

**Source:** [World Bank — FP.CPI.TOTL (United States)](https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=US)

**Limitations:**
- Data available from 1960 onwards

---

### `eur_cpi` — Euro

**Source:** [World Bank — FP.CPI.TOTL (Germany)](https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=DE)

The Euro area aggregate is not available in the World Bank WDI. Germany is used as a proxy as it is the largest Eurozone economy and was the monetary anchor (Deutsche Mark) prior to the Euro's introduction in 1999.

**Limitations:**
- Reflects German CPI, not a Euro area composite — southern European countries (Italy, Spain, Portugal) had significantly higher inflation in the 1970s–80s
- Data available from 1960 onwards

---

### `cad_cpi` — Canada

**Source:** [World Bank — FP.CPI.TOTL (Canada)](https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=CA)

**Limitations:**
- Data available from 1960 onwards
- The introduction of the **Goods and Services Tax (GST)** in January 1991 caused a one-time step increase in measured prices

---

### `jpy_cpi` — Japan

**Source:** [World Bank — FP.CPI.TOTL (Japan)](https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=JP)

**Limitations:**
- Data available from 1960 onwards
- Japan experienced prolonged **deflation and near-zero inflation from approximately 1995 to 2020**, so adjustments within this period will be very small

---

### `cny_cpi` — China

**Source:** [World Bank — FP.CPI.TOTL (China)](https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=CN)

**Limitations:**
- **Data only available from 1986** — the earliest year in the World Bank series for China
- China experienced significant inflation spikes in 1988–1989 and 1993–1995; comparisons spanning these periods will show large adjustments

---

### General Limitations

- **Data is static** — CPI values are bundled at the time the package was built and are not updated automatically. The data runs to 2024. To refresh, run `data-raw/cpi_data.R`.
- **Annual figures** — monthly price fluctuations are smoothed into a single annual figure, which may differ from point-in-time comparisons.
- **Not for legal or financial use** — for precise financial, legal, or actuarial calculations, source data directly from the [World Bank](https://data.worldbank.org/indicator/FP.CPI.TOTL) or the relevant national statistics agency.
