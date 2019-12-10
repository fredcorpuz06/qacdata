
DATASETS <- c("FRED", "WDI", "AddHealth", "MarsCrater", "CtTraffic")
FRED_KEYS <- c(
  "6e1cfa1262aee2287675ddd319354efb",
  "f8a0e2680c094aba542e0fd6fed8ed98")



# dataset, col_id, description, notes

#' @import dplyr
#' @export
data_search <- function(.search_str, .datasets = DATASETS, .view_meta = FALSE){
  map_df(.datasets, ~ single_data_search_(.search_str, .dataset = .x))
}

# data_search("education", c("FRED", "WDI"))
# data_search("birth", "AddHealth")


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

# data_search_FRED_("education")

#' @import stringr
data_search_WDI_ <- function(.search_str){
  qacdata::wdi_indicators %>%
    filter(str_detect(search_text, .search_str)) %>%
    mutate(description = str_trim(description)) %>%
    select(-search_text)
}

# data_search_WDI_("poverty")

#' @import stringr
data_search_AddHealth_ <- function(.search_str){
  qacdata::addhealth_codebook %>%
    filter(survey == "W4") %>%
    filter(str_detect(description, .search_str)) %>%
    select(-survey)
}

# data_search_AddHealth_("birth")

#' @import stringr
data_search_MarsCrater_ <- function(.search_str){
  qacdata::marscrater_codebook %>%
    filter(str_detect(description, .search_str))

}

# data_search_MarsCrater_("texture")

data_search_CtTraffic_ <- function(.search_str){

}


funs_search <- list(
  data_search_FRED_,
  data_search_WDI_,
  data_search_AddHealth_,
  data_search_MarsCrater_,
  data_search_CtTraffic_)
funs_search <- setNames(funs_search, DATASETS)



#' @import dplyr
single_data_search_ <- function(.search_str, .dataset){
  if(!(.dataset %in% DATASETS)){
    stop(paste(
      "Searching within the dataset", .dataset ,
      "is not included in this package"))
  }

  fun <- funs_search[[.dataset]]
  df <- fun(.search_str)
  df %>%
    mutate(dataset = .dataset) %>%
    select(dataset, col_id, description, notes)

}

# single_data_search_("education", "FRED")
