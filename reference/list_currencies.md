# List supported currencies and data coverage

Returns a data frame showing all supported currencies, the country they
represent, and the year range available for both CPI and GDP deflator
data.

## Usage

``` r
list_currencies()
```

## Value

A data frame with columns:

- currency:

  ISO currency code (character)

- country:

  Country or area name (character)

- cpi_start:

  First year of CPI data (integer)

- cpi_end:

  Last year of CPI data (integer)

- deflator_start:

  First year of GDP deflator data (integer)

- deflator_end:

  Last year of GDP deflator data (integer)

## Examples

``` r
list_currencies()
#>    currency                   country cpi_start cpi_end deflator_start
#> 1       GBP            United Kingdom      1960    2025           1960
#> 2       AUD                 Australia      1960    2025           1960
#> 3       USD             United States      1960    2025           1960
#> 4       EUR Euro area (Germany proxy)      1960    2025           1960
#> 5       CAD                    Canada      1960    2025           1960
#> 6       JPY                     Japan      1960    2025           1960
#> 7       CNY                     China      1986    2025           1960
#> 8       CHF               Switzerland      1960    2025           1960
#> 9       NZD               New Zealand      1960    2025           1960
#> 10      INR                     India      1960    2025           1960
#> 11      KRW               South Korea      1960    2025           1960
#> 12      BRL                    Brazil      1990    2025           1990
#> 13      NOK                    Norway      1960    2025           1960
#>    deflator_end
#> 1          2025
#> 2          2025
#> 3          2025
#> 4          2025
#> 5          2025
#> 6          2025
#> 7          2025
#> 8          2025
#> 9          2025
#> 10         2025
#> 11         2025
#> 12         2025
#> 13         2025
```
