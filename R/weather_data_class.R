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
    "city" = df$City[[1]],
    "state" = df$State[[1]],
    "zip" = df$Zipcode[[1]],
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
  if (!is.numeric(attr(obj, "wind_speed"))) {
    stop("Wind speed data must be numeric.")
  }

  return(obj)
}

to_hi_lo_temp <- function(weather_data) {
  if (attr(weather_data, "class") != "weather_data") {
    stop("Input must be of class weather_data.")
  }
  validate_weather_data(weather_data)
  return(hi_lo_temp(attr(weather_data, "highs"), attr(weather_data, "lows"), as.Date(as.numeric(weather_data)), c(attr(weather_data, "city"), attr(weather_data, "state"), attr(weather_data, "zip"))))
}