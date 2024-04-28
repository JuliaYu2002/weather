nyc <- USweather[USweather$City=="New York", ]

test_that("precipitation class can be successfully created from scratch", {
  expect_s3_class(precipitation(nyc$Precipitation, as.Date(nyc$Date, format = "%Y/%m/%d"), c("New York", "NY")), "precipitation")
})

test_that("precipitation cannot be negative", {
  expect_error(precipitation(-nyc$Precipitation, as.Date(nyc$Date, format = "%Y/%m/%d"), c("New York", "NY")), "Precipitation cannot be negative.")
})

test_that("precipitation should not be greater than 100 inches", {
  expect_warning(precipitation(nyc$Precipitation + 100, as.Date(nyc$Date, format = "%Y/%m/%d"), c("New York", "NY")), "It seems highly unlikely that there was more than 100 inches of precipitation in one day.")
})

test_that("precipitation plots work", {
  vdiffr::expect_doppelganger(
    title = "New York past data",
    fig = plot(to_precipitation(weather_data(nyc)))
  )
})
