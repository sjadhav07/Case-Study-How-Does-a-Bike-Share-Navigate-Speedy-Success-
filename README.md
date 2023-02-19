# Case-Study-How-Does-a-Bike-Share-Navigate-Speedy-Success-
Demonstrating skill in R, RStudio and Tableau using Google Capstone Project on Bike-Sharing Company

## Introduction
In this case study, I will perform many real-world tasks of a junior data analyst. You will work for a fictional company, Cyclistic, and meet different characters and team members. In order to answer the key business questions, I will follow the steps of the data analysis process: ask, prepare, process, analyze, share, and act.

## Scenario
I am a data analyst working in marketing analyst team at cyclistic, a bike sharing company in Chicago. Marketing director believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.

Goals assigned by manager are clear:
Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. Moreno and her team are interested in analyzing the Cyclistic historical bike trip data to identify trends

## Ask Phase
After reading and analyzing the requirements and necessities of the stakeholder, the business task here is to find patterns in the data to differentiate between casual riders and member ones. Give the marketing team new insights into the behavior of our users so they can develop better strategies.

## Prepare Phase
In this phase, I need to identify which data we need to be capable of answering business task questions, process for collecting that data, or how to get it if it's already available. For the project, data is delivered to us in CSV files. Each file contains data for particular month, the fields of each file are:

*ride_id: identifier for each trip 
*rideable_type: type of bike that was used
*started_at: timestamp for when the trip started
*ended_at: timestamp for when the trip ended
*stat_station_name: the name of the station where the trip started
*start_station_id: the id of the station where the trip started
*end_station_name: the name of the station where the trip ended
*end_station_id: the id of the station where the trip ended
*start_lat: latitude value for where the trip started
*start_lng: longitude value for where the trip started
*end_lat: latitude value for where the trip ended
*end_lng: longitude value for where the trip ended
*memeber_casual: type of user

## Process Phase
For the process phase, we need to make sure that the data is clean before it is analyzed. This is done by checking the consistency, integrity and the usability of the format. We could use google sheets or Excel, but the dataset is large, so the best option is R or Python. I'll be using R with the help of RStudio.

```
# importing libraries for loading, cleaning, manipulating and creating visulaization using data
library(readr)
library(tidyr)
library(janitor)
library(dplyr)
library(ggplot2)
```
We will use "readr" for loading dataset into data frame, "tidyr", "janitor" and "dplyr" for cleaning up and manipulating data so it's easier to work with. Fially "ggplot" will be used for creating data visualizations.

After libraries are imported, we will load each csv files into separate data frames. Total 12 csv files, so we will create 12 data frames using appropriate names

```
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
```

To check the content of data frames, we will used View function and for checking types of data in each field, we will use glimpse function.

![image](https://user-images.githubusercontent.com/117652787/219943621-2265369c-5996-4bdb-9310-26dd5e2ada6b.png)

![image](https://user-images.githubusercontent.com/117652787/219943687-7ac7da26-86f7-430c-a14c-362c15dfcaf3.png)

Now, we will check for differences betweeen data frames using compare_df_cols function

```
# compareing data types of columns of data frames
compare_df_cols(data_jan_2023,data_dec_2022,data_nov_2022,data_oct_2022,data_sep_2022,data_aug_2022,data_jul_2022,data_jun_2022,data_may_2022,data_apr_2022,data_mar_2022,data_feb_2022, return = "mismatch")
```

compare_df_cols function finds no inconsistencies in datasets, we find no errors, so we will merge al data frames using rbind function

Next, we will look for specfic values in readable_type and member_casual columns

![image](https://user-images.githubusercontent.com/117652787/219958281-cafb2704-b010-4240-acd2-0ae87ad458da.png)

Creating fields for trip_duration, weekday and month for improving dataset
```
# calculate the duration of each trip and make it a new column
total_trips$trip_duration <- as.numeric(difftime(total_trips$ended_at,total_trips$started_at, units='mins'))

# obtaining the weekday at which the trip started
total_trips$weekday <- weekdays(total_trips$started_at, abbreviate=FALSE)

# making a column with the month in which the trip started
total_trips$month <- format(total_trips$started_at, "%m")  
```

Now, we will remove all the duplicate data where ride_id is same and filter out non positive trip_duration
```
# removing duplicate trips with same id from data frame trips_total
trips_total %>% trips_total %>% 
  distinct(ride_id, .keep_all = TRUE)

# filtering out all values in the trip_duration column are not positive 
trips_total <- trips_total %>%
  filter(trip_duration>0)
```

removing NA values from dataframe
```
# removing na values
trips_total <- na.omit(trips_total)
```

Finally, we will store final data frame in csv format
```
# storing final data frame to csv file
write.csv(trips_total,'trips_total.csv')
```

## Analyze Phase

In the analyze phase, we find the story that the data is telling us. We will calculate mean, median, max and min to get the general sense of data
```
# Descriptive analysis on trip duration
mean(trips_total$trip_duration) # average trip duration
median(trips_total$trip_duration) 
max(trips_total$trip_duration) # lognest trip duration
min(trips_total$trip_duration) # shortest trip duration
```

comparing by type of member and calculating their number and percentage
```
# comparing numbers of casual versus member rides
trips_total %>% 
  group_by(member_casual) %>% 
  summarize(n=n()) %>%  # calculates the number of observations in each group and creates a new column called "n"
  mutate(percent = n*100/sum(n)) # calculates the percentage of each type of member in a new column "percent"
```

![image](https://user-images.githubusercontent.com/117652787/219961808-bb10c89b-d393-4300-8f0f-1566a4517e0e.png)

Calculating average trip time for each type of user
```
avg_duration <- trips_total %>% 
  group_by(member_casual) %>% 
  summarize(average_trip_time=mean(trip_duration))
```

Plotting various types of graphs for analyzing data
```
# plotting graph depicting average trip duration of casual vs member
ggplot(avg_duration, aes(member_casual, y = average_trip_time, fill = member_casual))+
  geom_col() + # heights of the bars to represent values in the data, use geom_col() instead. of geom_bar()
  labs(title="Average trip duration. Casual vs Member")
```
![image](https://user-images.githubusercontent.com/117652787/219964648-7a8926c2-a9dd-4cec-85ba-05185385e411.png)


```
Now, we will order data by weekday
```
# we first need to order data by weekday
avg_duration_per_weekday <- trips_total%>%
  group_by(member_casual, weekday)%>%
  summarise(average_trip_time = mean(trip_duration))
```

```
# setting the levels of the "weekday" column to be in the order: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
avg_duration_per_weekday$weekday <- factor(avg_duration_per_weekday$weekday, levels= c( "Monday", 
                                                                                       "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday","Sunday"))
```

```
# returns the original data frame sorted by the "weekday" column in ascending order
avg_duration_per_weekday[order(avg_duration_per_weekday$weekday),]
```

Depicting the relationship between average trip time and weekday of casual and member
```
ggplot(avg_duration_per_weekday, aes(weekday, average_trip_time, fill=member_casual))+
  geom_bar(stat = "identity",position = "dodge") +
  labs(title="Average duration of trip per weekday")
```

![image](https://user-images.githubusercontent.com/117652787/219965245-bc11d9e3-f760-4f0b-a479-a484a96cd4bd.png)
