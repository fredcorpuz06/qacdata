context("data_download")

library(qacdata)

test_that(
  "data_download gives useful error message when given incorrect input", {
  expect_error(
    data_download("foo", "var1", "var2"),
    "Downloading data from the dataset foo is not included in this package"
  )
  expect_error(
    data_download("CtTraffic", "var1", "var2"),
    "Unknown column"
  )
  expect_error(
    data_download("FRED", "LNU04027659", "var2"),
    "HTTP error 400"
  )
  expect_error(
    data_download(),
    "missing, with no default"
  )
})

test_that("data_download handles valid input", {
  expect_equal(
    digest::digest(data_download("AddHealth", "H4TR10", "H4CJ5")),
    "6feadcabb2cb062baf2cca5a76fa5e2b"
  )
  expect_equal(
    digest::digest(data_download("FRED", "LNU04027659")),
    "f5e8ea280a06fd818d63395baabec631"
  )
  expect_equal(
    digest::digest(data_download("WDI", "2.0.cov.Sch", "2.0.hoi.Math.pl_2.all", "UIS.GTVP.23.GPV.M")),
    "213fc568a75dab4b0bfddcbbc9aa79e4"
  )
  expect_equal(
    digest::digest(data_download("MarsCrater", "LATITUDE_CIRCLE_IMAGE","NUMBER_LAYERS")),
    "b1111b4483e0423a99e7e3bf7a4a70b8"
  )
  expect_equal(
    digest::digest(data_download("CtTraffic", "Intervention_Location","Intervention_Reason")),
    "5f802fc1fa8dc3d7583e1b4e7ec7be4b"
  )
})
