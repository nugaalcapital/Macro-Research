
# Bank Credit YOY ---------------------------------------------------------

# Clean env
rm(list = ls())
gc()
dev.off()

# Libraries
library(fredr)
library(tidyquant)
library(tidyverse)

# Plot data
tribble( 
  ~"symbol", ~"title",
  "TOTBKCR", "Bank Credit"
) %>%
  tq_get(
    get = "economic.data",
    from = "2010-01-01"
  ) %>%
  mutate(bank_credit_yoy = price/lag(price,52) - 1) %>%
  filter(date >= "2011-01-01") %>%
  ggplot(.) + 
  geom_line(mapping = aes(x = date, y = bank_credit_yoy)) + 
  geom_hline(yintercept = 0, colour = "red") +
  scale_x_date(date_breaks = "6 months", date_labels = "%b\n%Y") +
  scale_y_continuous(breaks = seq(-0.5, 0.5, 0.005), labels = percent) +
  xlab("Date") + 
  ylab("US Bank Credit YoY") +
  labs(title = "US Bank Credit YoY by Date", caption = "Source: FRED") + 
  theme_bw()