test_that("correct column number", {
  northampton_forecast_data <- weather_noho()

  expect_equal(length(northampton_forecast_data), 11)
})

test_that("correct row number", {
  northampton_forecast_data <- weather_noho()

  expect_equal(length(northampton_forecast_data[[1]]), 15)
})

test_that("correct column names", {
  northampton_forecast_data <- weather_noho()

  expect_named(northampton_forecast_data, c("Day", "Date", "Status", "High", "Low", "Precipitation
  Type", "Precipitation Chance", "Wind Direction", "Wind Speed", "City", "State"))
})

test_that("highs are numeric", {
  northampton_forecast_data <- weather_noho()

  expect_type(northampton_forecast_data[["High"]], "numeric")
})

test_that("lows are numeric", {
  northampton_forecast_data <- weather_noho()

  expect_type(northampton_forecast_data[["Low"]], "numeric")
})
