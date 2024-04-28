nyc <- USweather[USweather$City=="New York", ]

test_that("weather_data class can be successfully created from scratch", {
  expect_s3_class(weather_data(nyc), "weather_data")
})

test_that("weather_data class must have vectors of the same length", {
  bad_nyc <- nyc
  bad_nyc$`Wind Speed` <- as.character(bad_nyc$`Wind Speed`)
  expect_error(weather_data(bad_nyc), "Wind speed data must be numeric.")
})

test_that("weather_data class can be converted to hi_lo_temp class", {
  expect_s3_class(to_hi_lo_temp(weather_data(nyc)), "hi_lo_temp")
})

test_that("to_hi_lo_temp only accepts weather_data class", {
  expect_error(to_hi_lo_temp(unclass(weather_data(nyc))), "Input must be of class weather_data.")
})

test_that("weather_data class can be converted to precipitation class", {
  expect_s3_class(to_precipitation(weather_data(nyc)), "precipitation")
})

test_that("precipitation only accepts weather_data class", {
  expect_error(to_precipitation(unclass(weather_data(nyc))), "Input must be of class weather_data.")
})
