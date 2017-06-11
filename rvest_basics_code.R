library(rvest)
library(dplyr)

#
# Female Nobel Laureates Example - Wikipedia
#
url <- "https://en.wikipedia.org/wiki/List_of_female_Nobel_laureates"
page <- read_html(url)
nobel_ladies <- page %>%
  html_nodes("table") %>%
  .[1] %>%
  html_table()

nobel_ladies <- nobel_ladies[[1]]
# Not what we wanted
# This script is going after every item on the page within an HTML tag of <table> and selecting the first one
# Try again with the second table!

nobel_ladies <- page %>%
  html_nodes("table") %>%
  .[2] %>%
  html_table()
nobel_ladies <- nobel_ladies[[1]]

#
# Judo Example
#
url <- "http://www.judoinside.com/event/11513/2017_Pan_American_Open_Santiago"
page <- read_html(url)
judo_results <- page %>%
  html_nodes("table") %>%
  .[1:14] %>%
  html_table()
judo_results1 <- judo_results[[1]]

# Problem 1: Column Names Are Not Descriptive
names(judo_results1) <- c('Placement_U60', 'Judoka_Name', 'Country')

# Use plyr to rename all the data frames
library(plyr)
labeled_judo <- llply(judo_results, function(df) {
  names(df) <- c(paste("Placement_",df[1,1],sep=''),'Judoka_Name', 'Country')
  return(df)
})

labeled_judo[[9]]

# Problem 2: The first row of each table needs to be removed
labeled_judo <- llply(labeled_judo, function(df) {
  df <- df[-1,]
  return(df)
})

labeled_judo[[9]][1,]

# Problem 3 - What do I do with this list of data frames? - Turn into json?
library(jsonlite)
json_judo <- toJSON(labeled_judo, dataframe = "rows")
prettify(json_judo)

write(json_judo, file="pan_am_judo.JSON")

# Provide instructions for people to reverse your process
# Get the JSON file back into list of dataframes
library(jsonlite)
reverse_judo <- read_json(path = 'pan_am_judo.JSON', simplifyVector = TRUE)
