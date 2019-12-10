library(tidyverse)
library(rvest)

URL <- "https://www.cpc.unc.edu/projects/addhealth/documentation/ace/tool/codebookssearch?field=varname&match=contains&text="

page <- read_html(URL)

fix_names <- function(x) gsub("[ ]", "_", tolower(x))


rows <- page %>%
  html_nodes("table#searchresults > tbody > tr")
instruments <- rows %>%
  html_node("td:nth-child(1)") %>%
  html_text()
variables <- rows %>%
  html_node("td:nth-child(2)") %>%
  html_text()
questions_text <- rows %>%
  html_node("td:nth-child(3)") %>%
  html_text()


# Takes ~ 20 minutes to run
questions_response <- rows %>%
  html_node("td:last-child > table#search") %>%
  html_table() %>%
  map(as_tibble, .name_repair = fix_names)


addhealth_codebook <- tibble(survey = instruments,
                             col_id = variables,
                             description = questions_text,
                             notes = questions_response)

# addhealth_codebook <- readRDS("../qacdata-2/data/addhealth_codebook.rds") %>%
#   rename(col_id = var, description = ques_text, notes = ques_resp)
usethis::use_data(addhealth_codebook, overwrite = TRUE)
