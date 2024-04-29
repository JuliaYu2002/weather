past_noho_weather <- past_days()

test_that("correct column number", {
  expect_equal(length(past_noho_weather), 6)
})

test_that("correct row number", {
  expect_equal(length(past_noho_weather[[1]]), 26)
})

test_that("throw url error", {
  expect_error(past_days("new york city", "new york", "10028"))
})

test_that("don't throw url error", {
  expect_no_error(past_days("new-york-city", "new-york", "10028"))
})
