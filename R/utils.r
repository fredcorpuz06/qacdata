#' @title Get variable description
#' @description Find the text description of variables from supported datasets
#' @param search_result a dataframe result from \code{\link{data_search}}
#' @param col_id a string of \emph{col_id} found with \code{\link{data_search}}
#' @return a string
#' @import dplyr
#' @examples
#' data_search("birth", "AddHealth") %>%
#'   get_description("H4TR10")
#' @rdname get_description
#' @export
get_description <- function(search_result, col_id){
  description_df <- search_result %>%
    rename(var = col_id) %>%
    filter(var == col_id)

  n <- nrow(description_df)
  if(n == 0){
    stop(paste("The variable", col_id, "is not found in your search results"))
  } else if(n == 1){
    pull(description_df, description)
  } else {
    stop(
      paste("The variable", col_id, "is not distinct in your search results")
    )
  }

}



#' @title Get variable note
#' @description Find the metadata of variables from chosen dataset
#' @param search_result a dataframe result from \code{\link{data_search}}
#' @param col_id a string of \emph{col_id} found with \code{\link{data_search}}
#' @return a dataframe
#' @import dplyr
#' @examples
#' data_search("birth", "AddHealth") %>%
#'   get_note("H4TR10")
#' @rdname get_note
#' @export
get_note <- function(search_result, col_id){
  note_df <- search_result %>%
    rename(var = col_id) %>%
    filter(var == col_id)

  n <- nrow(note_df)
  if(n == 0){
    stop(paste("The variable", col_id, "is not found in your search results"))
  } else if(n == 1){
    pull(note_df, notes)[[1]]
  } else {
    stop(
      paste("The variable", col_id, "is not distinct in your search results")
    )
  }
}


DATASETS <- c("FRED", "WDI", "AddHealth", "MarsCrater", "CtTraffic")
FRED_KEYS <- c(
  "6e1cfa1262aee2287675ddd319354efb",
  "f8a0e2680c094aba542e0fd6fed8ed98"
)
