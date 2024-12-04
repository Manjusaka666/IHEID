rm(list=ls())

# Load necessary libraries
library(tidyverse)
library(readr)
library(dplyr)
library(broom)
library(ggplot2)
library(xtable)
library(stargazer)
library(lmtest)
library(sandwich)

# Load the data
data <- read_csv("dat_CPS08.csv")

# Part (a): Gender and Education Based Wage Differentials
avg_ahe_gender = aggregate(ahe ~ female, data = data, FUN = mean)

c(avg_ahe_gender)

avg_ahe_education = aggregate(ahe ~ bachelor, data = data, FUN = mean)

c(avg_ahe_education)


gender_model <- lm(ahe ~ female, data=data)
education_model <- lm(ahe ~ bachelor, data=data)

gender_coeff <- coef(gender_model)["female"]
education_coeff <- coef(education_model)["bachelor"]

# Conduct hypothesis tests to compare averages and compute 95% confidence intervals
#gender_ttest <- coeftest(gender_model, vcov = vcovHC(gender_model, type="HC"))
#education_ttest <- coeftest(education_model, vcov = vcovHC(education_model, type="HC"))

c(gender_coeff, 
  education_coeff
)

# Output the results in LaTeX format using stargazer
stargazer(gender_model, education_model, type = "latex", title = "Regression Results for Gender and Education", out = "a.tex")

# Part (b): Regression Analysis of Earnings on Age, Gender, and Education
age_model <- lm(ahe ~ age + female + bachelor, data=data)
age_coeff <- coef(age_model)["age"]
# Expected change in earnings from age 28 to 29 and from 37 to 38
change_28_to_29 <- age_coeff * 1  # Increment by one year
change_37_to_38 <- age_coeff * 1  # Increment by one year
stargazer(age_model, type = "latex", title = "Regression Results for Age, Gender, and Education", out = "b.tex")

# Part (c): Regression of Logarithm of Earnings
data$log_ahe <- log(data$ahe)
log_age_model <- lm(log_ahe ~ age + female + bachelor, data=data)
log_age_coeff <- coef(log_age_model)["age"]
# Expected percentage change in earnings from age 28 to 29 and from 37 to 38
percent_change_28_to_29 <- (exp(log_age_coeff)-1) * 100
percent_change_37_to_38 <- (exp(log_age_coeff)-1) * 100
list(
  percent_change_28_to_29 = percent_change_28_to_29,
  percent_change_37_to_38 = percent_change_37_to_38
)
stargazer(log_age_model, type = "latex", title = "Logarithm of Earnings Regression", out = "c.tex")

# Part (d): Log Earnings on Gender, Education, and Log of Age
data$log_age <- log(data$age)
log_age_transform_model <- lm(log_ahe ~ log_age + female + bachelor, data=data)
log_age_transform_coeff <- coef(log_age_transform_model)["log_age"]
approx_percent_change_28_to_29 <- log_age_transform_coeff * (log(29) - log(28)) * 100
approx_percent_change_37_to_38 <- log_age_transform_coeff * (log(38) - log(37)) * 100
list(
  log_age_transform_coeff = log_age_transform_coeff,
  approx_percent_change_28_to_29 = approx_percent_change_28_to_29,
  approx_percent_change_37_to_38 = approx_percent_change_37_to_38
)
stargazer(log_age_transform_model, type = "latex", title = "Log Earnings on Log Age, Gender, and Education", out = "d.tex")

# Part (e): Quadratic Age Effects in Earnings Regression
data$age2 <- data$age^2
age_quadratic_model <- lm(log_ahe ~ age + age2 + female + bachelor, data=data)
age_quadratic_coeff <- coef(age_quadratic_model)["age"]
age2_quadratic_coeff <- coef(age_quadratic_model)["age2"]
percent_change_quadratic_28_to_29 <- (exp(age_quadratic_coeff + 2 * age2_quadratic_coeff * 28)-1) * 100
percent_change_quadratic_37_to_38 <- (exp(age_quadratic_coeff + 2 * age2_quadratic_coeff * 37)-1) * 100
stargazer(age_quadratic_model, type = "latex", title = "Quadratic Age Effects in Earnings Regression", out = "e.tex")
list(
  age_quadratic_coeff = age_quadratic_coeff,
  age2_quadratic_coeff = age2_quadratic_coeff,
  percent_change_quadratic_28_to_29 = percent_change_quadratic_28_to_29,
  percent_change_quadratic_37_to_38 = percent_change_quadratic_37_to_38
)

# Part (f): Plotting the Age-Earnings Profile
age_range <- 20:65
predicted_earnings <- predict(age_quadratic_model, newdata = data.frame(age = age_range, age2 = age_range^2, female = 0, bachelor = 1))
peak_age <- age_range[which.max(predicted_earnings)]
list(peak_age = peak_age)

ggplot(data.frame(age = age_range, earnings =predicted_earnings), aes(x=age, y=earnings)) +
  geom_line(color="blue") +
  geom_point(aes(x=peak_age, y=max(predicted_earnings)), color="red") +
  labs(title="Age-Earnings Profile for Males with a Bachelor's Degree", x="Age", y="log_ahe")

cat(sprintf("Peak age for earnings: %d", peak_age), sep="\n")

# Part (g): Effect of Age on Earnings for Males vs. Females
data$age_female <- data$age * data$female
interaction_model <- lm(log_ahe ~ age + female + bachelor + age_female, data=data)
interaction_coeff <- coef(interaction_model)["age_female"]
percent_change_interaction = (exp(interaction_coeff) - 1) * 100
list(
  interaction_coeff = interaction_coeff,
  percent_change_interaction = percent_change_interaction
)
stargazer(interaction_model, type = "latex", title = "Interaction Model of Age and Gender on Earnings", out = "g.tex")
