northampton_forecast_data <- weather_noho()

test_that("correct column number", {
  expect_equal(length(northampton_forecast_data), 11)
})

test_that("correct row number", {
  expect_equal(length(northampton_forecast_data[[1]]), 15)
})

test_that("correct column names", {
  expect_named(northampton_forecast_data, c("Day", "Date", "Status", "High", "Low",
                                            "Precipitation Type", "Precipitation Chance",
                                            "Wind Direction", "Wind Speed", "City", "State"))
})

test_that("highs are doubles", {
  expect_type(northampton_forecast_data[["High"]], "double")
})

test_that("lows are doubles", {
  expect_type(northampton_forecast_data[["Low"]], "double")
})
