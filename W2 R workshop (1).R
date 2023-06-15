## R workshop 2 -- AI Lab
#By Joori Almarzouki 


 ##### Importing data into R
#Uploading a CSV, text, or excel file from your computer:
#Uploading an from your computer:
#1. Click on the "Import Dataset" button in the Environment pane.
#2. Select "From Text (base)" if the file is a CSV or text file, and then navigate to the file on your computer.
#3. Follow the import wizard to specify the file format and other options.



# Importing required libraries
library(tidyverse)

# Load the diamonds dataset
data(diamonds)  #more info on the data: https://ggplot2.tidyverse.org/reference/diamonds.html

# look at the data:
head(diamonds)
str(diamonds)


# Check for missing values
#calculate the sum of is.na function

sum(is.na(diamonds))

# Remove any rows with missing values
# create a new set for cleaned data and omit null values (use na.omit).
diamonds_clean <- na.omit(diamonds)

# Check the dimensions of the cleaned dataset (dim finction)

dim(diamonds_clean)

# Check for duplicated rows
# count the sum if duplicated() function. 
sum(duplicated(diamonds_clean))

# Remove any duplicated rows 
diamonds_clean <- distinct(diamonds_clean)

# Check the dimensions of the final dataset
dim(diamonds_clean)

####################
##### Introduction to ggplot2 ####
?ggplot


#The structure: 
#ggplot(data = <DATA>) + 
#  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>)) +
#  <OPTIONAL_ADDITIONAL_LAYERS>
  

# Histogram of Price Values

ggplot(data=diamonds, aes(x=price)) +
  geom_histogram(fill="steelblue", color="black") +
  ggtitle("Histogram of Price Values")


#create scatterplot of carat vs. price, using cut as color variable
ggplot(data=diamonds, aes(x=carat, y=price, color=cut)) + 
  geom_point()


#create boxplot of price for each diamond cut
ggplot(data=diamonds, aes(x=cut, y=price)) + 
  geom_boxplot()


#Save the plot: 

#To save a plot in RStudio, you can simply click on the "Export" 
#button in the plot window and choose the file format you want to save it in.

#Alternatively, you can use the ggsave() function in your code to save
#the plot directly to a file. For example, ggsave("myplot.png") will save the 
#plot as a PNG file in your working directory.


### Your turn: 

#use the iris data set for the following: 
data(iris)

#Create a scatterplot with Sepal.Length on the x-axis and Petal.Length
#on the y-axis, with points colored by Species.
ggplot(data = iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
  geom_point() +
  ggtitle("Scatterplot of Sepal.Length vs. Petal.Length")


#Create a boxplot of Sepal.Length for each Species, with the boxes
#filled  a dark green color.
ggplot(data=iris, aes(x = Species, y = Sepal.Length)) + 
  geom_boxplot(fill="green")



#The stat_summary() function allows you to compute summary statistics of your data on the fly and plot them.
#requires two important arguments: fun and geom
#fun: "mean", "median", "max", "min", "sd", etc. 
#geom: "point", "bar", "line", etc.

## Mean Petal.Width for each Species
ggplot(data = iris, aes(x = Species, y = Petal.Width, fill = Species)) +
  stat_summary(fun = "mean", geom = "bar") +
  ggtitle("Mean Petal.Width for each Species") 
# You can do the same with other functions. 



# Conclusion
# Recap of key concepts learned in the workshop


# Suggestions for further learning and resources:
#Introduction to ggplot2: https://res.cloudinary.com/dyd911kmh/image/upload/v1666806657/Marketing/Blog/ggplot2_cheat_sheet.pdf

# Q&A session for participants to ask any remaining questions.
