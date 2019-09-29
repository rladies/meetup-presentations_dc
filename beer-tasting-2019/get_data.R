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


votes_long <- votes %>% 
  mutate(Beer = tolower(Beer)) %>% 
  select(-X8, -X9) %>% 
  pivot_longer(-c(Name, Beer), names_to = "quality", values_to = "score")

votes_long2 <-votes_long %>% filter(quality != "Overall")


  ggplot(data = votes_long2, aes(x = quality, y = score, fill = Beer)) + 
  geom_boxplot() + 
    geom_jitter(aes(shape = Beer)) + 
    facet_wrap(~Beer) + 
    theme(legend.position = "none")
    

  
  ggplot(data = votes_long2) + 
    geom_line(aes(x = quality, y = score, color = Beer, group = interaction(Beer, Name)))
  
  ggplot(data = votes_long2) + 
    geom_line(aes(x = quality, y = score, color = Beer, group = interaction(Beer, Name)))

  ggplot(data = votes_long2) + 
    geom_line(aes(x = quality, y = score, color = Beer, group = Beer)) +
    facet_wrap(~Name)
  
  tastes_summ <-  votes_long2 %>% 
    group_by(Beer, quality) %>%
    summarize(means = mean(score), sds = sd(score))
    
  
 ggplot() + 
   geom_boxplot(data = votes_long2, aes(x = quality, y = score, fill = Beer)) + 
   geom_point(data = votes_long2, aes(x = quality, y = score, shape = Beer)) + 
   geom_point(data = tastes_summ, inherit.aes = FALSE, aes(x = quality, y = means), shape =0, size = 2) + 
   geom_line(data = tastes_summ, aes(x = quality, y = means, group = 1)) +   
   facet_wrap(~Beer) + 
   theme(legend.position = "none")
 
 library(ggridges)

 ggplot(data = votes_long2) + 
   geom_density_ridges(aes(x = score, y = quality, fill = Beer), alpha = .3)
  