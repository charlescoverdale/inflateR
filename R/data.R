#' UK CPI Data (1960-2024)
#'
#' Annual Consumer Price Index for the United Kingdom, sourced from the
#' World Bank Development Indicators (indicator: FP.CPI.TOTL).
#' Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{CPI index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/FP.CPI.TOTL}
"uk_cpi"

#' Australian CPI Data (1960-2024)
#'
#' Annual Consumer Price Index for Australia, sourced from the
#' World Bank Development Indicators (indicator: FP.CPI.TOTL).
#' Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{CPI index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/FP.CPI.TOTL}
"aud_cpi"

#' US CPI Data (1960-2024)
#'
#' Annual Consumer Price Index for the United States, sourced from the
#' World Bank Development Indicators (indicator: FP.CPI.TOTL).
#' Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{CPI index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/FP.CPI.TOTL}
"usd_cpi"

#' Euro Area CPI Data (1960-2024)
#'
#' Annual Consumer Price Index for Germany, used as a proxy for the Euro (EUR).
#' Sourced from the World Bank Development Indicators (indicator: FP.CPI.TOTL).
#' Rescaled so that 2020 = 100.
#'
#' Note: The Euro area aggregate is not available in WDI. Germany is used as
#' a proxy as it is the largest Eurozone economy and was the monetary anchor
#' (Deutsche Mark) prior to the Euro's introduction in 1999.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{CPI index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/FP.CPI.TOTL}
"eur_cpi"

#' Canadian CPI Data (1960-2024)
#'
#' Annual Consumer Price Index for Canada, sourced from the
#' World Bank Development Indicators (indicator: FP.CPI.TOTL).
#' Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{CPI index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/FP.CPI.TOTL}
"cad_cpi"

#' Japanese CPI Data (1960-2024)
#'
#' Annual Consumer Price Index for Japan, sourced from the
#' World Bank Development Indicators (indicator: FP.CPI.TOTL).
#' Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{CPI index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/FP.CPI.TOTL}
"jpy_cpi"

#' Chinese CPI Data (1986-2024)
#'
#' Annual Consumer Price Index for China, sourced from the
#' World Bank Development Indicators (indicator: FP.CPI.TOTL).
#' Rescaled so that 2020 = 100. Data availability begins in 1986.
#'
#' @format A data frame with 39 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{CPI index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/FP.CPI.TOTL}
"cny_cpi"

#' Swiss CPI Data (1960-2024)
#'
#' Annual Consumer Price Index for Switzerland, sourced from the
#' World Bank Development Indicators (indicator: FP.CPI.TOTL).
#' Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{CPI index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/FP.CPI.TOTL}
"chf_cpi"

# GDP Deflator datasets -------------------------------------------------------

#' UK GDP Deflator Data (1960-2024)
#'
#' Annual GDP deflator for the United Kingdom, sourced from the World Bank
#' Development Indicators (indicator: NY.GDP.DEFL.ZS). Rescaled so that 2020 = 100.
#' Use for adjusting macroeconomic aggregates (GDP, government spending, investment).
#' For consumer values, use \code{uk_cpi} instead.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{GDP deflator index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/NY.GDP.DEFL.ZS}
"uk_gdp_def"

#' Australian GDP Deflator Data (1960-2024)
#'
#' Annual GDP deflator for Australia, sourced from the World Bank
#' Development Indicators (indicator: NY.GDP.DEFL.ZS). Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{GDP deflator index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/NY.GDP.DEFL.ZS}
"aud_gdp_def"

#' US GDP Deflator Data (1960-2024)
#'
#' Annual GDP deflator for the United States, sourced from the World Bank
#' Development Indicators (indicator: NY.GDP.DEFL.ZS). Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{GDP deflator index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/NY.GDP.DEFL.ZS}
"usd_gdp_def"

#' Euro Area GDP Deflator Data (1960-2024)
#'
#' Annual GDP deflator for Germany, used as a proxy for the Euro (EUR).
#' Sourced from the World Bank Development Indicators (indicator: NY.GDP.DEFL.ZS).
#' Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{GDP deflator index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/NY.GDP.DEFL.ZS}
"eur_gdp_def"

#' Canadian GDP Deflator Data (1960-2024)
#'
#' Annual GDP deflator for Canada, sourced from the World Bank
#' Development Indicators (indicator: NY.GDP.DEFL.ZS). Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{GDP deflator index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/NY.GDP.DEFL.ZS}
"cad_gdp_def"

#' Japanese GDP Deflator Data (1960-2024)
#'
#' Annual GDP deflator for Japan, sourced from the World Bank
#' Development Indicators (indicator: NY.GDP.DEFL.ZS). Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{GDP deflator index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/NY.GDP.DEFL.ZS}
"jpy_gdp_def"

#' Chinese GDP Deflator Data (1960-2024)
#'
#' Annual GDP deflator for China, sourced from the World Bank
#' Development Indicators (indicator: NY.GDP.DEFL.ZS). Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{GDP deflator index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/NY.GDP.DEFL.ZS}
"cny_gdp_def"

#' Swiss GDP Deflator Data (1960-2024)
#'
#' Annual GDP deflator for Switzerland, sourced from the World Bank
#' Development Indicators (indicator: NY.GDP.DEFL.ZS). Rescaled so that 2020 = 100.
#'
#' @format A data frame with 65 rows and 2 columns:
#' \describe{
#'   \item{year}{Calendar year (integer)}
#'   \item{index}{GDP deflator index value (numeric, base 2020 = 100)}
#' }
#' @source World Bank Open Data \url{https://data.worldbank.org/indicator/NY.GDP.DEFL.ZS}
"chf_gdp_def"
