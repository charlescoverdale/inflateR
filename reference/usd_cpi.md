# US CPI Data (1960-2025)

Annual Consumer Price Index for the United States, sourced from the
World Bank Development Indicators (indicator: FP.CPI.TOTL). Rescaled so
that 2020 = 100.

## Usage

``` r
usd_cpi
```

## Format

A data frame with 66 rows and 2 columns:

- year:

  Calendar year (integer)

- index:

  CPI index value (numeric, base 2020 = 100)

## Source

World Bank Open Data <https://data.worldbank.org/indicator/FP.CPI.TOTL>;
2025 from U.S. Bureau of Labor Statistics, series CUUR0000SA0
<https://www.bls.gov/cpi/>

## Details

The World Bank has not published 2025: the Bureau of Labor Statistics
collected no October 2025 prices during the lapse in appropriations.
2025 is therefore chained from the BLS CPI-U (all items, US city
average) 2025 annual average, which BLS computed from the eleven months
collected. The World Bank's US series is the CPI-U annual average, so
the two are the same measure.
