
# Loan Officer ------------------------------------------------------------

# Clean env
rm(list = ls())
gc()
dev.off()

# Loan data
tribble( 
  ~"symbol", ~"title",
  "DRTSCILM", "Large/Mid Mkt Firms",
  "DRTSCIS",  "Small Firms",
  "DRTSCLCC", "Credit Cards",
  "DRTSSP",   "Subprime Mortgage",
  "STDSAUTO", "Auto Loans"
) %>%
  tq_get(
    get = "economic.data",
    from = "2010-01-01"
  ) %>%
  rename(perc_tight = price) %>%
  mutate(perc_tight = perc_tight / 100) %>%
  ggplot(.) + 
  geom_line(mapping = aes(x = date, y = perc_tight, colour = title)) + 
  scale_x_date(date_breaks = "6 months", 
               date_labels = "%b\n%Y") +
  scale_y_continuous(breaks = seq(-1,1,0.1), labels = percent) +
  geom_hline(yintercept = 0, col = "black") +
  xlab("Date (Year)") +
  ylab("Percentage of Banks tightening") +
  labs(title = "Percentage of Banks Tightening vs Date", caption = "Source: Fred") +
  theme_bw()
