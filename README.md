# Bellabeat Case Study: End-to-End Data Analysis in R

This is the final capstone project for the Google Data Analytics Professional Certificate. The goal was to explore how Bellabeat, a high-tech manufacturer of health-focused smart products for women, can grow their marketing strategy by examining smart device data.

**Business Task:** Analyze smart device usage data from non-Bellabeat consumers to identify user behavior patterns and apply to Bellabeat’s digital marketing strategies

## Table of Contents
- [Tools Used](#tools-used)
- [Analysis Process](#analysis-process)
- [Dataset](#dataset)
- [Key Insights](#key-insights)
- [Business Recommendations](#business-recommendations)
- [Sleep Duration vs. Time in Bed](#sleep-duration-vs-time-in-bed)
- [Step Count Histogram](#step-count-histogram)

## Tools Used
- R
- dplyr, ggplot2

## Analysis Process
- Data Cleaning and Wrangling
- Exploratory Data Analysis
- Visualization
- Insights & Recommendations

## Dataset
The dataset was public Fitbit data from 33 users over 30 days.

**Key Files Used:** dailyActivity_merged.csv and sleepDay_merged.csv

## Key Insights
- Many users still fall in the high risk sedentary lifestyle despite being physically active on paper.
- Users show high sleep efficiency (mean = 0.92) but insufficient sleep duration—averaging only about 6 hours per night.
- The “somewhat active” group had the highest proportion of users meeting recommended sleep levels, representing a realistic and balanced user profile.

## Business Recommendations
- Promote Consistent, Balanced Wellness Over Numeric Goals
- Highlight Sleep Tracking as a Core Feature
- Leverage “Somewhat Active” as the Ideal Lifestyle Tier

## Sleep Duration vs. Time in Bed

This scatterplot highlights sleep efficiency (time asleep / time in bed) where a red-dashed referenced line indicates perfect efficiency (every minute in bed was spent asleep).


<img src="sleep_efficiency_scatterplot.png" alt="Sleep Duration vs. Time in Bed" width="600"/>

## Step Count Histogram

This histogram displays variability in physical activity over time across all recorded observations.


<img src="steps_histogram.png" alt="Step Count Histogram" width="600"/>


**View the full code in [bellabeat_analysis.R]()**
