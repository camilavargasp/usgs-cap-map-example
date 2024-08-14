## Creatin a data frame with US states and territories and their corresponding USGS CASC region

## Set up ----
library(tigris)
library(sf)
library(dplyr)
library(readr)

## Load US states from tigris
# cb = T + 20m resol, removes American Samoa, Maraina Islands, Guam and Virgin Islands
us_states <- states(cb = TRUE, 
                    resolution = "20m")

## Creating vectors with state code for each casc region
northeast <- c("CT", "DE", "KY", "MA", "MD", "ME", "NH", "NJ", "NY", "PA", "RI", "VA", "VT", "WV", "DC")

southeast <- c("NC", "SC", "GA", "AL", "MS", "FL", "TN", "AR") ## puerto rico would be included here

midwest <- c("MN", "IA", "MO", "WI", "IN", "IL", "MI", "OH")

northcentral <- c("CO", "KS", "MT", "ND", "NE", "SD", "WY")

southcentral <- c("OK", "TX", "NM", "LA")

northwest <- c("WA", "OR", "ID")

southwest <- c("AZ", "NV", "UT", "CA")

pacificislands <- "HI"

alaska <- "AK"

puertorico <- "PR" ## This is on it's own instead of including it in South east region so it does not cause any issues when merging geometries

## For this example we are not including the following regions
# c("American Samoa", "the Commonwealth of the Northern Mariana Islands", "the Federated States of Micronesia", "Guam", "Hawaiʻi", "Palau", "and the Republic of the Marshall Islands")


## Adding column with region name
us_state_casc <- us_states %>% 
  select(GEOID, STUSPS, NAME) %>%
  st_drop_geometry() %>% 
  mutate(casc_region = case_when(STUSPS %in% alaska ~ "Alaska",
                                 STUSPS %in% puertorico ~ "Puerto Rico",
                                 STUSPS %in% pacificislands ~ "Hawaii",
                                 STUSPS %in% southwest ~ "South West",
                                 STUSPS %in% northwest ~ "North West",
                                 STUSPS %in% southcentral ~ "South Central",
                                 STUSPS %in% northcentral ~ "North Central",
                                 STUSPS %in% midwest ~ "Midwest",
                                 STUSPS %in% southeast ~ "South East",
                                 STUSPS %in% northeast ~ "North East",
                                 TRUE ~ "none"))

## Saving data frame into a csv

write_csv(us_state_casc, "data/state_by_casc_region.csv")

