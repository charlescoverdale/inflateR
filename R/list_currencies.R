#' List supported currencies and data coverage
#'
#' Returns a data frame showing all supported currencies, the country
#' they represent, and the year range available for both CPI and GDP
#' deflator data.
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{currency}{ISO currency code (character)}
#'   \item{country}{Country or area name (character)}
#'   \item{cpi_start}{First year of CPI data (integer)}
#'   \item{cpi_end}{Last year of CPI data (integer)}
#'   \item{deflator_start}{First year of GDP deflator data (integer)}
#'   \item{deflator_end}{Last year of GDP deflator data (integer)}
#' }
#'
#' @examples
#' list_currencies()
#'
#' @export
list_currencies <- function() {
  countries <- c(
    GBP = "United Kingdom", AUD = "Australia", USD = "United States",
    EUR = "Euro area (Germany proxy)", CAD = "Canada", JPY = "Japan",
    CNY = "China", CHF = "Switzerland", NZD = "New Zealand",
    INR = "India", KRW = "South Korea", BRL = "Brazil", NOK = "Norway"
  )

  rows <- lapply(.valid_currencies, function(code) {
    cpi <- get_index_data(code, "cpi")
    defl <- get_index_data(code, "deflator")
    data.frame(
      currency       = code,
      country        = countries[[code]],
      cpi_start      = min(cpi$year),
      cpi_end        = max(cpi$year),
      deflator_start = min(defl$year),
      deflator_end   = max(defl$year),
      stringsAsFactors = FALSE
    )
  })

  result <- do.call(rbind, rows)
  rownames(result) <- NULL
  result
}
