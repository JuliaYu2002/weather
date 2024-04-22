#' @title Retrieve high and low temperature data
#' @description
#' Scrapes www.localconditions.com
#' @param city A character vector of the city name
#' @param state A character vector of the state name
#' @param zip A character vector of the zip code of the city
#' @return An object of class [`hi_lo_temp`]
#' @export
past_days <- function(city = "northampton", state = "massachusetts", zip = "01060") {
  site <- rvest::read_html(paste0("https://www.localconditions.com/weather-", city, "-", state, "/", zip, "/past.php"))
  highs <- site |>
    rvest::html_elements(".past_weather_express") |>
    rvest::html_text() |>
    stringr::str_extract("High: [0-9\\.]*") |>
    substring(7) |>
    as.numeric() |>
    rev()
  lows <- site |>
    rvest::html_elements(".past_weather_express") |>
    rvest::html_text() |>
    stringr::str_extract("Low: [0-9\\.]*") |>
    substring(6) |>
    as.numeric() |>
    rev()
  precip <- site |>
    rvest::html_elements(".past_weather_express") |>
    rvest::html_text() |>
    stringr::str_extract("Approx. Precipitation / Rain Total: [0-9\\.]*") |>
    substring(36) |>
    as.numeric() |>
    rev()
  precip <- replace(precip, is.na(precip), 0)
  print(precip)
  dates <- seq(Sys.Date()-length(highs)+1, Sys.Date(), by="days")
  recent_weather <- data.frame("City" = city, "State" = state, "High" = highs, "Low" = lows, "Date" = dates, "Precipitation" = precip)
  return(recent_weather)
}
