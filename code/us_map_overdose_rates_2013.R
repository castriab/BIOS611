library(maps)
library(tidyverse)

### Load in datasets
us_map <- map_data("state")

overdose <- read_csv("work/source_data/CDC_Drug_Overdose_Deaths.csv", locale = locale(encoding = "latin1"))
ssp <- read_csv("work/source_data/SSP_Data.csv", locale = locale(encoding = "latin1"))

merged_data <- merge(overdose, ssp, by = "State")

merged_data$`State` <- tolower(merged_data$`State`)

us_map_merged <- merge(us_map, merged_data, by.x = "region", by.y = "State", all.x = TRUE)

### Make graph
ggplot(us_map_merged, aes(x = long, y = lat, group = group, fill = `2013 Age-adjusted Rate (per 100,000 population)`)) +
  geom_polygon(color = "white", size = 0.5) +
  scale_fill_gradient(low = "lightblue", high = "darkblue", na.value = "grey50", guide = "legend", name = "Rate") +
  labs(title = "2013 Overdose Rates in the United States",
       subtitle = "Age-adjusted Rate per 100,000 population",
       fill = "Rate") +
  theme_minimal()

# Save the ggplot object to a file
ggsave(filename = "work/figures/us_map_overdose_rates_2013.png", 
       width = 10,  
       height = 8, 
       units = "in")  