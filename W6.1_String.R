### R Workshop 6
### Strings
## Chamudi Kashmila

# Regular expressions are useful because strings usually contain unstructured or semi-structured data, 
# and regexps are a concise language for describing patterns in strings

# stringr package for string manipulation, which is part of the core tidyverse
library(tidyverse)

# Can create strings with either single quotes or double quotes
string1 <- "This is a string"
string1
string2 <- 'If I want to include a quote inside a string, I use single quotes'
string2

# To include a literal single or double quote in a string you can use \ to “escape” it ###

double_quote <- " include a literal \"double  quote\" in a string"
double_quote
single_quote <- 'include a literal \'single quote\' in a string'
single_quote

backslash <- " \\ to include a literal backslash, you need to double it up"

backslash

# printed representation of a string is not the same as string itself,
# because the printed representation shows the escapes. 
# To see the raw contents of the string, use writeLines()

writeLines(double_quote)
writeLines(single_quote)
writeLines(backslash)


# Multiple strings are often stored in a character vector, which you can create with c()

c("one", "two", "three")


### String length ###

# str_length() tells you the number of characters in a string



sl <- str_length(c("a", "R for data science", NA))

sl

### Combining strings ###

# To combine two or more strings, use str_c()

str_c("x", "y")

str_c("x", "y", "z")


# we use the sep argument to control how they’re separated

str_c("use", "the", "sep", "argument", "to", "separate")
str_c("use", "the", "sep", "argument", "to", "separate",sep = "-")


# Like most other functions in R, missing values are contagious. 
# If you want them to print as "NA", use str_replace_na()

x <- c("abc", NA)
str_c("|-", x, "-|")

str_c("|-", str_replace_na(x), "-|")


# Objects of length 0 are silently dropped. 
# This is particularly useful in conjunction with if:

name <- "Hadley"
time_of_day <- "morning"
birthday <- TRUE

str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)


# To collapse a vector of strings into a single string, use collapse

str_c(c("x", "y", "z"), collapse = ", ")

### Subsetting strings ###

# extract parts of a string using str_sub().

# As well as the string, str_sub() takes start and end arguments 
# which give the (inclusive) position of the substring

x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

# negative numbers count backwards from end
str_sub(x, -3, -1)

# str_sub() won’t fail if the string is too short:
# it will just return as much as possible

str_sub("a", 1, 5)

# can also use the assignment form of str_sub() to modify strings

# change the first letter to lower case
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x

### Locales ###

# changing case is more complicated 
# than it might at first appear because different languages have different rules 
# for changing case. You can pick which set of rules to use by specifying a locale

# Turkish has two i's: with and without a dot, and it
# has a different rule for capitalising them:
str_to_upper(c("i", "ı"))

### Matching patterns with regular expressions ###

# Regexps are a very terse language that allow you to describe patterns in strings

# To learn regular expressions, we’ll use str_view() and str_view_all(). 
# These functions take a character vector and a regular expression
# show you how they match

install.packages("htmlwidgets")
x <- c("apple", "banana", "pear")
str_view(x, "an")


# ., which matches any character (except a newline)
str_view(x, ".a.")


# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")

### Anchors ###

# Regular expressions will match any part of a string. 
# It’s often useful to anchor the regular expression 
# so that it matches from the start or end of the string.

# ^ to match the start of the string.
# $ to match the end of the string.

x <- c("apple", "banana", "pear", "pineapple", "blueberry" , "avocado", "peach")
str_view(x, "^p")

str_view(x, "e$")



x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")

# To force a regular expression to only match a complete string, anchor it with both ^ and $:

str_view(x, "^apple$")


### Character classes and alternatives ###

# There are a number of special patterns that match more than one character


# \d: matches any digit.
# \s: matches any whitespace (e.g. space, tab, newline).
# [abc]: matches a, b, or c.
# [^abc]: matches anything except a, b, or c.

# Look for a literal character that normally has special meaning in a regex
str_view(c("abc", "a.c", "a*c", "a c", "a.ck", "ma.c"), "a[.]c")

str_view(c("abc", "a.c", "a*c", "a c", "b*c", "k*c"), ".[*]c")

str_view(c("abc", "a.c", "a*c", "a c", "a b", "c k", "k a", "7 c"), ".[ ]")

# This works for most (but not all) regex metacharacters: $ . | ? * + ( ) [ {.


# You can use alternation to pick between one or more alternative patterns.

# For example, abc|d..f   will match either    ‘“abc”’, or "deaf".

# Note that the precedence for | is low, so that abc|xyz matches abc or xyz not abcyz or abxyz. 
# Like with mathematical expressions, if precedence ever gets confusing, use parentheses to make it clear


str_view(c("grey", "gray", "griy", "groy", "gruy"), "gr(e|a|u)y")


### Repetition ###

# The next step up in power involves controlling how many times a pattern matches

# ?: 0 or 1
# +: 1 or more
# *: 0 or more

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")

str_view(x, "CC+")


# You can also specify the number of matches precisely:
  
# {n}: exactly n
# {n,}: n or more
# {,m}: at most m
# {n,m}: between n and m


str_view(x, "C{2}")


str_view(x, "C{2,}")

str_view(x, "C{2,3}")


### Detect matches ###

# To determine if a character vector matches a pattern, use str_detect(). 
# It returns a logical vector the same length as the input

x <- c("apple", "banana", "pear")
str_detect(x, "e")


# when you use a logical vector in a numeric context, FALSE becomes 0 and TRUE becomes 1. 
# That makes sum() and mean() useful if you want to answer questions about matches across a larger vector

# How many common words start with t?
words
length(words)
str_detect(words, "^t")
sum(str_detect(words, "^t"))

# What proportion of common words end with a vowel?
sum(str_detect(words, "[aeiou]$"))
mean(str_detect(words, "[aeiou]$"))

# A common use of str_detect() is to select the elements that match a pattern.
# You can do this with logical subsetting, or the convenient str_subset() wrapper

words[str_detect(words, "x$")]

str_subset(words, "x$")


# A variation on str_detect() is str_count():
# rather than a simple yes or no, it tells you how many matches there are in a string

x <- c("apple", "banana", "pear")
str_count(x, "a")


# On average, how many vowels per word?
mean(str_count(words, "[aeiou]"))

### Extract matches ###

# To extract the actual text of a match, use str_extract()
sentences
length(sentences)

head(sentences)


# Imagine we want to find all sentences that contain a colour.
# We first create a vector of colour names, 
# and then turn it into a single regular expression:

colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match

# Now we can select the sentences that contain a colour,
# and then extract the colour to figure out which one it is:

has_colour <- str_subset(sentences, colour_match)
matches <- str_extract(has_colour, colour_match)
head(matches)


# Note that str_extract() only extracts the first match. 
# We can see that most easily by first selecting all the sentences that have more than 1 match:


more <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more, colour_match)



###  Replacing matches ###

# str_replace() and str_replace_all() allow you to replace matches with new strings.  
# The simplest use is to replace a pattern with a fixed string

x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")

str_replace_all(x, "[aeiou]", "-")

### Splitting ###

# Use str_split() to split a string up into pieces. 
# For example, we could split sentences into words


sentences %>%
  head(5) %>% 
  str_split(" ")


# we can use simplify = TRUE to return a matrix

sentences %>%
  head(5) %>% 
  str_split(" ", simplify = TRUE)

# we can also split up by character, line, sentence and word boundary()s

x <- "This is a sentence.  This is another sentence."
str_view_all(x, boundary("word"))































