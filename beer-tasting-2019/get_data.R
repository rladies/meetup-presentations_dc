## RLadies beer tasting

## Installing and loading packages
# install.packages("googlesheets")
library(googlesheets)
library(tidyverse)

## Lets R access my google spread sheets
gs_ls()

## Connecting to the beer tasting workbook
try <- gs_title("RLadiesDC beer tasting 2019")

## find sheet names
gs_ws_ls(try)

## Get the votes
## First 3 lines are instructions
votes <- gs_read(ss=try, ws = "Sheet1", skip=3)

head(votes)
