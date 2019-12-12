context("utils")

test_that("get_description works", {
  expect_equal(
    data_search("birth", "AddHealth") %>% get_description("H4TR10"),
    "How many live births resulted from (this pregnancy/these pregnancies)?"
  )
  expect_error(
    data_search("birth", "AddHealth") %>% get_description("foo"),
    "The variable foo is not found in your search results"
  )
})

test_that("get_note works", {
  expect_equal(
    data_search("birth", "AddHealth") %>% get_note("H4TR10"),
    data.frame(
      response_value = c(
        0L, 1L, 11L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 96L, 97L, 98L
        ),
      response_label = c(
        "0 live births", "1 live birth", "11 live births", "2 live births",
        "3 live births", "4 live births", "5 live births", "6 live births",
        "7 live births", "8 live births", "refused", "legitimate skip",
        "don't know"
      ),
      frequency = c(
        1544L, 3355L, 3L, 2887L, 1240L, 362L, 97L,
        23L, 10L, 1L, 1L, 6174L, 4L
      ),
      percent = c(
        9.83, 21.37, 0.02, 18.39, 7.9, 2.31, 0.62,
        0.15, 0.06, 0.01, 0.01, 39.32, 0.03
      ),
      stringsAsFactors = FALSE
    )
  )
  expect_error(
    data_search("birth", "AddHealth") %>% get_note("foo"),
    "The variable foo is not found in your search results"
  )
})
