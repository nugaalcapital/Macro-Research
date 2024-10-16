
# Rolling Correlation btw MSTR & BTC --------------------------------------

# Clean env
rm(list = ls())
gc()
dev.off()

# Libraries
library(tidyquant)
library(tidyverse)

# Get data and plot
tribble(~"symbol", ~"title",
        "MSTR", "MSTR",
        "BTC-USD", "BTC") %>%
  tq_get(get = "stock.prices", 
         from = "2023-01-01") %>%
  select(2,3,7) %>%
  pivot_wider(names_from = "title",
              values_from = "close",
              names_prefix = "close") %>%
  drop_na() %>%
  tq_mutate_xy(x = closeBTC, y = closeMSTR,
               mutate_fun = runCor,
               n          = 90,
               use        = "pairwise.complete.obs",
               col_rename = "rolling_corr") %>%
  filter(date >= "2023-07-01") %>%
  set_names(c("Date","MSTR", "BTC", "rolling_corr")) %>%
  ggplot(.) + 
  geom_line(mapping = aes(x = Date, y = rolling_corr)) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b\n%Y") +
  scale_y_continuous(breaks = seq(-1, 1,0.05)) +
  ylab("Rolling Correlation") +
  labs(title = "Rolling Correlation Between MSTR & BTC",
       caption = "Source: Yahoo Finance & Nugaal Capital") +
  theme_bw()