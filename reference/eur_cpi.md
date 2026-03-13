# Euro Area CPI Data (1960-2024)

Annual Consumer Price Index for Germany, used as a proxy for the Euro
(EUR). Sourced from the World Bank Development Indicators (indicator:
FP.CPI.TOTL). Rescaled so that 2020 = 100.

## Usage

``` r
eur_cpi
```

## Format

A data frame with 65 rows and 2 columns:

- year:

  Calendar year (integer)

- index:

  CPI index value (numeric, base 2020 = 100)

## Source

World Bank Open Data <https://data.worldbank.org/indicator/FP.CPI.TOTL>

## Details

Note: The Euro area aggregate is not available in WDI. Germany is used
as a proxy as it is the largest Eurozone economy and was the monetary
anchor (Deutsche Mark) prior to the Euro's introduction in 1999.
