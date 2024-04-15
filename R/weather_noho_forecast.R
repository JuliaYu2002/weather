#' @title Get data from weather.com
#'
#' @description
#' Get data from weather.com about Northampton, MA weather for the next 10 days
#'
#' @importFrom rvest read_html
#' @importFrom rvest html_elements
#' @importFrom rvest html_text
#' @importFrom stringr str_extract
#'
#' @export
#'
weather_noho <- function() {
  weather_data <- rvest::read_html("https://weather.com/weather/tenday/l/8a8df2c2297bffb63bf3fc70a45fd88e10152b88363a57940cb501eb7d2f8094")
  weather_trim <- weather_data |>
    rvest::html_elements(".DetailsSummary--lowTempValue--2tesQ , .DetailsSummary--highTempValue--3PjlX, .DetailsSummary--precip--1a98O, .DetailsSummary--extendedData--307Ax, .DetailsSummary--daypartName--kbngc") |>
    rvest::html_text()

  df <- as.data.frame(split(weather_trim, seq(from= 1, to = length(weather_trim), by = length(weather_trim) / 6)))
  names(df) <- c("day", "status", "high", "low", "precipitation chance", "wind")

  df[["high"]] <- as.numeric(stringr::str_extract(df[["high"]], "[:digit:]*"))
  df[["low"]] <- as.numeric(stringr::str_extract(df[["low"]], "[:digit:]*"))

  df["precipitation type"] <- stringr::str_extract(df[[5]], "[:alpha:]*(?=[:digit:]*%)")
  df["precipitation chance"] <- as.numeric(stringr::str_extract(df[[5]], "(?<=[:alpha:])[:digit:]*(?=%)"))
  df["wind speed"] <- as.numeric(stringr::str_extract(df[["wind"]], "(?<=(N|E|W|S) )[:digit:]*"))
  df["wind direction"] <- stringr::str_extract(df[["wind"]], "(?<=Wind)[:upper:]*(?= [:digit:])")

  df <- df[, c("day", "status", "high", "low", "precipitation type", "precipitation chance", "wind direction", "wind speed")]
  return(df)
}
