# Load necessary libraries
library(ggplot2)
library(grid)
library(gridExtra)
library(dplyr)
library(data.table)


csv_file_loaction = './data_subregions/csv_MASTER.csv'

# Load data
csv_MASTER_v12 <- read.csv(csv_file_loaction)

# Melt data to separate demand and demand_category columns
demand_data <- merge(
  melt(csv_MASTER_v12 %>% select(-contains('_category')) %>% data.table(), 
       id.vars = 'date_time', value.name = 'demand', variable.name = 'BA'),
  melt(csv_MASTER_v12 %>% select(contains('_category'), date_time) %>% data.table(), 
       id.vars = 'date_time', value.name = 'demand_category', variable.name = 'BA') %>%
    mutate(BA = gsub(pattern = '_category', '', BA)),
  by = c('date_time', 'BA')
)

# Convert date_time to POSIXct format
demand_data <- demand_data %>% mutate(date_time = as.POSIXct(date_time, format = "%Y-%m-%d %H:%M", tz = 'UTC'))

# Define color palette
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", 'red', 'blue')

# Generate full plot: Points for each demand category that is not "OKAY"
full_plot <- ggplot(demand_data %>% filter(demand_category != 'OKAY')) +
  geom_point(aes(x = date_time, y = BA, col = factor(demand_category)), 
             alpha = 0.99, size = 1.5) +
  scale_color_manual(name = "", values = cbbPalette) +
  labs(x = 'Date') +
  scale_x_datetime(date_labels = '%Y-%m-%d',
                   breaks = seq.POSIXt(from = as.POSIXct("2019-01-01"), 
                                       to = as.POSIXct("2025-01-01"), 
                                       by = "1 months")) +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 90, vjust = 0.5),
        plot.margin = unit(c(0.6, 0, 0, 0), "cm")) +
  coord_flip()

# Generate summary data: Counts of non-OKAY demand categories over time
Summary_demand_data_mostly_complete <- expand.grid(
  date_time = seq.POSIXt(from = min(demand_data$date_time, na.rm = TRUE),
                         to = max(demand_data$date_time, na.rm = TRUE),
                         by = 'hour'),
  demand_category = unique(demand_data$demand_category)[unique(demand_data$demand_category) != 'OKAY']
)

Summary_time_long_summary <- rbind(Summary_demand_data_mostly_complete, 
                                   demand_data %>% filter(demand_category != 'OKAY') %>% 
                                     select(date_time, demand_category)) %>%
  data.table() %>%
  group_by(date_time, demand_category) %>%
  summarise(num = n() - 1) %>%
  ungroup()

# Generate summary plot for non-OKAY demand categories
summary_plot <- ggplot(Summary_time_long_summary %>% filter(demand_category != 'OKAY')) +
  geom_line(aes(x = date_time, y = num, col = factor(demand_category)), size = 1) +
  scale_color_manual(name = "", values = cbbPalette) +
  theme_bw() +
  theme(legend.position = "", axis.text.y = element_blank(),
        plot.margin = unit(c(0.6, 0.25, 2.69, 0), "cm"),
        strip.text = element_blank()) +
  labs(y = "#", x = '') +
  scale_y_continuous(breaks = c(1, 5, 10)) +
  scale_x_datetime(date_labels = '%Y-%m-%d',
                   breaks = seq.POSIXt(from = as.POSIXct("2019-01-01"),
                                       to = as.POSIXct("2019-07-01"),
                                       by = "1 months")) +
  facet_wrap(~demand_category, ncol = 10, scales = 'free') +
  coord_flip()

# Generate summary of demand data by BA and demand category
Summary_space_demand_data_mostly_complete <- expand.grid(
  date_time = seq.POSIXt(from = min(demand_data$date_time, na.rm = TRUE),
                         to = max(demand_data$date_time, na.rm = TRUE),
                         by = 'hour'),
  demand_category = unique(demand_data$demand_category)[unique(demand_data$demand_category) != 'OKAY'],
  BA = unique(demand_data$BA)
)

total_length <- length(seq.POSIXt(from = min(demand_data$date_time, na.rm = TRUE),
                                  to = max(demand_data$date_time, na.rm = TRUE),
                                  by = 'hour'))

Summary_BA_long_summary <- rbind(Summary_space_demand_data_mostly_complete, 
                                 demand_data %>% filter(demand_category != 'OKAY') %>% 
                                   select(BA, date_time, demand_category)) %>%
  data.table() %>%
  group_by(BA, demand_category) %>%
  summarise(num = n() - total_length) %>%
  ungroup()

# Generate bar plot of demand by BA
summary_BA_plot <- ggplot(Summary_BA_long_summary %>% filter(demand_category != 'OKAY')) +
  geom_bar(aes(x = BA, y = num + 1, fill = factor(demand_category)),
           stat = 'identity', position = 'dodge', width = 0.5) +
  scale_fill_manual(name = "", values = cbbPalette) +
  theme_bw() +
  labs(y = " # + 1", x = '') +
  theme(legend.position = "", axis.text.x = element_blank(),
        plot.margin = unit(c(0, 0.19, -0.5, 1.075), "cm")) +
  facet_wrap(~demand_category, nrow = 10, scales = 'free') +
  scale_y_log10()

# Create and save diagnostic plot
pdf(file = 'testing_large_diagnostic_figure.pdf', width = 22, height = 25)
grid.arrange(
  summary_BA_plot,
  full_plot,
  grid.rect(gp = gpar(col = "white")),
  summary_plot, 
  layout_matrix = cbind(c(1,1,2,2,2,2), c(1,1,2,2,2,2), c(1,1,2,2,2,2),
                        c(1,1,2,2,2,2), c(1,1,2,2,2,2), c(3,3,4,4,4,4), c(3,3,4,4,4,4))
)
dev.off()

