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
#> 1       GBP            United Kingdom      1960    2024           1960
#> 2       AUD                 Australia      1960    2024           1960
#> 3       USD             United States      1960    2024           1960
#> 4       EUR Euro area (Germany proxy)      1960    2024           1960
#> 5       CAD                    Canada      1960    2024           1960
#> 6       JPY                     Japan      1960    2024           1960
#> 7       CNY                     China      1986    2024           1960
#> 8       CHF               Switzerland      1960    2024           1960
#> 9       NZD               New Zealand      1960    2024           1960
#> 10      INR                     India      1960    2024           1960
#> 11      KRW               South Korea      1960    2024           1960
#> 12      BRL                    Brazil      1980    2024           1960
#> 13      NOK                    Norway      1960    2024           1960
#>    deflator_end
#> 1          2024
#> 2          2024
#> 3          2024
#> 4          2024
#> 5          2024
#> 6          2024
#> 7          2024
#> 8          2024
#> 9          2024
#> 10         2024
#> 11         2024
#> 12         2024
#> 13         2024
```
