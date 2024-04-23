USweather <- utils::read.csv("USweather.csv")

names(USweather) <- c("Precipitation", "Date", "Month", "Week", "Year", "City", "Station Code", "Location", "State", "Avg. Temp", "High", "Low", "Wind Direction", "Wind Speed")

usethis::use_data(USweather, overwrite = TRUE)
