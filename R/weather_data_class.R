#' @title Weather data class
#' @description A class that holds high and low temperature, wind speed, precipitation, and location
#'   for given dates
#' @param df The data frame that holds the data
#' @return An object of the class weather_data
#' @examples
#' weather_data(data.frame("Date" = Sys.Date(), "High" = 70, "Low" = 55, "Wind Speed" = 5, "Precipitation" = 0, City = "Northampton", State = "Massachusetts"))
#' @export
weather_data <- function(df) {
  obj <- new_weather_data(df) |>
    validate_weather_data()
  return(obj)
}

#' @title Constructor for `weather_data` class
#' @description Creates a class that holds vectors for the high and low temperatures, precipitation,
#'   and wind speeds for a series of dates at a given location
#' @param df The data frame that holds the data
#' @examples
#' weather_data(data.frame("Date" = Sys.Date(), "High" = 70, "Low" = 55, "Wind Speed" = 5, "Precipitation" = 0, City = "Northampton", State = "Massachusetts"))
#' @return An object of class weather_data
new_weather_data <- function(df) {
  structure(
    as.Date(df$Date, tryFormats = c("%Y-%m-%d", "%Y/%m/%d")),
    "highs" = df$High,
    "lows" = df$Low,
    "wind_speed" = df[['Wind Speed']],
    "precipitation" = df$Precipitation,
    "city" = df$City[[1]],
    "state" = df$State[[1]],
    class = "weather_data"
  )
}

#' @title Validator for `weather_data` class
#' @description Validates a class that holds high and low temperatures, precipitation, and wind
#'   speed data for a series of dates at a particular location
#' @param obj An object of class weather_data
#' @return An object of class weather_data
#' @examples
#' validate_weather_data(new_weather_data(weather_data(data.frame("Date" = Sys.Date(), "High" = 70, "Low" = 55, "Wind Speed" = 5, "Precipitation" = 0, City = "Northampton", State = "Massachusetts"))))
validate_weather_data <- function(obj) {
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

#' @title Create `hi_lo_temp` from `weather_data`
#' @description Creates an object of high and low temperatures from weather data
#' @param weather_data An object of class `weather_data`
#' @return An object of class `hi_lo_temp`
#' @examples
#' to_hi_lo_temp(weather_data(data.frame("Date" = Sys.Date(), "High" = 70, "Low" = 55, "Wind Speed" = 5, "Precipitation" = 0, City = "Northampton", State = "Massachusetts")))
#' @export
to_hi_lo_temp <- function(weather_data) {
  if (length(attr(weather_data, "class")) < 1 || attr(weather_data, "class") != "weather_data") {
    stop("Input must be of class weather_data.")
  }
  validate_weather_data(weather_data)
  return(hi_lo_temp(attr(weather_data, "highs"), attr(weather_data, "lows"), as.Date(as.numeric(weather_data)), c(attr(weather_data, "city"), attr(weather_data, "state"))))
}

#' @title Create `precipitation` from `weather_data`
#' @description Creates an object of precipitation amount from past weather data
#' @param weather_data An object of class `weather_data`
#' @return An object of class `precipitation`
#' @examples
#' to_precipitation(weather_data(data.frame("Date" = Sys.Date(), "High" = 70, "Low" = 55, "Wind Speed" = 5, "Precipitation" = 0, City = "Northampton", State = "Massachusetts")))
#' @export
to_precipitation <- function(weather_data) {
  if (length(attr(weather_data, "class")) < 1 || attr(weather_data, "class") != "weather_data") {
    stop("Input must be of class weather_data.")
  }
  validate_weather_data(weather_data)
  return(precipitation(attr(weather_data, "precipitation"), as.Date(as.numeric(weather_data)), c(attr(weather_data, "city"), attr(weather_data, "state"))))
}
