# importing libraries for loading, cleaning, manipulating and creating visulaization using data
library(readr)
library(tidyr)
library(janitor)
library(dplyr)
library(ggplot2)

# setting working directory
setwd("C:/Users/sudar/Documents/csv_data")

# loading datasets into frames
data_jan_2023 <- read_csv("202301-divvy-tripdata.csv")
data_dec_2022 <- read_csv("202212-divvy-tripdata.csv")
data_nov_2022 <- read_csv("202211-divvy-tripdata.csv")
data_oct_2022 <- read_csv("202210-divvy-tripdata.csv")
data_sep_2022 <- read_csv("202209-divvy-tripdata.csv")
data_aug_2022 <- read_csv("202208-divvy-tripdata.csv")
data_jul_2022 <- read_csv("202207-divvy-tripdata.csv")
data_jun_2022 <- read_csv("202206-divvy-tripdata.csv")
data_may_2022 <- read_csv("202205-divvy-tripdata.csv")
data_apr_2022 <- read_csv("202204-divvy-tripdata.csv")
data_mar_2022 <- read_csv("202203-divvy-tripdata.csv")
data_feb_2022 <- read_csv("202202-divvy-tripdata.csv")

# compareing data types of columns of data frames
compare_df_cols(data_jan_2023,data_dec_2022,data_nov_2022,data_oct_2022,data_sep_2022,data_aug_2022,data_jul_2022,data_jun_2022,data_may_2022,data_apr_2022,data_mar_2022,data_feb_2022, return = "mismatch")
 
# binding all datasets
trips_total <- rbind(data_jan_2023,data_dec_2022,data_nov_2022,data_oct_2022,data_sep_2022,data_aug_2022,data_jul_2022,data_jun_2022,data_may_2022,data_apr_2022,data_mar_2022,data_feb_2022)

# Finding unique rideable types and member types
unique(trips_total$rideable_type)
unique(trips_total$member_casual)

# calculate the duration of each trip and make it a new column
trips_total$trip_duration <- as.numeric(difftime(trips_total$ended_at,trips_total$started_at, units='mins'))

# obtaining the weekday at which the trip started
trips_total$weekday <- weekdays(trips_total$started_at, abbreviate=FALSE)

# making a column with the month in which the trip started
trips_total$month <- format(trips_total$started_at, "%m")  

# removing duplicate trips with same id from data frame trips_total
trips_total <- trips_total %>% 
  distinct(ride_id, .keep_all = TRUE)

# filtering out all values in the trip_duration column are not positive 
trips_total <- trips_total %>%
  filter(trip_duration>0)

# removing na values
trips_total <- na.omit(trips_total)

# storing final data frame to csv file
write.csv(trips_total,'trips_total.csv')



# Descriptive analysis on trip duration
mean(trips_total$trip_duration) # average trip duration
median(trips_total$trip_duration) 
max(trips_total$trip_duration) # lognest trip duration
min(trips_total$trip_duration) # shortest trip duration

# comparing numbers of casual versus member rides
trips_total %>% 
  group_by(member_casual) %>% 
  summarize(n=n()) %>%  # calculates the number of observations in each group and creates a new column called "n"
  mutate(percent = n*100/sum(n)) # calculates the percentage of each type of member in a new column "percent"


# average time trip for each type of user
avg_duration <- trips_total %>% 
  group_by(member_casual) %>% 
  summarize(average_trip_time=mean(trip_duration))

# plotting graph depicting average trip duration of casual vs member
ggplot(avg_duration, aes(member_casual, y = average_trip_time, fill = member_casual))+
  geom_col() + # heights of the bars to represent values in the data, use geom_col() instead. of geom_bar()
  labs(title="Average trip duration. Casual vs Member")


# Now, running the average ride time by each day for members vs casual user

# we first need to order data by weekday
avg_duration_per_weekday <- trips_total%>%
  group_by(member_casual, weekday)%>%
  summarise(average_trip_time = mean(trip_duration))


# setting the levels of the "weekday" column to be in the order: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
avg_duration_per_weekday$weekday <- factor(avg_duration_per_weekday$weekday, levels= c( "Monday", 
                                                                                        "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday","Sunday"))

# returns the original data frame sorted by the "weekday" column in ascending order
avg_duration_per_weekday[order(avg_duration_per_weekday$weekday),]


ggplot(avg_duration_per_weekday, aes(weekday, average_trip_time, fill=member_casual))+
  geom_bar(stat = "identity",position = "dodge") +
  labs(title="Average duration of trip per weekday")
