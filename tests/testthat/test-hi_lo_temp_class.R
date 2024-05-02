nyc <- USweather[USweather$City=="New York", ]

test_that("hi_lo_temp class can be successfully created from scratch", {
  expect_s3_class(hi_lo_temp(nyc$High, nyc$Low, as.Date(nyc$Date, format = "%Y/%m/%d"), c("New York", "NY")), "hi_lo_temp")
})

test_that("high temperatures must be greater than low temperatures", {
  expect_error(hi_lo_temp(nyc$Low, nyc$High, as.Date(nyc$Date, format = "%Y/%m/%d"), c("New York", "NY")), "High temperature cannot be less than low temperature for any given day.")
})

test_that("hi_lo_temp plot works for past data set", {
  vdiffr::expect_doppelganger(
    title = "New York past data",
    fig = plot(to_hi_lo_temp(weather_data(nyc)))
  )
})

test_that("hi_lo_temp plot works for past data webscrapping", {
  vdiffr::expect_doppelganger(
    title = "Weather in Northampton, Ma",
    fig = plot(to_hi_lo_temp(weather_data(past_days("northampton", "ma", "01060"))))
  )
})
