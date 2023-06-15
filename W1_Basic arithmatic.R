# Workshop 1
# Using R as a calculator
## Chamudi Kashmila

# Basic arithmetic
4+2
3*6
10-8
15/5


# When using R as a calculator, the order of operations is the same as you would have learned back in school.

# From highest to lowest precedence:
  
# Parentheses: (, )
# Exponents: ^ or **
# Multiply: *
# Divide: /
# Add: +
# Subtract: -


3+5 * 2
(3+5)*2

(3 + (5 * (2 ^ 2))) # hard to read
3 + 5 * 2 ^ 2       # clear, if you remember the rules
3 + 5 * (2 ^ 2)     # if you forget some rules, this might help



# Variables and assignment

# We can store values in variables using the assignment operator <-

a <- 6
a


b <- 1/4

# Notice that assignment does not print a value. 
# Instead, we stored it for later in something called a variable. 
# b now contains the value 0.025

b

log(b)


c <- 6
c

# variables can be reassigned

a <- 10

d <- a+2
d

e <- a*4
e


# It is also possible to use the = operator for assignment
f = a/4
f
# But this is much less common among R users.
# The most important thing is to be consistent with the operator you use.
# There are occasionally places where it is less confusing to use <- than = 
# and it is the most common symbol used in the community. 
# So the recommendation is to use <-.


#### Variable Names ####

# A variable can have a short name (like x and y) or a more descriptive name (age, carname, total_volume).
# Rules for R variables are
# A variable name must start with a letter 
# and can be a combination of letters, digits, period(.) and underscore(_). 
# If it starts with period(.), it cannot be followed by a digit. 
# A variable name cannot start with a number or underscore (_) Variable names are case-sensitive (age, Age and AGE are three different variables) 
# Reserved words cannot be used as variables (TRUE, FALSE, NULL, if...)

# Which of the following are valid R variable names?

# min_height
# max.height
# _age
# .mass
# MaxLength
# min-length
# 2widths
# celsius2kelvin


#### Vectorization ####
# R is vectorized, meaning that variables and functions can have vectors as values. 
# In contrast to physics and mathematics, a vector in R describes a set of values in a certain order of the same data type.

1:6

2^(1:6)

x <- 1:8
2^x

#cjdkcdjcldscdcld

