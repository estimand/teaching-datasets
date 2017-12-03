library(tidyverse)

countries <- read_csv("input_data/WDICountry.csv.gz") %>%
             select(-X32) %>%
             rename_all(function(x) gsub("\\s", "_", tolower(x))) %>%
             filter(!is.na(region), !is.na(income_group)) %>%
             select(country_code, country_name = short_name, region, income_group) %>%
             arrange(country_code)

indicators <- read_csv("input_data/WDISeries.csv.gz") %>%
              select(-X21) %>%
              rename_all(function(x) gsub("\\s", "_", tolower(x))) %>%
              rename(indicator_code = series_code) %>%
              select(indicator_code, indicator_name, topic) %>%
              arrange(indicator_code)

data <- read_csv("input_data/WDIData.csv.gz") %>%
        select(-X63) %>%
        rename_all(function(x) gsub("\\s", "_", tolower(x))) %>%
        semi_join(countries, by = "country_code") %>%
        semi_join(indicators, by = "indicator_code") %>%
        gather("year", "value", `1960`:`2017`) %>%
        filter(!is.na(value)) %>%
        select(country_code, indicator_code, year, value) %>%
        arrange(country_code, indicator_code, year)

write_csv(countries, "wdi-countries.csv.gz")
write_csv(indicators, "wdi-indicators.csv.gz")
write_csv(data, "wdi-data.csv.gz")

