# new folder in the data repository
usethis::use_data_raw(name = "USweather")

# prepare that the `USweather`dataset goes into this folder
# read the file
USweather <- read.csv("data/USweather.csv")

# Save the data frame to the folder
usethis::use_data(USweather, overwrite = TRUE)
