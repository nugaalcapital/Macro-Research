
# USDT MC yoy -------------------------------------------------------------
# Looking at on-chain liquidity

# Clean env
rm(list = ls())
gc()
dev.off()

# libraries
library(scales)
library(tidyverse)
library(httr)

# Get json data
url <- "https://stablecoins.llama.fi/stablecoincharts/all?stablecoin=1"
response <- GET(url)
data <- content(response)

# Extract data
dte <- c()
usdtmc <- c()
for(i in 1:1380){
  dte[i] <- as.numeric(data[[i]][["date"]])
  usdtmc[i] <- data[[i]][["totalCirculating"]][["peggedUSD"]]
}

df <- data.frame("Date" = as.POSIXct(dte), "USDT_MC" = usdtmc)

# Plot
df %>%
  mutate(USDT_MC_yoy = USDT_MC/lag(USDT_MC, 365) - 1) %>%
  filter(Date >= "2022-01-01") %>%
  ggplot(.) + 
  geom_line(mapping = aes(x = as.Date(Date), y = USDT_MC_yoy)) + 
  scale_x_date(date_breaks = "2 months", 
               date_labels = "%b\n%Y") +
  scale_y_continuous(labels = percent, breaks = seq(-5, 5, 0.1)) +
  geom_hline(yintercept = 0.435, colour = "green") + 
  geom_hline(yintercept = 0, colour = "red") + 
  xlab("Date") + 
  theme(axis.title.x = element_text(vjust=-0.8)) +
  ylab("USDT Market Cap YoY") +
  labs(title = "USDT Market Cap YoY by Date", caption = "Source: Defillama") + 
  theme_bw()
