rm(list = ls())
library(tidyverse)
library(ggplot2)
library(dplyr)
library(broom)
library(stats)
library(stargazer)
library(car)

# Load the data
dat <- read.csv("dat_CPS08.csv")
dat <- dat %>%
  mutate(age2 = age^2)

# Fit the model
model <- lm(log(ahe) ~ age + age2 + female + bachelor, data = dat)
stargazer(model, type = "latex", title = "Regression with age^2", out = "a.tex")

# Predicted log-earnings for a 30-year-old female with a bachelor's degree
new_data <- data.frame(age = 30, age2 = 30^2, female = 1, bachelor = 1)
predicted_log_earnings <- predict(model, newdata = new_data, type = "response")
predicted_log_earnings

# Problem b
expected_log <- log(20)

X_new <- matrix(c(1, 30, 30^2, 1, 1), nrow=1)
prediction_variance <- as.numeric(X_new %*% vcov(model) %*% t(X_new))
prediction_se <- sqrt(prediction_variance)

t_stat <- (predicted_log_earnings - expected_log) / prediction_se
p_value <- 2 * pt(-abs(t_stat), df=df.residual(model))  # 双尾检验

t_stat
p_value

# Problem c
ci_lower <- predicted_log_earnings + qt(0.025, df=df.residual(model)) * prediction_se
ci_upper <- predicted_log_earnings + qt(0.975, df=df.residual(model)) * prediction_se

ci_lower
ci_upper

# Problem d
ages <- data.frame(
  age = 20:65,
  female = 1,
  bachelor = 1
)

model2 <- lm(log(ahe) ~ age + female + bachelor, data=dat)

ages_df <- data.frame(
  age = 20:65,   # Range from 20 to 65 years
  female = rep(1, 46),    # Only females
  bachelor = rep(1, 46)   # Only those with a bachelor's degree
)

# Initialize vectors for storing predictions and confidence intervals
mean_log_earnings <- numeric(length = 46)
ci_lower <- numeric(length = 46)
ci_upper <- numeric(length = 46)

# Loop over each age to calculate predictions and confidence intervals
for (i in 1:46) {
  new_data <- data.frame(age = ages_df$age[i], female = 1, bachelor = 1)
  
  # Predict log-earnings
  predicted_log_earnings <- predict(model2, newdata = new_data, type = "response")
  mean_log_earnings[i] <- predicted_log_earnings
  
  # Calculate prediction variance and standard error
  X_new <- matrix(c(1, ages_df$age[i], 1, 1), nrow = 1)  # Correct matrix dimensions for a single prediction
  prediction_variance <- as.numeric(X_new %*% vcov(model2) %*% t(X_new))
  prediction_se <- sqrt(prediction_variance)
  
  # Calculate confidence intervals
  ci_lower[i] <- predicted_log_earnings + qt(0.025, df = df.residual(model2)) * prediction_se
  ci_upper[i] <- predicted_log_earnings + qt(0.975, df = df.residual(model2)) * prediction_se
}

# Prepare data frame for plotting
predictions_df <- data.frame(
  age = ages_df$age, 
  mean = mean_log_earnings, 
  lower = ci_lower, 
  upper = ci_upper
)

p <- ggplot(predictions_df, aes(x=age, y=mean)) +
  geom_line(color="blue", size=1) + 
  geom_ribbon(aes(ymin=lower, ymax=upper), fill="gray", alpha=0.5) +
  labs(x="Age", y="Log(AHE)",
       title="Age-Earnings Profile for Females with a Bachelor's Degree") +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  scale_x_continuous(breaks=seq(20, 65, 5)) +
  scale_y_continuous(limits=c(min(predictions_df$lower), max(predictions_df$upper))) 

print(p)

# Save the plot
ggsave("age_earnings_profile.png", plot=p, width=6, height=4, dpi=1000)

#Problem f
dat$female_age <- dat$female * dat$age
dat$female_age2 <- dat$female * dat$age2

interaction_formula <- log(ahe) ~ age + I(age^2) + female + bachelor + female_age + female_age2
interaction_model <- lm(interaction_formula, data=dat)

# summary(interaction_model)

stargazer(interaction_model, type = "latex", title = "Interaction Model of Age and Gender on Earnings", out = "f.tex")

anova(interaction_model)

sse_full <- sum(residuals(interaction_model)^2)
sse_reduced <- sum(lm(log(ahe) ~ age + I(age^2) + female + bachelor, data=dat)$residuals^2)
df_full <- nrow(dat) - length(coef(interaction_model))
df_reduced <- nrow(dat) - length(coef(lm(log(ahe) ~ age + I(age^2) + female + bachelor, data=dat)))
f_stat <- ((sse_reduced - sse_full) / (df_reduced - df_full)) / (sse_full / df_full)
pvalue <- 1 - pf(f_stat, df_reduced - df_full, df_full)

print(paste0("F-statistic: ", f_stat))
print(paste0("P-value: ", pvalue))

Anova(interaction_model, type="III")

wald_test_result <- waldtest(interaction_model, lm(log(ahe) ~ age + I(age^2) + female + bachelor, data=dat), test="F")
library(xtable)
print(xtable(wald_test_result), type = "latex", file = "wald_test.tex")