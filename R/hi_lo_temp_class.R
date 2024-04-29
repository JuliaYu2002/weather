#' @title High/low temperature class
#' @description A class that holds vectors for the high and low temperatures for a series of dates
#'   at a particular location
#' @param highs Numeric vector of high temperatures
#' @param lows Numeric vector of low temperatures
#' @param dates Numeric vector of high temperatures
#' @param location Character vector containing city, state, and zip code
#' @return An object of class hi_lo_temp
#' @export
hi_lo_temp <- function(highs, lows, dates, location) {
  obj <- new_hi_lo_temp(highs, lows, dates, location) |>
    validate_hi_lo_temp()
  return(obj)
}

#' @title Constructor for high/low temperature class
#' @description Creates a class that holds vectors for the high and low temperatures for a series of
#'   dates at a particular location
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
    class = "hi_lo_temp"
  )
}

#' @title Validator for high/low temperature class
#' @description Validates a class that holds vectors for the high and low temperatures for a series
#'   of dates at a particular location
#' @param obj A [`hi_lo_temp()`] object to be validated
#' @return An object of class hi_lo_temp
validate_hi_lo_temp <- function(obj) {
  if (!is.numeric(attr(obj, "highs")) | !is.numeric(attr(obj, "lows"))) {
    stop("Temperature data must be numeric.")
  }
  if (!is.character(attr(obj, "city")) | !is.character(attr(obj, "state"))) {
    stop("Location information must be character.")
  }
  if (length(obj) != length(attr(obj, "highs")) | length(obj) != length(attr(obj, "lows"))) {
    stop("Vectors for dates, highs, and lows must be the same length.")
  }
  if (any(attr(obj, "highs") < attr(obj, "lows") & !is.na(attr(obj, "highs")) & !is.na(attr(obj, "lows")))) {
    stop("High temperature cannot be less than low temperature for any given day.")
  }
  return(obj)
}

#' @title Graph high and low temperatures
#' @description Graphs high and low temperatures from the past several days
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 xlab
#' @importFrom ggplot2 ylab
#' @importFrom ggplot2 ggtitle
#' @importFrom stringr str_to_title
#' @param x A [`hi_lo_temp()`] object
#' @param ... Additional parameters
#' @exportS3Method
plot.hi_lo_temp <- function(x, ...) {
  df <- data.frame(dates = as.Date(as.numeric(x)), highs = attr(x, "highs"), lows = attr(x, "lows"))
  ggplot2::ggplot() +
    ggplot2::geom_line(data = df, mapping = ggplot2::aes(x = dates, y = highs)) +
    ggplot2::geom_line(data = df, mapping = ggplot2::aes(x = dates, y = lows)) +
    ggplot2::xlab("Date") +
    ggplot2::ylab(paste0("High and Low Temp (Fahrenheit)")) +
    ggplot2::ggtitle(paste0("Weather in ", stringr::str_to_title(attr(x, "city")), ", ", stringr::str_to_title(attr(x, "state")))) +
    ggplot2::scale_x_date(date_breaks = paste(ceiling(length(x)/7), "day"), date_labels = "%Y-%m-%d") +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90))
}
