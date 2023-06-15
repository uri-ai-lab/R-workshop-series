### R Workshop 5
## Tidy Data with tidy
## Chamudi Kashmila

# learn a consistent way to organise your data in R, an organisation called tidy data. 
# Getting your data into this format requires some upfront work
# but that work pays off in the long term.
# allowing you to spend more time on the analytic questions at hand

# practical introduction to tidy data and the accompanying tools in the tidyr package

# tidyr, a package that provides a bunch of tools to help tidy up your messy datasets
# tidyr is a member of the core tidyverse

library(tidyverse)

# We can represent the same underlying data in multiple ways

# Each dataset shows the same values of four variables country, year, population, and cases,
# but each dataset organises the values in a different way.


table1
table2
table3
table4a
table4b


# There are three interrelated rules which make a dataset tidy:

# 1. Each variable must have its own column.
# 2. Each observation must have its own row.
# 3. Each value must have its own cell.


# dplyr, ggplot2, and all the other packages in the tidyverse are designed to work with tidy data

# Compute rate per 10,000
table1 %>% 
  mutate(rate = cases / population * 10000)

# Compute cases per year
table1 %>% 
  count(year, wt = cases)

# Compute population per year
table1 %>% 
  count(year, wt = population)


# Visualise changes over time

library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "black") + 
  geom_point(aes(colour = country))


 ### Pivoting ###

# most real analyses, we need to do some tidying. 
# The first step is always to figure out what the variables and observations are. 

# The second step is to resolve one of two common problems:

###### One variable might be spread across multiple columns.
###### One observation might be scattered across multiple rows.

## To fix these problems, we need the two most important functions in tidyr: 
# pivot_longer() 
# pivot_wider()

### pivot_longer()

# common problem is a dataset where some of the column names are not names of variables,
# but values of a variable

table4a

# the column names 1999 and 2000 represent values of the year variable
# the values in the 1999 and 2000 columns represent values of the cases variable, 
# and each row represents two observations, not one.

#  we need to pivot the offending columns into a new pair of variables.

# The set of columns whose names are values, not variables. 
# In this example, those are the columns 1999 and 2000.

# The name of the variable to move the column names to. Here it is year.

# The name of the variable to move the column values to. Here it’s cases.

table4a
table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")


# pivot_longer() makes datasets longer by increasing the number of rows 
# and decreasing the number of columns.  

table4b
table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")



# To combine the tidied versions of table4a and table4b into a single tibble
# we need to use dplyr::left_join()

tidy4a <- table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

tidy4b <- table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

left_join(tidy4a, tidy4b)

### pivot_wider() 

# pivot_wider() is the opposite of pivot_longer()

# use it when an observation is scattered across multiple rows. 
# table2:
# an observation is a country in a year, but each observation is spread across two rows.

# To tidy this up, 
# we first analyse the representation in similar way to pivot_longer(). 
# This time, however, we only need two parameters:
  
# The column to take variable names from. Here, it’s type.

# The column to take values from. Here it’s count.

# Once we’ve figured that out, we can use pivot_wider(), as shown programmatically below, 

table2
table2 %>%
  pivot_wider(names_from = type, values_from = count)

# pivot_longer() makes wide tables narrower and longer
# pivot_wider() makes long tables shorter and wider

### Separating and uniting ###

# table3 has a different problem
# we have one column (rate) that contains two variables (cases and population).
# To fix this problem, 
# we’ll need the separate() function. 
# You’ll also learn about the complement of separate(): unite(),
# which you use if a single variable is spread across multiple columns.

### Separate

# separate() pulls apart one column into multiple columns, 
# by splitting wherever a separator character appears

table3
# rate column contains both cases and population variables
# we need to split it into two variables. 
# separate() takes the name of the column to separate, and the names of the columns to separate

table3 %>% 
  separate(rate, into = c("cases", "population"))


# separate() will split values wherever it sees a non-alphanumeric character
# (i.e. a character that isn’t a number or letter). 
# For example, in the code above, separate() split the values of rate at the forward slash characters. 
# If you wish to use a specific character to separate a column,
# you can pass the character to the sep argument of separate().


table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")


# if you look carefully at column types, cases and population are character columns
# This is the default behaviour in separate(): it leaves the type of the column as is
# it’s not very useful as those really are numbers.
# to try and convert to better types using convert = TRUE

table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)

# You can also pass a vector of integers to sep. 
# separate() will interpret the integers as positions to split at.

# Positive values start at 1 on the far-left of the strings;
# negative value start at -1 on the far-right of the strings.


# To separate the last two digits of each year. 
# This make this data less tidy, but is useful in other cases,

table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

### Unite

# We can use unite() to rejoin the century and year columns that we created in the last example.

# That data is saved as tidyr::table5.
# unite() takes a data frame, the name of the new variable to create, and a set of columns to combine

table5
table5 %>% 
  unite(new, century, year)


# The default will place an underscore (_) between the values from different columns.
# Here we don’t want any separator so we use ""

table5 %>% 
  unite(new, century, year, sep = "")


### Missing values

# Changing the representation of a dataset brings up an important subtlety of missing values. 
# a value can be missing in one of two possible ways:

## Explicitly, i.e. flagged with NA.
## Implicitly, i.e. simply not present in the data.


stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks

# There are two missing values in this dataset:
  
# The return for the fourth quarter of 2015 is explicitly missing, 
# because the cell where its value should be instead contains NA.

# The return for the first quarter of 2016 is implicitly missing,
# because it simply does not appear in the dataset.


### Make implicit values explicit ###


# The way that a dataset is represented can make implicit values explicit. 
# For example, we can make the implicit missing value explicit by putting years in the columns

stocks %>% 
  pivot_wider(names_from = year, values_from = return)


### Make explicit values implicit ###

# these explicit missing values may not be important in other representations of the data, 
# you can set values_drop_na = TRUE in pivot_longer() to turn explicit missing values implicit:

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = TRUE
  )


# Another important tool for making missing values explicit in tidy data is complete()

stocks %>% 
  complete(year, qtr)

# complete() takes a set of columns, and finds all unique combinations. 
# It then ensures the original dataset contains all those values, 
# filling in explicit NAs where necessary

# When a data source has primarily been used for data entry,
# missing values indicate that the previous value should be carried forward


treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  NA,           4,
  "Riva", 1,           2,
  NA,                 2,           3,
  NA,                 3,           NA,
  NA,                 3,           NA
)

treatment

# We can fill in these missing values with fill().
# It takes a set of columns where you want missing values to be replaced 
# by the most recent non-missing value (sometimes called last observation carried forward).

treatment %>% 
  fill(person)

treatment %>% 
  fill(person, treatment)


 

