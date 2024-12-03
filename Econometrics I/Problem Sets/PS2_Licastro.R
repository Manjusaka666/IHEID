#D

#1

# Set the random seed for reproducibility
rm(list = ls())
set.seed(2024)

M <- 1000  # number of simulations
n <- 4     # sample size
theta_0 <- 175  # Null hypothesis mean
sigma_sq <- 6  # Variance (sigma^2)

# Initialize a vector to store the test statistics
T_values <- numeric(M)

# Function to calculate the test statistic T(X)
compute_T_stat <- function(x, theta_0, sigma_sq, n) {
  T_x <- n * (mean(x) - theta_0)^2 / sigma_sq
  return(T_x)
}

# Simulation loop
for (m in 1:M) {
  # Sample of size n from N(theta_0, sigma^2)
  sample_x <- rnorm(n, mean = theta_0, sd = sqrt(sigma_sq))
  
  # Test statistic for this sample
  T_values[m] <- compute_T_stat(sample_x, theta_0, sigma_sq, n)
}

# Histogram of the test statistics
hist(T_values, breaks = 30, main = "Histogram of Test Statistic T(X)",
     xlab = "T(X)", col = "skyblue", border = "black")

#2

alpha <- 0.05 # Significance level of alpha

# Sort the test statistics T_values in ascending order
sorted_T_values <- sort(T_values)
quantile_index <- floor(M * (1 - alpha))
c_alpha <- sorted_T_values[quantile_index]

cat("The numerical approximation of the critical value c_alpha is:", c_alpha, "\n")

#F
rm(list=ls())
set.seed(2024)

M <- 1000  
n <- 4    
sigma_sq <- 6  
x <- c(178, 161, 168, 172) 
alpha <- 0.05 

# Fix a grid of T for theta_0

T_grid <- seq(160, 180, by = 0.1) 

# create a vector vc of the same dimension as T

vc <- numeric(length(T_grid))
theta_in_Cx <- c()
# 1 

# Set theta_0

for (i in seq_along(T_grid)) {
  theta_0 <- T_grid[i]

  T_values <- numeric(M)
  compute_T_stat <- function(x, theta_0, sigma_sq, n) {
    T_x <- n * (mean(x) - theta_0)^2 / sigma_sq
    return(T_x)
  }

# Simulation loop
  
  for (m in 1:M) {
    sample_x <- rnorm(n, mean = theta_0, sd = sqrt(sigma_sq))
  
# Test statistic for this sample
    
    T_values[m] <- compute_T_stat(sample_x, theta_0, sigma_sq, n)
  }

  sorted_T_values <- sort(T_values)
  quantile_index <- floor(M * (1 - alpha))
  c_alpha <- sorted_T_values[quantile_index]
# 2
  
# Define theta_hat
  
  theta_hat <- mean(x)
  
# Define T_theta_0
  
  T_theta_0 <- (n/sigma_sq) * (theta_0 - theta_hat)^2
  
# Verification for theta_0 in confidence interval or not
  
  if (T_theta_0 < c_alpha) {
    vc[i] <-1
    theta_in_Cx <- c(theta_in_Cx, theta_0)
  } else {
    vc[i] <-0
  } 
}  

# Confidence interval C(x)

plot(T_grid, vc, main = "Confidence interval C(x)",
     xlab = "T(X)", type='p', col = "skyblue", pch = 16)

if (length(theta_in_Cx) > 0) {
  numerical_Cx <- c(min(theta_in_Cx), max(theta_in_Cx))
  cat(sprintf("Numerical Confidence Interval: [%.2f, %.2f]\n",
              numerical_Cx[1], numerical_Cx[2]))
}

# Analytical Confidence Interval for comparison
c_alpha <- qchisq(1 - alpha, df = 1)
margin <- sqrt((c_alpha * sigma_sq) / n)
analytical_Cx <- c(theta_hat - margin, theta_hat + margin)


cat(sprintf("Analytical Confidence Interval: [%.2f, %.2f]\n",
            analytical_Cx[1], analytical_Cx[2]))
