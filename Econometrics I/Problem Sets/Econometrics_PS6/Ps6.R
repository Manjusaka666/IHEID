setwd("E:/IHEID国际经济学硕士/IHEID/Econometrics I/Problem Sets/Econometrics_PS6")
rm(list = ls())
library(tidyverse)
library(ggplot2)
library(dplyr)
library(broom)
library(stats)
library(stargazer)
library(car)

set.seed(2024)

# Load the data
dat <- read.csv("dat_SalesCustomers.csv")

# Display the number of missing values in each variable
variables_to_check <- c("category", "price", "gender", "age", "payment_method")
missing_counts <- sapply(dat[variables_to_check], function(x) sum(is.na(x)))
print("Number of missing values in each variable:")
print(missing_counts)
# Remove observations with missing values in the specified variables
dat_clean <- dat[complete.cases(dat[variables_to_check]), ]
# Get the number of observations left
num_observations <- nrow(dat_clean)
print(paste("Number of observations after removing missing values:", num_observations))

# (b)
# Create the "paid_in_cash" dummy variable
dat_clean$paid_in_cash <- ifelse(dat_clean$payment_method == "Cash", 1, 0)

# Create the "male" dummy variable
dat_clean$male <- ifelse(dat_clean$gender == "Male", 1, 0)

# Calculate the fraction of transactions carried out in cash
fraction_cash_transactions <- mean(dat_clean$paid_in_cash)
print(paste("Fraction of transactions carried out in cash:", 
            round(fraction_cash_transactions * 100, 2), "%"))

# Calculate the fraction of overall sales (in TRY) carried out in cash
total_sales <- sum(dat_clean$price)
cash_sales <- sum(dat_clean$price[dat_clean$paid_in_cash == 1])
fraction_cash_sales <- cash_sales / total_sales
print(paste("Fraction of overall sales carried out in cash:", 
            round(fraction_cash_sales * 100, 2), "%"))

# (c)
# Consider only the first 1000 observations
dat_1000 <- dat_clean[1:1000, ]

# Create category dummies
dat_1000$clothes_shoes <- ifelse(dat_1000$category %in% c("Clothing", "Shoes"), 1, 0)
dat_1000$cosmetics <- ifelse(dat_1000$category == "Cosmetics", 1, 0)
dat_1000$food <- ifelse(dat_1000$category %in% c("Food", "Food & Beverage"), 1, 0)
dat_1000$technology <- ifelse(dat_1000$category == "Technology", 1, 0)

# Create a dummy for "other" categories
dat_1000$other_category <- ifelse(dat_1000$clothes_shoes + dat_1000$cosmetics + dat_1000$food + dat_1000$technology == 0, 1, 0)

# Ensure each observation belongs to one category
all(dat_1000$clothes_shoes + dat_1000$cosmetics + dat_1000$food + dat_1000$technology + dat_1000$other_category == 1)

# Calculate the fraction of transactions in each category
fraction_transactions <- c(
  "Clothes and Shoes" = mean(dat_1000$clothes_shoes),
  "Cosmetics" = mean(dat_1000$cosmetics),
  "Food" = mean(dat_1000$food),
  "Technology" = mean(dat_1000$technology),
  "Other" = mean(dat_1000$other_category)
)
print("Fraction of transactions in each category:")
print(round(fraction_transactions * 100, 2))

# Calculate the fraction of sales in each category
total_sales_1000 <- sum(dat_1000$price)
sales_clothes_shoes <- sum(dat_1000$price[dat_1000$clothes_shoes == 1])
sales_cosmetics <- sum(dat_1000$price[dat_1000$cosmetics == 1])
sales_food <- sum(dat_1000$price[dat_1000$food == 1])
sales_technology <- sum(dat_1000$price[dat_1000$technology == 1])
sales_other <- sum(dat_1000$price[dat_1000$other_category == 1])

fraction_sales <- c(
  "Clothes and Shoes" = sales_clothes_shoes / total_sales_1000,
  "Cosmetics" = sales_cosmetics / total_sales_1000,
  "Food" = sales_food / total_sales_1000,
  "Technology" = sales_technology / total_sales_1000,
  "Other" = sales_other / total_sales_1000
)
print("Fraction of sales in each category:")
print(round(fraction_sales * 100, 2))

# (d)
### Manual Method
# Exclude "other_category" to avoid multicollinearity
X <- as.matrix(cbind(1, dat_1000[, c("price", "male", "age", "clothes_shoes", "cosmetics", "food", "technology")]))
y <- dat_1000$paid_in_cash

# Define the negative log-likelihood function
neg_log_likelihood <- function(beta, X, y) {
  X_beta <- X %*% beta
  log_phi_Xb <- pnorm(X_beta, log.p = TRUE)
  log_phi_minus_Xb <- pnorm(-X_beta, log.p = TRUE)
  ll <- sum(y * log_phi_Xb + (1 - y) * log_phi_minus_Xb)
  return(-ll)
}

# Define the gradient of the negative log-likelihood function
neg_log_likelihood_grad <- function(beta, X, y) {
  X_beta <- X %*% beta
  phi_Xb <- dnorm(X_beta)
  Phi_Xb <- pnorm(X_beta)
  Phi_minus_Xb <- pnorm(-X_beta)
  epsilon <- 1e-16
  Phi_Xb <- pmax(Phi_Xb, epsilon)
  Phi_minus_Xb <- pmax(Phi_minus_Xb, epsilon)
  gradient <- -t(X) %*% ((y * phi_Xb / Phi_Xb) - ((1 - y) * phi_Xb / Phi_minus_Xb))
  return(as.vector(gradient))
}

# Initial values for beta
initial_beta <- rep(0, ncol(X))

# Optimize using optim with gradient
result <- optim(par = initial_beta, fn = neg_log_likelihood, gr = neg_log_likelihood_grad, X = X, y = y, method = "BFGS")

# Check convergence
if (result$convergence == 0) {
  cat("Optimization converged.\n")
} else {
  cat("Optimization did not converge.\n")
}

# Estimated coefficients
beta_hat <- result$par
print("Estimated coefficients (beta_hat):")
print(beta_hat)

### Programming method
# Use built-in function for probit model
model <- glm(paid_in_cash ~ price + male + age + clothes_shoes + cosmetics + food + technology, 
             data = dat_1000, family = binomial(link = "probit"))
stargazer(model, type = "latex", title = "Optimization model", out = "d.tex")
# Estimated coefficients
beta_hat2 <- coef(model)
print("Estimated coefficients (beta_hat):")
print(beta_hat2)

# (e)
### Gamma1
# x_i for age = 30
x_age_30 <- c(1, 500, 1, 30, 1, 0, 0, 0)

# x_i for age = 35
x_age_60 <- x_age_30
x_age_60[4] <- 60  # Update age to 35

# Compute the probabilities
prob_age_30 <- pnorm(sum(x_age_30 * beta_hat))
prob_age_60 <- pnorm(sum(x_age_60 * beta_hat))

gamma_1 <- prob_age_60 - prob_age_30
print(paste("Gamma_1 (effect of age increasing by 5 years):", gamma_1))

### Gamma2
gamma_c <- numeric(length(fraction_sales))
names(gamma_c) <- names(fraction_sales)

for (cat in names(fraction_sales)) {
  # Set category dummies
  clothes_shoes <- ifelse(cat == "Clothes and Shoes", 1, 0)
  cosmetics <- ifelse(cat == "Cosmetics", 1, 0)
  food <- ifelse(cat == "Food", 1, 0)
  technology <- ifelse(cat == "Technology", 1, 0)
  
  # x_i for age = 30
  x_age_30_2 <- c(1, 500, 1, 30, clothes_shoes, cosmetics, food, technology)
  x_age_60_2 <- x_age_30_2
  x_age_60_2[4] <- 60  # Update age to 35
  
  # Compute probabilities
  prob_age_30_2 <- pnorm(sum(x_age_30_2 * beta_hat))
  prob_age_60_2 <- pnorm(sum(x_age_60_2 * beta_hat))
  
  gamma_c[cat] <- prob_age_60_2 - prob_age_30_2
}

# Compute gamma_2(beta_hat) as weighted average
gamma_2 <- sum(fraction_sales * gamma_c)
print(paste("Gamma_2 (weighted effect over categories):", gamma_2))

# (g)
# Number of bootstrap samples
M <- 100
n <- nrow(dat_1000)  # Should be 1000

print(n)

# Initialize vectors to store bootstrap estimates
beta_age_bootstrap <- numeric(M)
gamma_1_bootstrap <- numeric(M)
gamma_2_bootstrap <- numeric(M)

set.seed(2024)  # For reproducibility

for (m in 1:M) {
  # Sample with replacement
  indices <- sample(1:n, size = n, replace = TRUE)
  dat_bootstrap <- dat_1000[indices, ]
  
  # Estimate the probit model
  model_boot <- glm(paid_in_cash ~ price + male + age + clothes_shoes + cosmetics + food + technology, data = dat_bootstrap, family = binomial(link = "probit"))
  beta_hat_boot <- coef(model_boot)
  
  # Store the coefficient on "age"
  beta_age_bootstrap[m] <- beta_hat_boot["age"]
  
  # Compute gamma_1(beta_hat)
  x_age_30 <- c(1, 500, 1, 30, 1, 0, 0, 0)
  x_age_60 <- x_age_30
  x_age_60[4] <- 60  # Update age to 35
  prob_age_30 <- pnorm(sum(x_age_30 * beta_hat_boot))
  prob_age_60 <- pnorm(sum(x_age_60 * beta_hat_boot))
  gamma_1_bootstrap[m] <- prob_age_60 - prob_age_30
  
  # Compute gamma_2(beta_hat)
  gamma_c <- numeric(length(fraction_sales))
  names(gamma_c) <- names(fraction_sales)
  
  for (cat in names(fraction_sales)) {
    clothes_shoes <- ifelse(cat == "Clothes and Shoes", 1, 0)
    cosmetics <- ifelse(cat == "Cosmetics", 1, 0)
    food <- ifelse(cat == "Food", 1, 0)
    technology <- ifelse(cat == "Technology", 1, 0)
    
    x_age_30_2 <- c(1, 500, 1, 30, clothes_shoes, cosmetics, food, technology)
    x_age_60_2 <- x_age_30
    x_age_60_2[4] <- 60  # Update age to 35
    
    prob_age_30_2 <- pnorm(sum(x_age_30_2 * beta_hat_boot))
    prob_age_60_2 <- pnorm(sum(x_age_60_2 * beta_hat_boot))
    gamma_c[cat] <- prob_age_60_2 - prob_age_30_2
  }
  
  gamma_2_bootstrap[m] <- sum(fraction_sales * gamma_c)
}

# Plot the distributions
hist(beta_age_bootstrap, main = "Bootstrap Distribution of Coefficient on Age", xlab = "Coefficient on Age", breaks = 20)
hist(gamma_1_bootstrap, main = "Bootstrap Distribution of Gamma_1", xlab = "Gamma_1", breaks = 20)
hist(gamma_2_bootstrap, main = "Bootstrap Distribution of Gamma_2", xlab = "Gamma_2", breaks = 20)

# (h)
# Compute H_hat
X <- as.matrix(cbind(1, dat_1000[, c("price", "male", "age", "clothes_shoes", "cosmetics", "food", "technology")]))
# Compute X_beta_hat
X_beta_hat <- X %*% beta_hat

# Compute log phi(x_i" beta)
log_phi_Xb <- dnorm(X_beta_hat, log = TRUE)

# Compute log Phi(x_i" beta)
log_Phi_Xb <- pnorm(X_beta_hat, log.p = TRUE)

# Compute log Phi(-x_i" beta)
log_Phi_minus_Xb <- pnorm(-X_beta_hat, log.p = TRUE)

# Compute the logarithm of the fraction
log_factor <- 2 * log_phi_Xb - log_Phi_Xb - log_Phi_minus_Xb

# Exponentiate to get the factor
factor <- exp(log_factor)

# Replace any infinite or NaN values with zero
factor[!is.finite(factor)] <- 0
factor <- as.vector(factor)
X_weighted <- sweep(X, 1, factor, FUN = "*")

# Compute H_hat
H_hat <- t(X) %*% X_weighted / nrow(X)

# Compute V_hat
V_hat <- solve(H_hat)

# Extract variance of the coefficient on "age"
variance_beta_age <- V_hat[4, 4]

# Compute standard error
beta_age_sd <- sqrt(variance_beta_age / nrow(X))

# Check if beta_age_sd is finite
if (!is.finite(beta_age_sd)) {
  stop("Standard error for the coefficient on age is not finite.")
}

# Approximate finite sample distribution
beta_age_values <- seq(beta_hat[4] - 4 * beta_age_sd, beta_hat[4] + 4 * beta_age_sd, length.out = 100)
beta_age_density <- dnorm(beta_age_values, mean = beta_hat[4], sd = beta_age_sd)

# Plot the distribution
plot(beta_age_values, beta_age_density, type = "l", main = "Asymptotic Approximation of Coefficient on Age", xlab = "Coefficient on Age", ylab = "Density")

### Compare with bootstrapping
# Assuming "beta_age_bootstrap" contains the bootstrap estimates from part (g)

# Plot the histogram of bootstrap estimates
hist(beta_age_bootstrap, breaks = 20, freq = FALSE, main = "Bootstrap vs. Asymptotic Distribution of Coefficient on Age", xlab = "Coefficient on Age")

# Add the asymptotic density curve
lines(beta_age_values, beta_age_density, col = "red", lwd = 2)
legend("topright", legend = c("Bootstrap", "Asymptotic"), col = c("grey", "red"), lwd = c(1, 2))


# (i)
# Compute gradient
phi_age_60 <- dnorm(sum(x_age_60 * beta_hat))
phi_age_30 <- dnorm(sum(x_age_30 * beta_hat))
grad_g <- phi_age_60 * x_age_60 - phi_age_30 * x_age_30

print(grad_g)

# Compute asymptotic variance
var_gamma_1 <- t(grad_g) %*% V_hat %*% grad_g / nrow(dat_1000)
gamma_1_sd <- sqrt(var_gamma_1)

print(gamma_1_sd)

# Approximate finite sample distribution
gamma_1_values <- seq(gamma_1 - 4 * gamma_1_sd, gamma_1 + 4 * gamma_1_sd, length.out = 100)
gamma_1_density <- dnorm(gamma_1_values, mean = gamma_1, sd = gamma_1_sd)

# Plot the approximate finite sample distribution
plot(gamma_1_values, gamma_1_density, type = "l", main = "Asymptotic Approximation of Gamma_1", xlab = "Gamma_1", ylab = "Density")

# (j)
t_statistic <- gamma_1 / gamma_1_sd
critical_value <- qnorm(0.975)  # 1.96 for 95% confidence

if (abs(t_statistic) > critical_value) {
  conclusion <- "Reject the null hypothesis."
} else {
  conclusion <- "Fail to reject the null hypothesis."
}

print(paste("t-statistic:", round(t_statistic, 2)))
print(paste("Conclusion:", conclusion))

lower_bound <- gamma_1 - critical_value * gamma_1_sd
upper_bound <- gamma_1 + critical_value * gamma_1_sd

print(paste("95% Confidence Interval for gamma_1:", round(lower_bound, 4), "to", round(upper_bound, 4)))
