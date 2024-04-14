#' @title Retrieve today's temperatures
#'
#' @description
#' Returns how the temperature changes over the course of today in Northampton
#'
#' @importFrom rvest read_html
#' @importFrom rvest html_elements
#' @importFrom rvest html_text
#' @export
temps_today <- function() {
  site <- rvest::read_html("https://www.localconditions.com/weather-northampton-massachusetts/01060/past.php")
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
#' @export
high_temps_past <- function() {
  site <- rvest::read_html("https://www.localconditions.com/weather-northampton-massachusetts/01060/past.php")
  data <- site |>
    rvest::html_elements(".past_weather_express") |>
    rvest::html_text() |>
    stringr::str_extract("High: [0-9\\.]*") |>
    substring(7) |>
    as.numeric()
  return(highs)
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
#' @export
low_temps_past <- function() {
  site <- rvest::read_html("https://www.localconditions.com/weather-northampton-massachusetts/01060/past.php")
  data <- site |>
    rvest::html_elements(".past_weather_express") |>
    rvest::html_text()|>
    stringr::str_extract("Low: [0-9\\.]*") |>
    substring(6) |>
    as.numeric()
  return(lows)
}

to_fahrenheit <- function(temp, unit = "celsius") {
  if (unit == "celsius") {
    return((temp * 9/5) + 32)
  } else if (unit == "kelvin") {
    return((temp - 273.15) * 9/5 + 32)
  }
}

to_celsius <- function(temp, unit = "fahrenheit") {
  if (unit == "fahrenheit") {
    return((temp - 32) / 9/5)
  } else if (unit == "kelvin") {
    return((temp + 32) * 9/5 - 273.15)
  }
}
