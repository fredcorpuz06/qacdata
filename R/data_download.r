DATASETS <- c("FRED", "WDI", "AddHealth", "MarsCrater", "CtTraffic")
FRED_KEYS <- c(
  "6e1cfa1262aee2287675ddd319354efb",
  "f8a0e2680c094aba542e0fd6fed8ed98")



#' @export
# data_download("FRED", "LNU04027659", "G160291A027NBEA")
# data_download(.dataset = "AddHealth", "H4TR10", "H4CJ5")
data_download <- function(.dataset, ...){
  if(!(.dataset %in% DATASETS)){
    stop(paste(
      "Downloading data from the dataset", .dataset ,
      "is not included in this package"))
  }

  fun <- funs_download[[.dataset]]
  fun(...)

}

#' @import dplyr
#' @importFrom lubridate as_date
# data_download_FRED_("LNU04027659", "G160291A027NBEA")
data_download_FRED_ <- function(...){
  dots <- list(...)
  FILE_TYPE <- "json"
  API_BASE <- "https://api.stlouisfed.org/fred/series/observations"

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

  download_one <- function(dot){
    a <- paste0(PARAMS$api_key, sample(FRED_KEYS, size = 1))
    s <- paste0(PARAMS$series_id, dot)
    f <- paste0(PARAMS$file_type, FILE_TYPE)
    req <- paste0(API_BASE, a, s, f)
    json <- fromJSON(req)
    as_tibble(json$observations) %>%
      select(date, value) %>%
      mutate(date = as_date(date),
             value = as.numeric(value))
  }
  map(dots, download_one)
}


#' @importFrom janitor clean_names
# data_download_WDI_("1.0.PSev.1.90usd", "SP.PRM.TOTL.FE.IN")[[1]] %>% View
data_download_WDI_ <- function(...){
  dots <- list(...)
  API_BASE <- "http://api.worldbank.org/countries/all/indicators"
  PARAMS <- list("format", "per_page", "date")
  PARAMS_DEFAULTS <- list("?format=json", "&per_page=25000", "&date=1950:2019")
  PARAMS_DEFAULTS <- setNames(PARAMS_DEFAULTS, PARAMS)
  download_one <- function(dot){
    url <- paste0(API_BASE, "/", dot)
    params <- paste0(PARAMS_DEFAULTS, collapse = "")
    req <- paste0(url, params, collapse = "")

    fromJSON(req, flatten = TRUE)[[2]] %>%
      clean_names() %>%
      as_tibble()
      # select(date, iso2code = country_id, country = country_value, value) %>%
      # filter(!str_detect(date, "Target")) %>%
      # mutate_at(vars(date, value), as.numeric)

  }


  map(dots, download_one)
}

data_download_AddHealth_ <- function(...){
  qacdata::addhealth %>%
    select(...)
}

# data_download_AddHealth_("H4TR10", "H4CJ5")

data_download_MarsCrater_ <- function(...){
  qacdata::marscrater %>%
    select(...)
}

# data_download_MarsCrater_("DIAM_CIRCLE_IMAGE")

data_download_CtTraffic_ <- function(...){

}

funs_download <- list(
  data_download_FRED_,
  data_download_WDI_,
  data_download_AddHealth_,
  data_download_MarsCrater_,
  data_download_CtTraffic_
)
funs_download <- setNames(funs_download, DATASETS)

