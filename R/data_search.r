#' @title Data search by keyword
#' @description Find columns in supported datasets that relate to keyword
#' @param search_str a string, case insensitive
#' @param datasets a vector of the selected datasets to search. Values must be
#'   in of the following supported datasets: \code{FRED}, \code{WDI},
#'   \code{AddHealth}, \code{MarsCrater}, \code{CtTraffic}. Defaults to
#'   searching all supported datasets.
#' @importFrom purrr map_df
#' @return A dataframe w/ columns - \code{dataset}, \code{col_id},
#'   \code{description}, \code{notes}
#' @examples
#' data_search("birth")
#' data_search("birth", "AddHealth")
#' data_search("birth", c("AddHealth", "MarsCrater"))
#' @rdname data_search
#' @export
data_search <- function(search_str, datasets = DATASETS){
  map_df(datasets, ~ single_data_search_(search_str, .dataset = .x))
}

#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom purrr map
#' @importFrom stringr str_trim
#' @importFrom tidyr nest
data_search_FRED_ <- function(.search_str){
  FILE_TYPE <- "json"
  API_BASE <- "https://api.stlouisfed.org/fred/series/search"
  PARAMS <- list(
    "api_key", "file_type", "search_text",
    "search_type", "realtime_start", "series_id")

  format_params <- function(.param){
    if(.param == "api_key"){
      paste0("?", .param, "=", collapse = NULL)
    } else {
      paste0("&", .param, "=", collapse = NULL)
    }
  }

  PARAMS <- setNames(PARAMS, PARAMS) %>% map(format_params)

  # Form request URL to FRED API
  a <- paste0(PARAMS$api_key, sample(FRED_KEYS, size = 1))
  f <- paste0(PARAMS$file_type, FILE_TYPE)
  s <- str_replace_all(.search_str, "[:blank:]", "+") %>%
    paste0(PARAMS$search_text, .)

  req <- paste0(API_BASE, a, f, s)
  json_raw <- jsonlite::fromJSON(req)
  json_raw$seriess %>%
    select(col_id = id, description = title, notes) %>%
    mutate(notes = str_trim(notes)) %>%
    nest(notes, .key = "notes")
}

#' @import stringr
data_search_WDI_ <- function(.search_str){
  qacdata::wdi_indicators %>%
    filter(str_detect(search_text, fixed(.search_str, ignore_case = TRUE))) %>%
    mutate(description = str_trim(description)) %>%
    select(-search_text)
}

#' @import stringr
data_search_AddHealth_ <- function(.search_str){
  qacdata::addhealth_codebook %>%
    filter(survey == "W4") %>%
    filter(str_detect(description, fixed(.search_str, ignore_case = TRUE))) %>%
    select(-survey)
}

#' @import stringr
data_search_MarsCrater_ <- function(.search_str){
  qacdata::marscrater_codebook %>%
    filter(str_detect(description, fixed(.search_str, ignore_case = TRUE)))
}

#' @import stringr
data_search_CtTraffic_ <- function(.search_str){
  qacdata::cttraffic_codebook %>%
    filter(str_detect(description, fixed(.search_str, ignore_case = TRUE)))
}


funs_search <- list(
  data_search_FRED_,
  data_search_WDI_,
  data_search_AddHealth_,
  data_search_MarsCrater_,
  data_search_CtTraffic_)

DATASETS <- c("FRED", "WDI", "AddHealth", "MarsCrater", "CtTraffic")
funs_search <- setNames(funs_search, DATASETS)

#' @import dplyr
single_data_search_ <- function(.search_str, .dataset){
  if(!(.dataset %in% DATASETS)){
    stop(paste(
      "Searching within the dataset", .dataset ,
      "is not included in this package"
    ))
  }

  fun <- funs_search[[.dataset]]
  df <- fun(.search_str)
  rez <- df %>%
    mutate(dataset = .dataset) %>%
    select(dataset, col_id, description, notes)

  if(nrow(df) == 0){
    message(paste(
      .search_str, "doesn't match any values in the selected datasets"
    ))
    return(tibble())
  } else {
    rez
  }

}
