#' @title Data download by column names
#' @description Download columns from supported datasets
#' @param dataset a string. Values must be one of the following supported
#'   datasets: \code{FRED}, \code{WDI}, \code{AddHealth}, \code{MarsCrater},
#'   \code{CtTraffic}
#' @param ... strings of \emph{col_id}'s found with \code{\link{data_search}}
#' @return A dataframe w/ the input \emph{col_id}'s as columns with the
#'   appropriate metadata
#' @examples
#' data_download("FRED", "LNU04027659", "G160291A027NBEA")
#' data_download("WDI", "1.0.PSev.1.90usd", "SP.PRM.TOTL.FE.IN")
#' data_download("AddHealth", "H4TR10", "H4CJ5")
#' data_download("CtTraffic", "Intervention_Date","Contraband")
#' @rdname data_download
#' @export
data_download <- function(dataset, ...){
  if(!(dataset %in% DATASETS)){
    stop(paste(
      "Downloading data from the dataset", dataset ,
      "is not included in this package"))
  }

  fun <- funs_download[[dataset]]
  fun(...)

}

#' @import dplyr
#' @importFrom lubridate as_date
#' @importFrom jsonlite fromJSON
#' @importFrom purrr reduce
#' @importFrom dplyr full_join
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
    rez <- as_tibble(json$observations) %>%
      select(date, value) %>%
      mutate(date = as_date(date),
             value = as.numeric(value))

    colnames(rez)[2] <- dot
    rez
  }
  map(dots, download_one) %>%
    reduce(full_join, by = "date")
}


#' @importFrom janitor clean_names
#' @importFrom jsonlite fromJSON
#' @importFrom purrr reduce
#' @importFrom dplyr full_join
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

    ## TODO: implement a trycatch here
    json_flat <- fromJSON(req, flatten = TRUE)[[2]]

    rez <- json_flat %>%
      clean_names() %>%
      as_tibble() %>%
      select(year = date, country = country_value, value) %>%
      filter(!str_detect(year, "Target")) %>%
      mutate_at(vars(year, value), as.numeric)
    colnames(rez)[3] <- dot
    rez
  }

  map(dots, download_one) %>%
    reduce(full_join, by = c("year", "country"))
}

data_download_AddHealth_ <- function(...){
  qacdata::addhealth %>%
    select(...)
}

data_download_MarsCrater_ <- function(...){
  qacdata::marscrater %>%
    select(...)
}

data_download_CtTraffic_ <- function(...){
  qacdata::cttraffic %>%
    select(...)
}

funs_download <- list(
  data_download_FRED_,
  data_download_WDI_,
  data_download_AddHealth_,
  data_download_MarsCrater_,
  data_download_CtTraffic_
)

DATASETS <- c("FRED", "WDI", "AddHealth", "MarsCrater", "CtTraffic")
funs_download <- setNames(funs_download, DATASETS)

