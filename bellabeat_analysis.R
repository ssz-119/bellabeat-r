# Load libraries
library(tidyverse)
library(dplyr)
library(ggplot2)
library(janitor)
library(lubridate)
library(tidyr)

# Load relevant datasets
activity <- read.csv("/cloud/project/capstone/dailyActivity_merged.csv")
sleep <- read.csv("/cloud/project/capstone/sleepDay_merged.csv")


# View structure of each dataset
str(activity)
str(sleep)

# View the first few observations of each dataset
head(activity)
head(sleep)

# View missing values for each column in each dataset
colSums(is.na(activity))
colSums(is.na(sleep))

# Clean column names and keep only distinct rows for each dataset
activity <- clean_names(activity) %>%
  distinct()
sleep <- clean_names(sleep) %>%
  distinct()


# Convert date column to date data type for each dataset
activity <- activity %>% 
  mutate(activity_date = as_date(activity_date, format="%m/%d/%Y"))

sleep <- sleep %>%
  mutate(sleep_day = as_date(sleep_day, format="%m/%d/%Y %I:%M:%S %p"))

# Calculate sleep efficiency and add as new column
sleep <- sleep %>%
  mutate(sleep_efficiency = total_minutes_asleep / total_time_in_bed)

# Preview and confirm changes
glimpse(activity)
glimpse(sleep)

# Combine datasets on participant ID and date
sleep_activity <- inner_join(activity, sleep, by=c("id", "activity_date" = "sleep_day"))

# Count the number of distinct participants in each dataset
n_distinct(sleep$id)
n_distinct(sleep_activity$id)
n_distinct(activity$id)

# Daily Activity Summary Statistics
activity %>%
  select(total_steps,
         very_active_minutes,
         sedentary_minutes,
         calories) %>%
  summary()

# Sleep Time Summary Statistics
sleep %>%
  select(total_minutes_asleep,
         total_time_in_bed,
         sleep_efficiency) %>%
  summary()

# Combined Daily Sleep and Activity Summary Statistics
sleep_activity %>%
  select(
    total_steps,
    total_distance,
    very_active_minutes,
    sedentary_minutes,
    total_minutes_asleep,
    total_time_in_bed,
    sleep_efficiency
  ) %>%
  summary()

# Combined daily average metrics per user
combined_averages <- sleep_activity %>%
  group_by(id) %>%
  summarise(mean_daily_steps = mean(total_steps),
            mean_daily_distance = mean(total_distance),
            mean_very_active = mean(very_active_minutes),
            mean_sedentary = mean(sedentary_minutes),
            mean_daily_sleep = mean(total_minutes_asleep),
            mean_daily_bed = mean(total_time_in_bed),
            mean_sleep_efficiency = mean(sleep_efficiency))

# Categorize users based on daily activity, sleep, and sedentary levels according to professional recommendations.
combined_categories <- combined_averages %>%
  mutate(
    activity_level = case_when(
      mean_daily_steps < 5000 ~ "sedentary",
      mean_daily_steps >= 5000 & mean_daily_steps < 7500 ~ "low active",
      mean_daily_steps >= 7500 & mean_daily_steps < 10000 ~ "somewhat active",
      mean_daily_steps >= 10000 ~ "active",
      TRUE ~ NA_character_
    ),
    
    sleep_level = case_when(
      mean_daily_sleep < 420 ~ "below recommended",
      mean_daily_sleep >= 420 & mean_daily_sleep <= 540 ~ "meets recommended",
      mean_daily_sleep > 540 ~ "above recommended"
    ),
    
    sedentary_level = case_when(
      mean_sedentary < 240 ~ "low",
      mean_sedentary >= 240 & mean_sedentary < 480 ~ "medium",
      mean_sedentary >= 480 & mean_sedentary < 660 ~ "high",
      mean_sedentary >= 660 ~ "very high"
    )
  )

# Convert categories to factors
combined_categories <- combined_categories %>%
  mutate(
    activity_level = factor(activity_level, levels=c("sedentary", "low active", "somewhat active", "active")),
    sleep_level = factor(sleep_level, levels=c("below recommended", "meets recommended", "above recommended")),
    sedentary_level = factor(sedentary_level, levels=c("low", "medium", "high", "very high")),
  )

# View table of user distribution among sleep levels
table(combined_categories$sleep_level)

# View table of user distribution among activity levels
table(combined_categories$activity_level)

# View table of user distribution among sedentary levels
table(combined_categories$sedentary_level)

# ggplot(combined_categories, aes(x = sleep_level)) + geom_bar()

# Explore relationship between total steps and calories burned
ggplot(data=activity, aes(x=total_steps, y=calories)) +
  geom_point() +
  geom_smooth() +
  labs(title="Total Steps vs Calories Burned",
       x= "Total Steps",
       y="Calories Burned")

# Explore relationship between sleep duration and minutes spent in bed
ggplot(sleep, aes(x=total_time_in_bed, y=total_minutes_asleep)) +
  geom_point(alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") + 
  geom_smooth() +
  labs(title="Sleep Duration vs Total Minutes in Bed",
       x= "Total Minutes in Bed",
       y= "Total Minutes Asleep")

# Calculate slope for sleep duration vs total minutes in bed
lm(total_minutes_asleep ~ total_time_in_bed, data = sleep)

# Shows distribution of user proportion in sleep levels across different activity levels
ggplot(combined_categories, aes(x = activity_level, fill = sleep_level)) +
  geom_bar(position = "fill") +
  labs(
    title = "User Distribution by Sleep and Activity Level",
    x = "Activity Level",
    y = "Proportion of Users",
    fill = "Sleep Level"
  ) +
  scale_y_continuous(breaks = seq(0, 1, by = 0.25)) +
  theme_minimal()

# Explore relationships between sedentary minutes daytime vs awake time in bed 
ggplot(sleep_activity, aes(x = sedentary_minutes, y = (total_time_in_bed - total_minutes_asleep))) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Daytime Sedentary Minutes vs Time Awake Minutes in Bed",
    x = "Daytime Sedentary Minutes",
    y = "Minutes Awake in Bed"
  ) +
  theme_minimal()

# View interactions between sedentary risk and activity levels
ggplot(combined_categories, aes(x = sedentary_level, fill = activity_level)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Activity Level Distribution Within Sedentary Risk Levels",
    x = "Sedentary Risk Levels",
    y = "Number of Users",
    fill = "Activity Level"
  ) +
  theme_minimal()

# Histogram to show distribution of step counts for all activity observations
ggplot(activity, aes(total_steps)) +
  geom_histogram(fill="lightgreen", color="black") +
  labs(
    title = "Distribution of Total Daily Steps",
    x = "Total Steps"
  )

# Histogram to show distribution of sleep efficiency over all sleep observations
ggplot(sleep, aes(sleep_efficiency)) +
  geom_histogram(binwidth=0.02, fill="lightblue", color="blue") +
  labs(
    title = "Distribution of Sleep Efficiency",
    x = "Sleep Efficiency (Time Asleep / Time in Bed)"
  )
