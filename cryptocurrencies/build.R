library(jsonlite)
library(lubridate)
library(tidyverse)

fiat_symbol <- "USD"
days <- 395
end_timestamp <- as.numeric(as.POSIXct("2017-12-31"))

get_data <- function(crypto_symbol) {
    url <- sprintf(
        "https://min-api.cryptocompare.com/data/histoday?fsym=%s&tsym=%s&limit=%d&toTs=%d",
        crypto_symbol, fiat_symbol, days, end_timestamp
    )
    bind_rows(read_json(url)$Data) %>%
        transmute(
            symbol = crypto_symbol,
            date = as_datetime(time),
            open, high, low, close
        ) %>%
        filter_at(
            vars(open:close),
            all_vars(. > 0)
        ) %>%
        arrange(date)
}

cryptocurrencies <- c(
    "BCH",
    "BTC",
    "BTG",
    "DASH",
    "EOS",
    "ETC",
    "ETC",
    "ETH",
    "IOT",
    "LTC",
    "NEO",
    "NXT",
    "XLM",
    "XMR",
    "XRP",
    "ZEC"
)

data <- bind_rows(lapply(cryptocurrencies, get_data)) %>%
        filter(date >= as.Date("2017-01-01")) %>%
        arrange(symbol, date)

write_csv(data, "cryptocurrencies.csv")

