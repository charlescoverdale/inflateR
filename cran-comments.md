## R CMD check results

0 errors | 0 warnings | 4 notes

The 4 notes are:

* `Days since last update: 0` — this is a patch update adding new currencies; submitted same day as previous version was pushed to GitHub
* `unable to verify current time` — local environment issue, not reproducible on CRAN servers
* `README.md or NEWS.md cannot be checked without 'pandoc' being installed` — pandoc is not on PATH in the non-interactive R session used for checks; files are valid markdown
* `Skipping checking HTML validation: 'tidy' doesn't look like recent enough HTML Tidy` — local tidy version limitation; not a package issue

## Changes in 0.1.3

* Added 5 new currencies: NZD (New Zealand), INR (India), KRW (South Korea), BRL (Brazil), NOK (Norway)
* Bundled CPI and GDP deflator data (World Bank FP.CPI.TOTL and NY.GDP.DEFL.ZS) for all new currencies
* BRL CPI coverage begins 1980; all other new series cover 1960–2024

## Downstream dependencies

None.
