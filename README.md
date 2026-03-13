# inflateR

[![CRAN status](https://www.r-pkg.org/badges/version/inflateR)](https://cran.r-project.org/package=inflateR) [![CRAN downloads](https://cranlogs.r-pkg.org/badges/inflateR)](https://cran.r-project.org/package=inflateR) [![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Convert historical monetary values into their present-day equivalents - or reverse the calculation to find what a modern amount would have been worth in the past. Supports GBP, AUD, USD, EUR, CAD, JPY, CNY, CHF, NZD, INR, KRW, BRL, and NOK.

Getting consistent, comparable inflation data across multiple countries and many decades is harder than it sounds. Each country has its own national statistics agency, its own methodology, and its own publication format. The [World Bank Development Indicators](https://data.worldbank.org/indicator/FP.CPI.TOTL) solve this by aggregating data from national sources into a single, consistently formatted dataset - with the World Bank handling source reconciliation. All series are rescaled to 2020 = 100 for consistency across currencies.

## Installation

```r
install.packages("inflateR")

# Or install the development version from GitHub
# install.packages("devtools")
devtools::install_github("charlescoverdale/inflateR")
```

inflateR has no runtime dependencies and requires no API key or internet connection. All data is bundled directly inside the package.

## CPI vs GDP deflator - which should I use?

inflateR provides two methods for adjusting monetary values across time. Choosing between them depends on what you're adjusting.

**Use CPI (`adjust_inflation`, `historical_value`) for:**
- Wages and salaries - *"What would a £30,000 salary in 1990 be worth today?"*
- Everyday prices - *"What is £12 from 1963 worth in today's money?"*
- Household budgets and cost of living comparisons
- Retail prices, rents, consumer spending

CPI tracks the price of a fixed basket of goods and services that a typical household buys. It's the most intuitive measure for anything a person earns or spends.

**Use GDP deflator (`adjust_real`, `historical_real`) for:**
- GDP figures - *"How does UK GDP in 1980 compare to today in real terms?"*
- Government expenditure - *"What would the 2000 defence budget be worth today?"*
- Business investment and capital expenditure
- Any macroeconomic aggregate you want to compare across time

The GDP deflator covers all goods and services produced in the economy - not just the consumer basket. It updates automatically (no fixed basket) and excludes imported goods, making it more appropriate for economy-wide comparisons.

**When in doubt:** if you're talking about something a person earns, buys, or pays for - use CPI. If you're talking about a number from a national accounts table - use the GDP deflator.

## Functions

inflateR provides four functions in two symmetric pairs:

| Direction | CPI | GDP deflator |
|---|---|---|
| Historical → present | `adjust_inflation()` | `adjust_real()` |
| Present → historical | `historical_value()` | `historical_real()` |

```r
library(inflateR)

# CPI: adjust a historical value to today's money
adjust_inflation(amount, from_year, currency, to_year = NULL)

# CPI: convert a present value back to a historical year
historical_value(amount, to_year, currency, from_year = NULL)

# GDP deflator: adjust a historical value to today's money
adjust_real(amount, from_year, currency, to_year = NULL)

# GDP deflator: convert a present value back to a historical year
historical_real(amount, to_year, currency, from_year = NULL)
```

All four functions accept the same currency codes and country names and are exact inverses within each pair.

### Arguments

| Argument | Description |
|---|---|
| `amount` | Numeric. The monetary amount to convert |
| `from_year` | Integer. The year the amount is from |
| `to_year` | Integer. The target year (forward functions default to latest available; inverse functions require this) |
| `currency` | Character. Currency code (`"GBP"`, `"AUD"`, `"USD"`, `"EUR"`, `"CAD"`, `"JPY"`, `"CNY"`, `"CHF"`, `"NZD"`, `"INR"`, `"KRW"`, `"BRL"`, `"NOK"`) or country name (`"Australia"`, `"United States"`, `"New Zealand"`, `"India"`, `"Norway"`, etc.) - case-insensitive |
| `from_year` | Integer. For inverse functions: the year the amount is from (defaults to latest available) |

## Examples

### CPI: adjusting everyday values

```r
# What is £12 from 1963 worth today?
adjust_inflation(12, 1963, "GBP")
#> [1] 256.43

# What is $50 USD from 1980 worth today?
adjust_inflation(50, 1980, "USD")
#> [1] 190.33

# What is AUD 100 from 1990 worth today?
adjust_inflation(100, 1990, "AUD")
#> [1] 241.39

# Adjust to a specific year rather than today
adjust_inflation(100, 1970, "GBP", to_year = 2000)
#> [1] 872.45

# What would £100 today have been worth in 1963?
historical_value(100, 1963, "GBP")
#> [1] 4.68

# What would USD 1000 in 2020 have been worth in 1990?
historical_value(1000, 1990, "USD", from_year = 2020)
#> [1] 504.80
```

### GDP deflator: adjusting macroeconomic values

```r
# UK GDP was roughly £500bn in 1990 - what is that in today's terms?
adjust_real(500e9, 1990, "GBP")
#> [1] 1214415929203

# What would $1 trillion of US government spending in 2000 be worth in 2020?
adjust_real(1e12, 2000, "USD", to_year = 2020)
#> [1] 1428890000000

# Reverse: what would today's UK GDP of £2.5 trillion have been in 1990 terms?
historical_real(2.5e12, 1990, "GBP")
#> [1] 1028928849648
```

### Country names work too (case-insensitive)

```r
adjust_inflation(12, 1963, "Australia")   #> 212.02
adjust_inflation(12, 1963, "switzerland") #> 47.93
adjust_real(500e9, 1990, "United Kingdom") #> 1214415929203
```

## Data

All data is sourced from the [World Bank Development Indicators](https://data.worldbank.org/) and bundled inside the package. All indices are rescaled so that 2020 = 100.

### CPI datasets (indicator: `FP.CPI.TOTL`)

| Dataset | Currency | Coverage |
|---|---|---|
| `uk_cpi` | GBP | 1960–2024 |
| `aud_cpi` | AUD | 1960–2024 |
| `usd_cpi` | USD | 1960–2024 |
| `eur_cpi` | EUR | 1960–2024 (Germany proxy) |
| `cad_cpi` | CAD | 1960–2024 |
| `jpy_cpi` | JPY | 1960–2024 |
| `cny_cpi` | CNY | 1986–2024 |
| `chf_cpi` | CHF | 1960–2024 |
| `nzd_cpi` | NZD | 1960–2024 |
| `inr_cpi` | INR | 1960–2024 |
| `krw_cpi` | KRW | 1960–2024 |
| `brl_cpi` | BRL | 1980–2024 |
| `nok_cpi` | NOK | 1960–2024 |

### GDP deflator datasets (indicator: `NY.GDP.DEFL.ZS`)

| Dataset | Currency | Coverage |
|---|---|---|
| `uk_gdp_def` | GBP | 1960–2024 |
| `aud_gdp_def` | AUD | 1960–2024 |
| `usd_gdp_def` | USD | 1960–2024 |
| `eur_gdp_def` | EUR | 1960–2024 (Germany proxy) |
| `cad_gdp_def` | CAD | 1960–2024 |
| `jpy_gdp_def` | JPY | 1960–2024 |
| `cny_gdp_def` | CNY | 1960–2024 |
| `chf_gdp_def` | CHF | 1960–2024 |
| `nzd_gdp_def` | NZD | 1960–2024 |
| `inr_gdp_def` | INR | 1960–2024 |
| `krw_gdp_def` | KRW | 1960–2024 |
| `brl_gdp_def` | BRL | 1960–2024 |
| `nok_gdp_def` | NOK | 1960–2024 |

### Macroeconomic quirks

- **Tax shocks** - Australia (GST, 2000) and Canada (GST, 1991) both saw one-time price level jumps that appear in the CPI data but are really structural tax changes. Comparisons spanning these years will reflect the tax shift, not just underlying inflation.
- **Japan's deflation** - Japan had near-zero or negative inflation from roughly 1995 to 2020. Adjustments within this window will be very small, and in some years prices actually fell.
- **China's CPI coverage** - World Bank CPI data for China begins in 1986. The GDP deflator series begins in 1960 but the early years span significant structural change. Both series are internationally comparable but may not capture the full experience of price changes during China's reform era.
- **Euro proxy** - The World Bank does not publish an aggregated Euro area series for either CPI or GDP deflator. Germany is used as a proxy for both, which reflects the monetary anchor of the Eurozone but will understate the inflation experience of southern European countries in the 1970s and 1980s.
- **Annual figures only** - All values are annual averages. Month-to-month volatility is smoothed out.

## Related packages

The **inflateR** package is part of a suite of R packages for economic and financial data:

| Package | What it covers |
|---|---|
| [`ons`](https://github.com/charlescoverdale/ons) | ONS data (GDP, inflation, unemployment, wages, trade, house prices, population) |
| [`boe`](https://github.com/charlescoverdale/boe) | Bank of England data (Bank Rate, SONIA, gilt yields, exchange rates, mortgage rates) |
| [`hmrc`](https://github.com/charlescoverdale/hmrc) | HMRC tax receipts, corporation tax, stamp duty, R&D credits, and tax gap data |
| [`obr`](https://github.com/charlescoverdale/obr) | OBR fiscal forecasts and the Public Finances Databank |
| [`readecb`](https://github.com/charlescoverdale/readecb) | European Central Bank data (policy rates, HICP, exchange rates, yield curves) |
| [`readoecd`](https://github.com/charlescoverdale/readoecd) | OECD data (GDP, unemployment, inflation, trade across 38 member countries) |
| [`fred`](https://github.com/charlescoverdale/fred) | US Federal Reserve (FRED) data (800,000+ economic time series) |

## Issues

Please report bugs or requests at <https://github.com/charlescoverdale/inflateR/issues>.

## Keywords

inflation adjustment, CPI, consumer price index, purchasing power, real prices, nominal to real, price deflator, international inflation, currency adjustment, R package
