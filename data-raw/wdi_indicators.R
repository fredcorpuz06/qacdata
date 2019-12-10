library(dplyr)
library(purrr)
library(jsonlite)
library(janitor)
library(tidyr)


URL <- "https://api.worldbank.org/v2/indicator?format=json&per_page=25000"
json <- fromJSON(URL, flatten = TRUE)


## TODO: custom paste0 ignoring NA
wdi_indicators <- json[[2]] %>%
  clean_names() %>%
  mutate_all(~ na_if(.x, "NA")) %>%
  mutate_all(~ na_if(.x, "")) %>%
  mutate(topics2 = map(topics, ~ paste0(.$value, collapse = "; "))) %>%
  unnest(topics2) %>%
  mutate(topics2 = na_if(topics2, "")) %>%
  select(col_id = id, description = name, source_note,
         topics = topics2, source_value, source_organization) %>%
  unite("search_text", description, source_note, topics, sep = " ", remove = FALSE) %>%
  nest(-col_id, -description, -search_text, .key = "notes") %>%
  select(col_id, description, notes, search_text)




usethis::use_data(wdi_indicators, overwrite = TRUE)
