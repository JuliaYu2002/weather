#' @title Weather data class
#' @description
#' A class that holds high and low temperature, wind speed, precipitation, and location for given dates
#' @param df The data frame that holds the data
#' @return An object of the class weather_data
#' @export
weather_data <- function(df) {
  obj <- new_weather_data(df) |>
    validate_weather_data()
  return(obj)
}

new_weather_data <- function(df) {
  structure(
    as.Date(as.numeric(df$Date)),
    "highs" = df$High,
    "lows" = df$Low,
    "wind_speed" = df[['Wind Speed']],
    "precipitation" = df$Precipitation,
    "city" = df$City[[1]],
    "state" = df$State[[1]],
    class = "weather_data"
  )
}

#' @importFrom lubridate is.Date
validate_weather_data <- function(obj) {
  #if (!lubridate::is.Date(obj)) {
    #stop("Dates of weather observations must be of type Date.")
  #}
  if (!is.numeric(attr(obj, "highs")) || !is.numeric(attr(obj, "lows"))) {
    stop("Temperature data must be numeric.")
  }
  if (!is.null(attr(obj, "wind_speed")) && !is.numeric(attr(obj, "wind_speed"))) {
    stop("Wind speed data must be numeric.")
  }
  if (!is.null(attr(obj, "precipitation")) && !is.numeric(attr(obj, "precipitation"))) {
    stop("Precipitation data must be numeric.")
  }
  return(obj)
}

to_hi_lo_temp <- function(weather_data) {
  if (attr(weather_data, "class") != "weather_data") {
    stop("Input must be of class weather_data.")
  }
  validate_weather_data(weather_data)
  return(hi_lo_temp(attr(weather_data, "highs"), attr(weather_data, "lows"), as.Date(as.numeric(weather_data)), c(attr(weather_data, "city"), attr(weather_data, "state"))))
}
