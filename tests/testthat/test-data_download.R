context("data_download: download specified variables from dataset")

library(qacdata)

test_that(
  "data_download gives useful error message when given incorrect input", {
  expect_error(
    data_download("foo", "var1", "var2"),
    "Downloading data from the dataset foo is not included in this package"
  )
  expect_error(
    data_download("FRED", "var1", "var2"),
    "var1 not found in dataset FRED"
  )
  expect_error(
    data_download("FRED", "LNU04027659", "var2"),
    "var2 not found in dataset FRED"
  )
  expect_error(
    data_download("FRED"),
    "No col_id's specified"
  )
  expect_error(
    data_download(),
    "No dataset specified"
  )
})

test_that("data_download handles valid input", {
  expect_equal(
    digest::digest(data_download("AddHealth", "H4TR10", "H4CJ5")),
    "6feadcabb2cb062baf2cca5a76fa5e2b"
  )
  expect_equal(
    digest::digest(data_download("FRED", "LNU04027659")),
    "875ff5efffb1a8aa1af8901438ef005d"
  )

})
