last_month <- function(state, city) {
  site <- rvest::read_html(paste0("https://www.wunderground.com/history/monthly/us/",state,"/", city, "/yesterday"))
  site |>
    rvest::html_elements(".summary-table")
}
