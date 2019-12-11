#' @import dplyr
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

#' @import dplyr
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
