
# Corporate Debt ----------------------------------------------------------

# Complimentary info alongside ISM to assess
# Business cycle

# Clean env
rm(list = ls())
gc()
dev.off()

# Libraries
library(tidyquant)
library(fredr)
library(tidyverse)

# Get data
tribble( 
  ~"symbol", ~"title",
  "BCNSDODNS", "Corporate Debt"
) %>%
  tq_get(
    get = "economic.data",
    from = "2000-01-01"
  ) %>%
  mutate(corp_debt_yoy_inv = 1/(price/lag(price,4))) %>%
  select(3:5) %>%
  rename(Date = date) %>%
  filter(Date >= "2015-01-01") %>%
  ggplot(.) + 
  geom_line(mapping = aes(x = as.Date(Date), y = corp_debt_yoy_inv)) + 
  scale_x_date(date_breaks = "6 months", date_labels = "%b\n%Y") +
  scale_y_continuous(breaks = seq(-2, 2, 0.01)) +
  geom_vline(xintercept = as.Date("2016-01-01"), colour = "red") +
  geom_vline(xintercept = as.Date("2020-04-01"), colour = "red") +
  geom_vline(xintercept = as.Date("2023-06-01"), colour = "red") +
  geom_vline(xintercept = as.Date("2021-03-01"), colour = "green") +
  geom_vline(xintercept = as.Date("2018-02-01"), colour = "green") +
  xlab("Date") + 
  ylab("Non-Financial Corporate Debt YoY Inversed") +
  labs(title = "Non-Financial Corporate Debt YoY Inversed by Date", 
       caption = "Source: FRED",
       subtitle = "ISM peaks marked by green lines and ISM bottoms
       marked by red lines") + 
  theme_bw()
