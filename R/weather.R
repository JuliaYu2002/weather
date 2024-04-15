#' @title Retrieve today's temperatures
#'
#' @description
#' Returns how the temperature changes over the course of today in Northampton
#'
#' @importFrom rvest read_html
#' @importFrom rvest html_elements
#' @importFrom rvest html_text
#' @export
temps_today <- function(city = "northampton", state = "massachusetts", zip = "01060") {
  site <- rvest::read_html(paste0("https://www.localconditions.com/weather-", city, "-", state, "/", zip, "/past.php"))
  data <- site |>
    rvest::html_elements("#day0 td:nth-child(2)") |>
    rvest::html_text()
  data <- as.numeric(data)
  return(data)
}

#' @title Retrieve high temperatures from the past several days
#'
#' @description
#' Returns high temperatures from the past several days in Northampton
#'
#' @importFrom rvest read_html
#' @importFrom rvest html_elements
#' @importFrom rvest html_text
#' @importFrom stringr str_extract
high_temps_past <- function(city, state, zip) {
  site <- rvest::read_html(paste0("https://www.localconditions.com/weather-", city, "-", state, "/", zip, "/past.php"))
  data <- site |>
    rvest::html_elements(".past_weather_express") |>
    rvest::html_text() |>
    stringr::str_extract("High: [0-9\\.]*") |>
    substring(7) |>
    as.numeric()
  return(rev(data))
}

#' @title Retrieve high temperatures from the past several days
#'
#' @description
#' Returns high temperatures from the past several days in Northampton
#'
#' @importFrom rvest read_html
#' @importFrom rvest html_elements
#' @importFrom rvest html_text
#' @importFrom stringr str_extract
low_temps_past <- function(city, state, zip) {
  site <- rvest::read_html(paste0("https://www.localconditions.com/weather-", city, "-", state, "/", zip, "/past.php"))
  data <- site |>
    rvest::html_elements(".past_weather_express") |>
    rvest::html_text() |>
    stringr::str_extract("Low: [0-9\\.]*") |>
    substring(6) |>
    as.numeric()
  return(rev(data))
}

#' @title Graph high and low temperatures from the past several days
#'
#' @description
#' Graphs high and low temperatures from the past several days
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 xlab
#' @importFrom ggplot2 ylab
#' @importFrom ggplot2 ggtitle
#' @importFrom stringr str_to_title
#'
#' @export
show_hi_lo <- function(city = "northampton", state = "ma", zip = 01060) {
  highs <- high_temps_past(city, state, zip)
  lows <- low_temps_past(city, state, zip)
  dates <- seq(Sys.Date()-length(highs)+1, Sys.Date(), by="days")
  df <- data.frame(dates = dates, highs = highs, lows = lows)
  ggplot2::ggplot() +
    ggplot2::geom_line(data = df, mapping = ggplot2::aes(x = dates, y = highs)) +
    ggplot2::geom_line(data = df, mapping = ggplot2::aes(x = dates, y = lows)) +
    ggplot2::xlab("Date") +
    ggplot2::ylab("High and Low Temp") +
    ggplot2::ggtitle(paste0("Weather in ", stringr::str_to_title(city), ", ", stringr::str_to_title(state)))
}

to_fahrenheit <- function(temp, unit = "celsius") {
  if (unit == "celsius") {
    return((temp * 9/5) + 32)
  } else if (unit == "kelvin") {
    return((temp - 273.15) * 9/5 + 32)
  } else {
    stop("Invalid unit of temperature.")
  }
}

to_celsius <- function(temp, unit = "fahrenheit") {
  if (unit == "fahrenheit") {
    return((temp - 32) / 9/5)
  } else if (unit == "kelvin") {
    return((temp + 32) * 9/5 - 273.15)
  } else {
    stop("Invalid unit of temperature.")
  }
}
