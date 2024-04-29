#' @title Precipitation class
#' @description A class that contains vectors for the precipitation for a series of dates at a
#' particular location
#' @param precipitation Numeric vector of precipitation inches
#' @param dates Numeric vector of dates
#' @param location Character vector containing city, state, and zip code
#' @return An object of class precipitation
#' @examples
#' precipitation(0.01, Sys.Date(), c("Northampton", "MA"))
#' @export
precipitation <- function(precipitation, dates, location) {
  pre_obj <- new_precip_data(precipitation, dates, location) |>
    validate_precip_data()
  return(pre_obj)
}

#' @title Constructor for the Precipitation class
#' @description Creates a class that contains vectors for the precipitation for a series of dates at
#' a particular location.
#' @param precipitation Numeric vector of precipitation amounts
#' @param dates Numeric vector of dates
#' @param location Character vector containing city, state, and zip code
#' @return An object of class precipitation
new_precip_data <- function(precipitation, dates, location) {
  structure(
    as.Date(as.numeric(dates)),
    "precip" = precipitation,
    "city" = location[1],
    "state" = location[2],
    class = "precipitation"
  )
}

#' @title Validator for Precipitation class
#' @description Validates a class that holds vectors for the precipitation data for a series of
#' dates at a particular location
#' @param pre_obj Object of class precipitation
#' @return An object of class precipitation
validate_precip_data <- function(pre_obj) {
  if (any(attr(pre_obj, "precip") < 0)) {
    stop("Precipitation cannot be negative.")
  }
  if (any(attr(pre_obj, "precip") > 100)) {
    warning("It seems highly unlikely that there was more than 100 inches of precipitation in one day.")
  }
  return(pre_obj)
}

#' @title Plot past precipitation
#' @description Graphs past precipitation for the given dates
#' @param x An object of class precip_class generated from function past_precipitation
#' @param ... Additional parameters
#' @examples
#' pastprecip <- precipitation(c(0.01, 0, 0.04, 0),
#' seq(Sys.Date()-3, Sys.Date(), by="days"), c("Northampton","Massachusetts"))
#' plot(pastprecip)
#' @exportS3Method
plot.precipitation <- function(x, ...) {
  precip_df <- data.frame(Date = as.Date(as.numeric(x)), Precipitation = attr(x, "precip"))

  ggplot2::ggplot(data = precip_df,
                  ggplot2::aes(x = as.Date(Date),
                               y = Precipitation)) +
    ggplot2::geom_bar(stat = "identity", fill = "blue", width = 0.5) +
    ggplot2::scale_x_date(date_breaks = paste(ceiling(length(x)/7), "day"), date_labels = "%Y-%m-%d") +
    ggplot2::xlab("Date") +
    ggplot2::ylab("Precipitation (inches)") +
    ggplot2::ggtitle(paste0("Past Precipitation in ",
                            stringr::str_to_title(attr(x, "city")),
                            ", ",
                            stringr::str_to_title(attr(x, "state")))) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90))
}


