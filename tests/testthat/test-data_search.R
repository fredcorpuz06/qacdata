context("data_search: use text string to search for relevant variables")

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
    ""
  )
  expect_equal(
    digest::digest(data_search("birth")),
    ""
  )
})
