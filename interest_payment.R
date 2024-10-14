
# Comparing Interest payments per Total Federal Debt with Federal  --------

# Clean env
rm(list = ls())
gc()
dev.off()

# Get Data and Plot
df <- tribble(~"symbol", ~"title",
        "GFDEBTN", "Federal Debt",
        "A091RC1Q027SBEA", "Interest Payments") %>%
  tq_get(get = "economic.data", from = "2000-08-01") %>%
  select(-1) %>%
  pivot_wider(names_from = "title", names_prefix = "var_",
              values_from = "price") %>%
  set_names(c("Date", "Fed_Debt", "Int_Pay")) %>%
  mutate(Interest_Rate = (1000*Int_Pay)/Fed_Debt)

df_to_merge <- tribble(~"symbol", ~"title",
  "EFFR", "Federal Funds Rate") %>%
  tq_get(get = "economic.data", from = "2000-08-01") %>%
  select(3,4) %>%
  set_names(c("Date", "Fed_Rate"))

df_full <- left_join(df, df_to_merge, by = "Date") 

N <- length(df_full$Date[is.na(df_full$Fed_Rate)])

test <- c()

final <- c()

for(i in 1:N){

  # Year and Month
  y <- year(df_full$Date[is.na(df_full$Fed_Rate)][i])
  m <- month(df_full$Date[is.na(df_full$Fed_Rate)][i])
  d <- day(df_full$Date[is.na(df_full$Fed_Rate)][i])
  
  # Check if NA
  for(j in 1:31){
    if(length(df_to_merge$Fed_Rate[year(df_to_merge$Date) == y & month(df_to_merge$Date) == m &
                                   day(df_to_merge$Date) == d + j]) != 0){
      test[j] <- df_to_merge$Fed_Rate[year(df_to_merge$Date) == y & month(df_to_merge$Date) == m &
                                        day(df_to_merge$Date) == d + j]
      
    } else{
      test[j] <- NA
    }
  }
  
  result <- test[!is.na(test)]
  final[i] <- result[1]
}
  
df_full$Fed_Rate[is.na(df_full$Fed_Rate)] <- final

df_full %>%
  ggplot(.) +
  geom_line(mapping = aes(x = Date, y = Interest_Rate, colour = "steelblue")) +
  geom_line(mapping = aes(x = Date, y = Fed_Rate/100, colour = "darkblue")) +
  scale_x_date(date_breaks = "1 year", 
               date_labels = "%Y") +
  scale_y_continuous(breaks = seq(0, 0.1, 0.005), labels = percent) +
  xlab("Date") + 
  ylab("Interest Rates per Total Debt and Federal Funds Rate") +
  labs(title = "Interest Rates per Total Debt and Federal Funds Rate by Date", caption = "Source: FRED") + 
  theme_bw()