rm(list=ls())
cat("\f")

data(mtcars)

#1.1 Load the ”mtcars” dataset.

#1.2 Find out how many observations and how many variables are in the dataset.

ncol(mtcars)
nrow(mtcars)
summary(mtcars)

#1.3 Use the ”select()” function from ”dplyr” package to select the columns mpg, cyl, and hp from the mtcars dataset.

install.packages("dplyr")
library(dplyr)

mtcars %>% select('mpg', 'cyl', 'hp')

#1.4 Keep only the rows where the number of cylinders (cyl) is 6 and horsepower (hp) is greater than 100 from the mtcars dataset.

mtcars %>% filter(cyl == 6, hp > 100)


#1.5 Create a new column hp per cyl, which is the ratio of horsepower (hp) to the number of cylinders (cyl).

mtcars$hp_per_cyl <- mtcars$hp / mtcars$cyl

#1.6 Use ”group by()” and ”summarize()” to find the average miles per gallon (mpg) for each number of cylinders (cyl).

avg_mpg_by_cyl <- mtcars %>%
  group_by(cyl) %>%
  summarize(avg_mpg = mean(mpg))

#2.1 Create a scatter plot of mpg versus hp, colored by the number of cylinders (cyl).

install.packages("ggplot2")
library(ggplot2)

  ggplot(mtcars, aes(x = mpg, y = hp, color= as.factor(cyl))) +
    geom_point(size = 2, color = "black") +
    labs(title = "scatterplot of mpg versus hp, colored by the number of cylinders",
         x = "miles per gallon",
         y = "horsepower")

#2.2 Create a boxplot showing the distribution of mpg for each number of cylinders (cyl).

  ggplot(mtcars, aes(x = as.factor(cyl), y = mpg)) +
    geom_boxplot(fill = "white", color = "grey") +
    labs(title = "Boxplot of mpg for each number of cylinders",
         x = "Number of Cylinders",
         y = "miles per gallon") 

#2.3 Create a histogram of the mpg variable, with bin sizes of 2.

  ggplot(mtcars, aes(x = mpg)) +
    geom_histogram(binwidth=2, color = "grey", fill="white") +
    labs(title = "Histogram of mpg variable",
         y = "count or frequency") 

#3.1 Calculate the mean of mpg and hp in the mtcars dataset.
  
mean(mtcars$mpg)
mean(mtcars$hp)
  
#3.2 Use the var() function to calculate the variance of mpg and hp.
  
var(mtcars$mpg)
var(mtcars$hp)

#3.3 Use the cov() function to calculate the covariance between mpg and hp.

cov(mtcars$mpg, mtcars$hp)

#3.4 Use the cor() function to calculate the correlation between mpg and hp.

cor(mtcars$mpg, mtcars$hp)


car_names <- data.frame(
  car_model = rownames(mtcars),
  origin= c(rep('USA', 10), rep('Europe', 10), rep('Japan', 12))
)

mtcars$car_model <- rownames(mtcars)
dfBoth = merge(mtcars, car_names, by='car_model')

install.packages("tidyr")
library(tidyr)
long_format <- pivot_longer(mtcars, 
                  cols = -car_model, 
                  names_to = "variable", 
                  values_to = "value")

short_format <- pivot_wider(long_format,
                   names_from = "variable", 
                   values_from = "value")

#4.1 Use the ”lm()” function to fit an OLS regression model predicting mpg based on hp and wt.

model <- lm(mpg ~ hp + wt, data = mtcars)

#4.2 Use the ”summary()” function to display the summary of the regression model.

summary(model)

#4.3 Use the ”predict()” function to predict mpg for a car with 150 horsepower (hp) and a weight (wt) of 3.0.

newobs = data.frame(hp = 150, wt = 3.0)
predict(model, newobs)
