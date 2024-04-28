#' @title Get data from weather.com
#'
#' @description Get data from weather.com about Northampton, MA weather for the next 14 days
#'
#' @importFrom rvest read_html
#' @importFrom rvest html_elements
#' @importFrom rvest html_text
#' @importFrom stringr str_extract
#'
#' @return Returns a data frame with the following columns:
#' - Day (character): day of the week and the day of the month
#' - Date (Date): a Date formatted version of Day
#' - Status (character): conditions outside (ex. rainy, cloudy, sunny)
#' - High (numeric): the peak temperature predicted to be reached
#' - Low (numeric): the coolest the day is predicted to be
#' - Precipitation Type (character): what type of precipitation (ex. rain, snow)
#' - Precipitation Chance (numeric): chances that it will rain, snow, etc
#' - Wind Direction (character): the direction that the wind is blowing
#' - Wind Speed (numeric): how fast the wind is blowing
#'
#' @source
#' <https://weather.com/weather/tenday/l/8a8df2c2297bffb63bf3fc70a45fd88e10152b88363a57940cb501eb7d2f8094>
#'
#' @examples
#' forecast <- weather_noho()
#' @export
weather_noho <- function() {
  weather_data <- rvest::read_html("https://weather.com/weather/tenday/l/8a8df2c2297bffb63bf3fc70a45fd88e10152b88363a57940cb501eb7d2f8094")
  weather_trim <- weather_data |>
    rvest::html_elements(".DetailsSummary--lowTempValue--2tesQ , .DetailsSummary--highTempValue--3PjlX, .DetailsSummary--precip--1a98O, .DetailsSummary--extendedData--307Ax, .DetailsSummary--daypartName--kbngc") |>
    rvest::html_text()

  df <- as.data.frame(split(weather_trim, seq(from= 1, to = length(weather_trim), by = length(weather_trim) / 6)))
  names(df) <- c("Day", "Status", "High", "Low", "Precipitation Chance", "Wind")

  df[["High"]] <- as.numeric(stringr::str_extract(df[["High"]], "[:digit:]*"))
  df[["Low"]] <- as.numeric(stringr::str_extract(df[["Low"]], "[:digit:]*"))

  df["Precipitation Type"] <- stringr::str_extract(df[["Precipitation Chance"]], "[:alpha:]*(?=[:digit:]*%)")
  df["Precipitation Chance"] <- as.numeric(stringr::str_extract(df[["Precipitation Chance"]], "(?<=[:alpha:])[:digit:]*(?=%)"))
  df["Wind Speed"] <- as.numeric(stringr::str_extract(df[["Wind"]], "(?<=(N|E|W|S) )[:digit:]*"))
  df["Wind Direction"] <- stringr::str_extract(df[["Wind"]], "(?<=Wind)[:upper:]*(?= [:digit:])")
  df["Date"] <- Sys.Date() + (seq(0:14) - 1)

  df["City"] <- "Northampton"
  df["State"] <- "Massachusetts"

  df <- df[, c("Day", "Date", "Status", "High", "Low", "Precipitation Type", "Precipitation Chance", "Wind Direction", "Wind Speed", "City", "State")]
  class(df) <- c("weather", "data.frame")
  return(df)
}
