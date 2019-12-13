context("data_search")

library(qacdata)

test_that(
  "data_search gives useful error message when given incorrect input", {
  expect_error(
    data_search("education", "foo"),
    "Searching within the dataset foo is not included in this package"
  )
  expect_error(
    data_search("poverty", c("WDI", "foo")),
    "Searching within the dataset foo is not included in this package"
  )
  expect_message(
    data_search("asdf", "WDI"),
    "asdf doesn't match any values in the selected datasets"
  )
})


test_that("data_search handles valid input", {
  expect_equal(
    digest::digest(data_search("birth", "AddHealth")),
    "2a4fd793a40ce4eb34c6fe386a1f4049"
  )
  expect_equal(
    digest::digest(data_search("birth", c("AddHealth", "WDI"))),
    "17a9e226662f32af78cfd97a8d03ac47"
  )
  expect_equal(
    digest::digest(data_search("wages","WDI")),
    "d3d6d7bba4c31f39b2c55a33af8b2a00"
  )
  expect_equal(
    digest::digest(data_search("longitude","MarsCrater")),
    "917c6f4bf6a497be9d81ae94a64e92d5"
  )
  expect_equal(
    digest::digest(data_search("speed","CtTraffic")),
    "681bb1d4e0197d0a2b3715e3a775e8ce"
  )
})
