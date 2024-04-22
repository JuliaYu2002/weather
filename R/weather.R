#' @title High/low temperature class
#' @description
#' A class that holds vectors for the high and low temperatures for a series of dates at a particular location
#' @param highs Numeric vector of high temperatures
#' @param lows Numeric vector of low temperatures
#' @param dates Numeric vector of high temperatures
#' @param location Character vector containing city, state, and zip code
#' @return An object of class hi_lo_temp
hi_lo_temp <- function(highs, lows, dates, location) {
  obj <- new_hi_lo_temp(highs, lows, dates, location) |>
    validate_hi_lo_temp()
  return(obj)
}

#' @title Constructor for high/low temperature class
#' @description
#' Creates a class that holds vectors for the high and low temperatures for a series of dates at a particular location
#' @param highs Numeric vector of high temperatures
#' @param lows Numeric vector of low temperatures
#' @param dates Numeric vector of high temperatures
#' @param location Character vector containing city, state, and zip code
#' @return An object of class hi_lo_temp
new_hi_lo_temp <- function(highs, lows, dates, location) {
  structure(
    as.Date(as.numeric(dates)),
    "highs" = highs,
    "lows" = lows,
    "city" = location[1],
    "state" = location[2],
    "zip" = location[3],
    class = "hi_lo_temp"
  )
}

#' @title Validator for high/low temperature class
#' @description
#' Validates a class that holds vectors for the high and low temperatures for a series of dates at a particular location
#' @param highs Numeric vector of high temperatures
#' @param lows Numeric vector of low temperatures
#' @param dates Numeric vector of high temperatures
#' @param location Character vector containing city, state, and zip code
#' @return An object of class hi_lo_temp
validate_hi_lo_temp <- function(obj) {
  return(obj)
}

#' @title Graph high and low temperatures
#' @description
#' Graphs high and low temperatures from the past several days
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 xlab
#' @importFrom ggplot2 ylab
#' @importFrom ggplot2 ggtitle
#' @importFrom stringr str_to_title
#' @param obj A [`high_low_temp`] object
#' @exportS3Method
plot.hi_lo_temp <- function(obj) {
  df <- data.frame(dates = as.Date(as.numeric(obj)), highs = attr(obj, "highs"), lows = attr(obj, "lows"))
  ggplot2::ggplot() +
    ggplot2::geom_line(data = df, mapping = ggplot2::aes(x = dates, y = highs)) +
    ggplot2::geom_line(data = df, mapping = ggplot2::aes(x = dates, y = lows)) +
    ggplot2::xlab("Date") +
    ggplot2::ylab(paste0("High and Low Temp (ºF)")) +
    ggplot2::ggtitle(paste0("Weather in ", stringr::str_to_title(attr(obj, "city")), ", ", stringr::str_to_title(attr(obj, "state"))))
}

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
  dates <- seq(Sys.Date()-length(highs)+1, Sys.Date(), by="days")
  location <- c(city, state, zip)
  past_hi_lo_temps <- new_hi_lo_temp(highs, lows, dates, location)
  return(past_hi_lo_temps)
}
