# R workshop 3
# Data Transformation with dplyr (June 30th) 
## Chamudi Kashmila

install.packages("nycflights13")
library(nycflights13)
library(tidyverse)


# dataset
flights
view(flights)
# Descripton of the dataset
?flights

##  Filter rows with filter() ##

# filter() allows you to subset observations based on their values. 
# first argument is the name of the data frame. 
# second and subsequent arguments are the expressions that filter the data frame

# Select all flights on January 1st with:
filter(flights, month == 1, day == 1)

# When you run that line of code, dplyr executes the filtering operation and returns a new data frame. 
# dplyr functions never modify their inputs,
# To save the result,need to use the assignment operator, <-:

jan1 <- filter(flights, month == 1, day == 1)

jan1

# R either prints out the results, or saves them to a variable. 
# If you want to do both, you can wrap the assignment in parentheses

# Select all flights on December 25th and save them to "dec25" variable
(dec25 <- filter(flights, month == 12, day == 25))



### Comparison ###

# To use filtering effectively, 
# you have to know how to select the observations that you want using the comparison operators. 
# R provides the standard suite: >, >=, <, <=, != (not equal), and == (equal).

# easiest mistake to make is to use = instead of == when testing for equality.

filter(flights, month = 1)

# all flights flies more than 2000 miles
filter(flights, distance >= 2000)

# Another common problem you might encounter when using ==: floating point numbers.

sqrt(2) ^ 2 == 2

sqrt(2) 
1.414214 ^ 2
sqrt(2) ^ 2
1 / 49 * 49 == 1

1 / 49
0.02040816 * 49

# Computers use finite precision arithmetic (they obviously can’t store an infinite number of digits!) 
# So remember that every number you see is an approximation. 
# Instead of relying on ==, use near()

near(sqrt(2) ^ 2,  2)

near(1 / 49 * 49, 1)



## Logical operators ##

# Multiple arguments to filter() are combined with “and”
# & is “and”
# | is “or”
# ! is “not”

# Finds all flights that departed in November or December

filter(flights, month == 11 | month == 12)

# can't write like this

filter(flights, month == (11 | 12))
(11|12)

# Useful short-hand for this problem is x %in% y
# This will select every row where x is one of the values in y

nov_dec <- filter(flights, month %in% c(11, 12))
# c: Combine Values into a Vector or List
nov_dec

# complicated subsetting
######## De Morgan’s law ########
# !(x & y) is the same as !x | !y
# !(x | y) is the same as !x & !y
#################################

# find flights that weren’t delayed (on arrival or departure) by more than two hours

flight_nodelay_1 <- filter(flights, !(arr_delay > 120 | dep_delay > 120))
flight_nodelay_1
flight_nodelay_2 <-filter(flights, arr_delay <= 120 , dep_delay <= 120)
flight_nodelay_2

##############################exercise#################################################################
# Had an arrival delay of two or more hours
delayed_flights <- filter(flights, arr_delay >= 120 )
delayed_flights

#Flew to Houston (IAH or HOU)

filter(flights, dest == 'IAH'| dest == 'HOU') 
filter(flights, dest %in% c('IAH', 'HOU') )
########################################################################################################


#filter(flights, arr_delay >= 120 )
#filter(flights, dest == 'IAH'| dest == 'HOU') 
#filter(flights, dest %in% c('IAH', 'HOU') )



### Arrange rows with arrange() ###

# arrange() works similarly to filter()
# except that instead of selecting rows, it changes their order.

# It takes a data frame and a set of column names (or more complicated expressions) to order by. 
# If you provide more than one column name, each additional column will be used to break ties in the values of preceding columns



arrange(flights, year, month, day)

# Use desc() to re-order by a column in descending order
arrange(flights, desc(dep_delay))

# default - ascending order
arrange(flights, distance)


# Missing values are always sorted at the end

df <- tibble(x = c(5, 2, NA))
df
is.na(df)
arrange(df, x)
arrange(df, desc(x))




# Select columns with select()

# select() allows you to rapidly zoom in on a useful subset
# using operations based on the names of the variables

# Select columns by name
select(flights, year, month, day)


# Select all columns between year and day (inclusive)
select(flights, year:day)

# Select all columns except those from year to day (inclusive)
flights
select(flights, dep_time:time_hour)

select(flights, -(year:day))


# select() can be used to rename variables, 
# but it’s rarely useful because it drops all of the variables not explicitly mentioned. 
# Instead, use rename(), which is a variant of select() 
# that keeps all the variables that aren’t explicitly mentioned:

rename(flights, tail_num = tailnum)


# Another option is to use select() in conjunction with the everything() helper.
# This is useful if you have a handful of variables you’d like to move to the start of the data frame.

## some specific variables
select(flights, time_hour, air_time, everything())

##  columns between dep_delay, arr_delay (as a range)
select(flights, dep_delay:arr_delay, everything())


### Add new variable with mutate() ###

# Besides selecting sets of existing columns, it’s often useful to add new columns that are functions of existing columns.
# mutate() always adds new columns at the end of your dataset

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)

flights_sml


mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)

# you can refer to columns that you’ve just created

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)


# If you only want to keep the new variables, use transmute()

flights

flights_sml

transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours)


# the flights dataset, you can compute hour and minute from dep_time with
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)




### Grouped summaries with summarise() ###

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

### na.rm = TRUE ###

#  we can use the argument na.rm = TRUE to exclude missing values
# when calculating descriptive statistics in R.
########### example ##########################

#define vector with some missing values
x <- c(3, 4, 5, 5, 7, NA, 12, NA, 16)

mean(x)
sum(x)
max(x)
sd(x)


mean(x, na.rm = TRUE)
sum(x, na.rm = TRUE)
max(x, na.rm = TRUE)
sd(x, na.rm = TRUE)

###############################################

# if we applied exactly the same code to a data frame grouped by date, we get the average delay per date

by_day <- group_by(flights, year, month, day)

summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

################# Combining multiple operations with the pipe#############################

# explore the relationship between the distance and average delay for each location

# Group flights by destination.
by_dest <- group_by(flights, dest)
by_dest

# Summarise to compute average distance, average arrival delay, and number of flights
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay

# Filter to remove noisy points and Honolulu airport, which is almost twice as far away as the next closest airport
delay <- filter(delay, count > 20, dest != "HNL")
delay

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)



delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

delays


### Missing values ###

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# We get a lot of missing values! 
# That’s because aggregation functions obey the usual rule of missing values
# if there’s any missing value in the input, the output will be a missing value.
# all aggregation functions have an na.rm argument 
# which removes the missing values prior to computation:

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))

# In this case, where missing values represent cancelled flights
# we could also tackle the problem by first removing the cancelled flights.


not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled


not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

### Counts ###

# Whenever you do any aggregation, 
# it’s always a good idea to include either a count (n()), 
# or a count of non-missing values (sum(!is.na(x)))

# let’s look at the planes (identified by their tail number) that have the highest average delays

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )
delays

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)


delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )
delays

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/20)



### Grouping by multiple variables ###

daily <- group_by(flights, year, month, day)

(per_day   <- summarise(daily, flights = n()))

(per_month <- summarise(per_day, flights = sum(flights)))

(per_year  <- summarise(per_month, flights = sum(flights)))


### ungroup ###

daily %>% 
  ungroup()

### Grouped mutates (and filters) ###

# Find all groups bigger than a threshold
# popular destinations

popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365) 

popular_dests


# Add a new variable "prop_delay" 

popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)

