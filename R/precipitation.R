#' @title Precipitation class
#' @description
#' A class that contains vectors for the precipitation for a series of dates at a particular location
#' @param precipitation Numeric vector of precipitation inches
#' @param dates Numeric vector of dates
#' @param location Character vector containing city, state, and zip code
#' @return An object of class precipitation
#' @export
precipitation <- function(precipitation, dates, location) {
  pre_obj <- new_precip_data(precipitation, dates, location) |>
    validate_precip_data()
  return(pre_obj)
}

#' @title Constructor for the Precipitation class
#' @description
#' Creates a class that contains vectors for the precipitation for a series of dates at a particular location.
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
#' @description
#' Validates a class that holds vectors for the precipitation data for a series of dates at a particular location
#' @param obj Object of class precipitation
#' @return An object of class precipitation
validate_precip_data <- function(pre_obj) {
  if (attr(pre_obj, "precipitation") < 0) {
    stop("Precipitation cannot be negative.")
  }
  if (attr(pre_obj, "precipitation") > 100) {
    warning("It seems highly unlikely that there was more than 100 inches of precipitation in one day.")
  }
  return(pre_obj)
}

#' @title Retrieve past precipitation data
#' @description
#' Scrapes www.localconditions.com for the past precipitation data
#' @param city A character vector of the city name
#' @param state A character vector of the state name
#' @param zip A character vector of the zip code of the city
#' @return An object of class precipitation
#' @export
past_precipitation <- function(city = "new-york", state = "new-york", zip = "10001") {
  url <- rvest::read_html(paste0("https://www.localconditions.com/weather-", city, "-", state, "/", zip, "/past.php"))

  # Extract date and reformat
  dates <- url |>
    rvest::html_elements(".accordion-toggle") |>
    rvest::html_text()
  dates <- stringr::str_extract(dates, "\\w+, \\w+ \\d{1,2}(?:st|nd|rd|th)?")
  dates <- as.Date(dates, format="%A, %B %d")
  dates <- format(dates, "%Y-%m-%d")

  # Extract Precipitation Data
  precipitation <- url |>
    rvest::html_elements(".past_weather_express") |>
    rvest::html_text() |>
    stringr::str_extract("Total: [0-9\\.]*") |>
    substring(7)
  precipitation <- ifelse(precipitation == " ", "0", precipitation)

  # Create precipitation object
  pre_obj <- precipitation(as.numeric(precipitation), dates, c(city, state, zip))

  return(pre_obj)
}

#' @title Plot past precipitation
#' @description
#' Graphs past precipitation for the given dates
#' @param pre_obj An object of class precipitation
#' @exportS3Method
plot.precipitation <- function(pre_obj) {
  precip_df <- data.frame(Date = as.Date(as.numeric(pre_obj)), Precipitation = attr(pre_obj, "precip"))

  # Convert Date to Date type and Precipitation to numeric
  # precip_df$Date <- as.Date(precip_df$Date, format="%Y-%m-%d")
  # precip_df$Precipitation <- as.numeric(precip_df$Precipitation)

  # Complete the sequence of dates and fill missing values with 0
  # precip_df <- precip_df |>
  #   tidyr::complete(Date = seq(min(Date), max(Date), by = "day"), fill = list(Precipitation = 0))

  ggplot2::ggplot(data = precip_df,
                  ggplot2::aes(x = as.Date(Date),
                               y = Precipitation)) +
    ggplot2::geom_bar(stat = "identity", fill = "blue", width = 0.5) +
    ggplot2::scale_x_date(date_breaks = "1 day", date_labels = "%Y-%m-%d") +
    ggplot2::xlab("Date") +
    ggplot2::ylab("Precipitation (inches)") +
    ggplot2::ggtitle(paste0("Past Precipitation in ",
                            stringr::str_to_title(attr(pre_obj, "city")),
                            ", ",
                            stringr::str_to_title(attr(pre_obj, "state")))) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90))
}


