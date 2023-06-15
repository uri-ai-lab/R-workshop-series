### R Workshop 6
## Date and Times
## Chamudi Kashmila

# focus on the lubridate package, which makes it easier to work with dates and times in R. 
# lubridate is not part of core tidyverse because you only need it when you’re working with dates/times.

library(tidyverse)

library(lubridate)
library(nycflights13)

## Creating date/times

# There are three types of date/time data that refer to an instant in time:
  
# A date. Tibbles print this as <date>.

# A time within a day. Tibbles print this as <time>.

# A date-time is a date plus a time: it uniquely identifies an instant in time (typically to the nearest second). 



# To get the current date or date-time you can use today() or now()

today()
now()


# There are three ways you’re likely to create a date/time:
  
# From a string.
# From individual date-time components.
# From an existing date/time object


## From a string ##


# Another approach is to use the helpers provided by lubridate. 
# They automatically work out the format once you specify the order of the component. 
# To use them, identify the order in which year, month, and day appear in your dates, 
# then arrange “y”, “m”, and “d” in the same order. 
# That gives you the name of the lubridate function that will parse your date.


ymd("2017-01-31")

mdy("January 31st, 2017")

dmy("31-Jan-2017")

# These functions also take unquoted numbers.
 
ymd(20220811)



####### Date-time components #######
datetime <- ymd_hms("2022-08-11 11:53:09")
datetime
year(datetime)

month(datetime)

mday(datetime)


yday(datetime)

wday(datetime)

# For month() and wday() you can set label = TRUE to return the abbreviated name of the month or day of the week.
# Set abbr = FALSE to return the full name
month(datetime, label = TRUE)

wday(datetime, label = TRUE, abbr = FALSE)

### Setting components ###


(datetime <- ymd_hms("2016-07-08 12:34:56"))

year(datetime) <- 2020
datetime

month(datetime) <- 01
datetime

hour(datetime) <- hour(datetime) + 1
datetime


# Alternatively, rather than modifying in place, you can create a new date-time with update()

update(datetime, year = 2020, month = 2, mday = 2, hour = 2)

### Time spans ###

# how arithmetic with dates works, including subtraction, addition, and division.
#  3 important classes that represent time spans:

# durations, which represent an exact number of seconds.
# periods, which represent human units like weeks and months.
# intervals, which represent a starting and ending point.


# How old is Hadley?
h_age <- today() - ymd(19791014)
h_age

# Durations come with a bunch of convenient constructors

dseconds(15)

dminutes(10)

dhours(c(12, 24))

ddays(0:5)

dweeks(3)

dyears(1)

# we can add and multiply durations

2 * dyears(1)

dyears(1) + dweeks(12) + dhours(15)


# we can add and subtract durations to and from days
tomorrow <- today() + ddays(1)
tomorrow
last_year <- today() - dyears(1)
last_year

# because durations represent an exact number of seconds,
# sometimes you might get an unexpected result

one_pm <- ymd_hms("2016-03-12 13:00:00", tz = "America/New_York")

one_pm

one_pm + ddays(1)

# Because of DST, March 12 only has 23 hours,
# so if we add a full days worth of seconds we end up with a different time

###  Periods ###

# To solve this problem, lubridate provides periods. 
# Periods are time spans but don’t have a fixed length in seconds, 
# instead they work with “human” times, like days and months.


one_pm

one_pm + days(1)

# Like durations, periods can be created with a number of friendly constructor functions.

seconds(15)

minutes(10)

hours(c(12, 24))

days(7)

months(1:6)

weeks(3)

years(1)


# You can add and multiply periods

10 * (months(6) + days(1))

days(50) + hours(25) + minutes(2)


### Intervals ###


years(1) / days(1)

# If you want a more accurate measurement,you’ll have to use an interval. 
# An interval is a duration with a starting point:
# that makes it precise so you can determine exactly how long it is:

today()
next_year <- today() + years(1)
next_year
today() %--% next_year
(today() %--% next_year) / ddays(1)

























