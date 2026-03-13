# UK GDP Deflator Data (1960-2024)

Annual GDP deflator for the United Kingdom, sourced from the World Bank
Development Indicators (indicator: NY.GDP.DEFL.ZS). Rescaled so that
2020 = 100. Use for adjusting macroeconomic aggregates (GDP, government
spending, investment). For consumer values, use `uk_cpi` instead.

## Usage

``` r
uk_gdp_def
```

## Format

A data frame with 65 rows and 2 columns:

- year:

  Calendar year (integer)

- index:

  GDP deflator index value (numeric, base 2020 = 100)

## Source

World Bank Open Data
<https://data.worldbank.org/indicator/NY.GDP.DEFL.ZS>
