#' @title Precipitation class
#' @description
#' A class that contains vectors for the precipitation for a series of dates at a particular location
#' @param precipitation Numeric vector of precipitation inches
#' @param dates Numeric vector of dates
#' @param location Character vector containing city, state, and zip code
#' @return An object of class precip_class
#'
precip_class <- function(precipitation, dates, location) {
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
#' @return An object of class precip_class
new_precip_data <- function(precipitation, dates, location) {
  structure(
    list(precipitation = precipitation,
         dates = as.Date(dates, format="%Y-%m-%d"),
         city = location[1],
         state = location[2],
         zip = location[3]),
    class = "precip_class"
  )
}

#' @title Validator for Precipitation class
#' @description
#' Validates a class that holds vectors for the precipitation data for a series of dates at a particular location
#' @param obj Object of class precip_class
#' @return An object of class precip_class
validate_precip_data <- function(pre_obj) {
  return(pre_obj)
}

#' @title Retrieve past precipitation data
#' @description
#' Scrapes www.localconditions.com for the past precipitation data
#' @param city A character vector of the city name
#' @param state A character vector of the state name
#' @param zip A character vector of the zip code of the city
#' @return An object of class precip_class
#'
#' @source <https://www.localconditions.com/>
#'
#' @examples
#' past_precipitation(city = "northampton", state = "massachusetts", zip = "01060")
#'
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

  # Create precip_class object
  pre_obj <- precip_class(as.numeric(precipitation), dates, c(city, state, zip))

  return(pre_obj)
}

#' @title Plot past precipitation
#' @description
#' Graphs past precipitation for the given dates
#' @param pre_obj An object of class precip_class generated from function past_precipitation
#'
#' @examples
#' pastprecip <- past_precipitation(city = "northampton", state = "massachusetts", zip = "01060")
#' plot_past_precipitation(pastprecip)
#'
#' @export
plot_past_precipitation <- function(pre_obj) {
  precip_df <- data.frame(Date = pre_obj$dates, Precipitation = pre_obj$precipitation)

  # Convert Date to Date type and Precipitation to numeric
  precip_df$Date <- as.Date(precip_df$Date, format="%Y-%m-%d")
  precip_df$Precipitation <- as.numeric(precip_df$Precipitation)

  # Complete the sequence of dates and fill missing values with 0
  precip_df <- precip_df |>
    tidyr::complete(Date = seq(min(Date), max(Date), by = "day"), fill = list(Precipitation = 0))

  ggplot2::ggplot(data = precip_df,
                  ggplot2::aes(x = as.Date(Date),
                               y = Precipitation)) +
    ggplot2::geom_bar(stat = "identity", fill = "blue", width = 0.5) +
    ggplot2::scale_x_date(date_breaks = "1 day", date_labels = "%Y-%m-%d") +
    ggplot2::xlab("Date") +
    ggplot2::ylab("Precipitation (inches)") +
    ggplot2::ggtitle(paste0("Past Precipitation in ",
                            stringr::str_to_title(pre_obj$city),
                            ", ",
                            stringr::str_to_title(pre_obj$state))) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90))
}


