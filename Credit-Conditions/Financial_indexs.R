
# Financial conditions index ----------------------------------------------

# Clean env
rm(list = ls())
gc()
dev.off()

# Get data
df <- tribble(~"symbol", ~"title",
        "NFCI", "NFCI") %>%
  tq_get(get = "economic.data",
         from = "2010-01-01") %>%
  mutate(NFCI_yoy = (price/lag(price, 52)) - 1)

# Plot index inversed
df %>% 
  ggplot(.) + 
  geom_line(mapping = aes(x = date, y = -1*price)) +
  geom_hline(yintercept = 0, colour = "black") +
  geom_vline(xintercept = as.Date("2012-12-01"), colour = "red") +
  geom_vline(xintercept = as.Date("2016-01-01"), colour = "red") +
  geom_vline(xintercept = as.Date("2020-04-01"), colour = "red") +
  geom_vline(xintercept = as.Date("2023-06-01"), colour = "red") +
  geom_vline(xintercept = as.Date("2011-02-01"), colour = "green") +
  geom_vline(xintercept = as.Date("2021-03-01"), colour = "green") +
  geom_vline(xintercept = as.Date("2018-02-01"), colour = "green") +
  scale_x_date(date_breaks = "6 months", 
               date_labels = "%b\n%Y") + 
  scale_y_continuous(breaks = seq(-1,1,0.05)) + 
  xlab("Date") + 
  ylab("NFCI Inversed") +
  labs(title = "NFCI Inversed by Date", 
       subtitle = "Red and Green Lines indicate ISM bottom and peaks respectively",
       caption = "Source: FRED") + 
  theme_bw()
