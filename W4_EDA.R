### R Workshop 4
## Exploratory Data Analysis
## Chamudi Kashmila

install.packages("tidyverse")
library(tidyverse)

diamonds
view(diamonds)
?diamonds


## Visualising distributions ##

# A variable is categorical if it can only take one of a small set of values.
# To examine the distribution of a categorical variable, we use a bar chart

### graph ###
# With ggplot2, you begin a plot with the function 
# ggplot(). ggplot() creates a coordinate system that you can add layers to.
# The first argument of ggplot() is the dataset to use in the graph. 
# So ggplot(data = diamonds) creates an empty graph

# Each geom function in ggplot2 takes a mapping argument. 
# This defines how variables in your dataset are mapped to visual properties.
# The mapping argument is always paired with aes(), 
# and the x and y arguments of aes() specify which variables to map to the x and y axes. 
# ggplot2 looks for the mapped variables in the data argument

ggplot(data = diamonds) 

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

# The height of the bars displays how many observations occurred with each x value


# compute these values manually with dplyr::count()

diamonds %>% 
  count(cut)
############################Exercise###########################################
library(nycflights13)
flights
view(flights)
?flights


ggplot(data = flights) +
  geom_bar(mapping = aes(x = carrier))

flights %>%
  count(carrier)

################################################################################

# A variable is continuous if it can take any of an infinite set of ordered values.
# Numbers
# date-times 
# To examine the distribution of a continuous variable, we use a histogram

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)


# can compute this by hand by combining dplyr::count() and ggplot2::cut_width()

diamonds %>% 
  count(cut_width(carat, 0.5))




# histogram divides the x-axis into equally spaced bins 
# and then uses the height of a bar to display the number of observations that fall in each bin

# the tallest bar shows that almost 30,000 observations have a carat value between 0.25 and 0.75,
# which are the left and right edges of the bar.

############################Exercisec_2###########################################

faithful
view(faithful)
?faithful

ggplot(data = faithful) +
  geom_histogram(mapping = aes(x = eruptions), binwidth = 0.5)

faithful %>%
  count(cut_width(eruptions, 0.5))

################################################################################

# we can set the width of the intervals in a histogram with the binwidth argument
# it is measured in the units of the x variable
# explore a variety of binwidths when working with histograms, as different binwidths can reveal different patterns
# the graph above looks when we zoom into just the diamonds with a size of less than three carats and choose a smaller binwidth.


smaller <- diamonds %>% 
  filter(carat < 3)

smaller

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)


## multiple histograms in the same plot carot and cut ##

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_histogram(binwidth = 0.1)

# overlay multiple histograms in the same plot using geom_freqpoly() instead of geom_histogram()
# geom_freqpoly() performs the same calculation as geom_histogram(), 
# but instead of displaying the counts with bars, uses lines instead. 
# It’s much easier to understand overlapping lines than bars.

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)

## Typical values ##

# In both bar charts and histograms, 
# tall bars show the common values of a variable
# shorter bars show less-common values
# Places that do not have bars reveal values that were not seen in your data

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)


## Unusual values ##

# Outliers are observations that are unusual; data points that don’t seem to fit the pattern
# Sometimes outliers are data entry errors; other times outliers suggest important new science. 

# the distribution of the y variable from the diamonds dataset.

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

# outliers are sometimes difficult to see in a histogram. 

# To make it easy to see the unusual values
# we need to zoom to small values of the y-axis with coord_cartesian()

## coord_cartesian() contains the arguments xlim and ylim. 
# These arguments control the limits for the x- and y-axes and allow you to zoom in or out of your plot.
# c: Combine Values into a Vector or List

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

# This allows us to see that there are three unusual values: 0, ~30, and ~60. 

# We pluck them out with dplyr:

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)
unusual



## Missing values ##

# If we encountered unusual values in our dataset, and simply want to move on to the rest of our analysis, 
# we have two options
# 1. Drop the entire row with the strange values

diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))

diamonds2

# don’t recommend this option because just because one measurement is invalid, 
# doesn’t mean all the measurements are.
# Additionally, if you have low quality data,
# by time that you’ve applied this approach to every variable you might find that you don’t have any data left!


# 2. Replacing the unusual values with missing values.

# The easiest way to do this is to use mutate() to replace the variable with a modified copy.
# You can use the ifelse() function to replace unusual values with NA:


diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

diamonds2


# ifelse() has three arguments.
# The first argument test should be a logical vector. 
# The result will contain the value of the second argument,  
# yes, when test is TRUE,and the value of the third argument, no, when it is false.


ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()

# ggplot2 doesn’t include them in the plot, but it does warn that they’ve been removed


# To suppress that warning, set na.rm = TRUE

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)


## Covariation ##

# Variation describes the behavior within a variable
# Covariation describes the behavior between variables
# Covariation is the tendency for the values of two or more variables to vary together in a related way.
# The best way to spot covariation is to visualise the relationship between two or more variables.


### A categorical and continuous variable

# It’s common to want to explore the distribution of a continuous variable broken down by a categorical variable,
# default appearance of geom_freqpoly() is not that useful for that sort of comparison 
# because the height is given by the count. 
# That means if one of the groups is much smaller than the others, 
# it’s hard to see the differences in shape.

# explore how the price of a diamond varies with its quality

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

# hard to see the difference in distribution because the overall counts differ so much

# To make the comparison easier we need to swap what is displayed on the y-axis. 
# Instead of displaying count, we’ll display density,
# which is the count standardised so that the area under each frequency polygon is one.


ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)



# Alternative way to display the distribution of a continuous variable broken down by a categorical variable
# is the boxplot - visual shorthand for a distribution of values that is popular among statisticians

# Each boxplot consists of

# box that stretches from the 25th percentile of the distribution to the 75th percentile, 
# a distance known as the interquartile range (IQR). 
# the middle of the box is a line that displays the median - 50th percentile, of the distribution. 
# These three lines give you a sense of the spread of the distribution 
# and whether or not the distribution is symmetric about the median or skewed to one side.


ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()




### Two categorical variables 

# visualise the covariation between categorical variables,
# need to count the number of observations for each combination.
# One way to do that is to rely on the built-in geom_count()



ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

# The size of each circle in the plot displays how many observations occurred at each combination of values
# Covariation will appear as a strong correlation between specific x values and specific y values



###### Another approach ######

# compute the count with dplyr 

diamonds %>% 
  count(color, cut)


# Then visualise with geom_tile() and the fill aesthetic

diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))


### Two continuous variables 

# draw a scatterplot with geom_point(). 
# we can see covariation as a pattern in the points
# we can see an exponential relationship between the carat size and price of a diamond.

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))

# Scatterplots become less useful as the size of your dataset grows,
# because points begin to overplot, and pile up into areas of uniform black (as above). 
# one way to fix the problem: using the alpha aesthetic to add transparency.

ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price), alpha = 1 / 100)

# Using transparency can be challenging for very large datasets. 
# Another solution is to use bin. 

# Previously we used geom_histogram() and geom_freqpoly() to bin in one dimension.

# we use geom_bin2d() and geom_hex() to bin in two dimensions

# divide the coordinate plane into 2d bins and then use a fill color to display how many points fall into each bin.
# geom_bin2d() creates rectangular bins.
# geom_hex() creates hexagonal bins.


ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

# You will need to install the hexbin package to use geom_hex()

install.packages("hexbin")
ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))



 

