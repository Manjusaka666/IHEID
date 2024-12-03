rm(list = ls())
# Set the random seed for reproducibility
set.seed(2024)

# Given parameters
theta_0 <- 175
sigma_squared <- 6
sigma <- sqrt(sigma_squared)
n <- 4
alpha <- 0.05
M <- 1000  # Number of simulations

# Initialize a vector to store the test statistics
T_values <- numeric(M)

# Simulation loop
for (m in 1:M) {
  # Draw a sample under H0: theta = theta_0
  x_m <- rnorm(n, mean = theta_0, sd = sigma)
  # Compute the sample mean
  x_bar_m <- mean(x_m)
  # Compute the test statistic T(x^m)
  T_m <- (n / sigma_squared) * (x_bar_m - theta_0)^2
  # Store the test statistic
  T_values[m] <- T_m
}

# Plot the histogram of T_values
hist(T_values, breaks = 30, col = 'skyblue', border = 'black', freq = TRUE,
     main = 'Histogram of T(X) under H0', xlab = 'Test Statistic T(X)')
grid()

# Sort the test statistics and find the critical value c_alpha
T_values_sorted <- sort(T_values)
c_alpha_index <- ceiling(M * (1 - alpha))
c_alpha <- T_values_sorted[c_alpha_index]

cat(sprintf('Numerical approximation of c_alpha: %.4f\n', c_alpha))

# Analytical critical value
c_alpha_analytical <- qchisq(1 - alpha, df = 1)
cat(sprintf('Analytical c_alpha from chi-squared distribution: %.4f\n', c_alpha_analytical))

# Compare the numerical and analytical critical values
difference <- abs(c_alpha - c_alpha_analytical)
cat(sprintf('Difference between numerical and analytical c_alpha: %.4f\n', difference))





rm(list = ls())
# Set the random seed for reproducibility
set.seed(42)

# Given data
x <- c(178, 161, 168, 172)
n <- length(x)
sigma_squared <- 6
sigma <- sqrt(sigma_squared)
alpha <- 0.05
M <- 1000  # Number of simulations

# Grid of θ₀ values
T_values <- seq(160, 180, by = 0.1)
vc <- numeric(length(T_values))

for (i in seq_along(T_values)) {
  theta_0 <- T_values[i]
  # Step 1: Simulate c_alpha(θ₀)
  T_m <- numeric(M)
  for (m in 1:M) {
    # Simulate data under H₀: θ = θ₀
    x_m <- rnorm(n, mean = theta_0, sd = sigma)
    # Compute T(x^m; θ₀)
    T_m_value <- (n / sigma_squared) * (mean(x_m) - theta_0)^2
    T_m[m] <- T_m_value
  }
  # Determine c_alpha(θ₀) as the 95th percentile
  T_m_sorted <- sort(T_m)
  c_alpha_theta_index <- ceiling(M * (1 - alpha))
  c_alpha_theta <- T_m_sorted[c_alpha_theta_index]
  
  # Step 2: Compute T(x; θ₀) for the actual data
  x_bar <- mean(x)
  T_x_theta <- (n / sigma_squared) * (x_bar - theta_0)^2
  
  # Record 1 if θ₀ ∈ C(x), else 0
  if (T_x_theta < c_alpha_theta) {
    vc[i] <- 1
  } else {
    vc[i] <- 0
  }
}

theta_in_Cx <- T_values[vc == 1]
if (length(theta_in_Cx) > 0) {
  numerical_Cx <- c(min(theta_in_Cx), max(theta_in_Cx))
  cat(sprintf("Numerical Confidence Interval C(x): [%.2f, %.2f]\n",
              numerical_Cx[1], numerical_Cx[2]))
} else {
  cat("No values of θ₀ are included in the numerical confidence interval C(x).\n")
}

# Plotting C(x)
plot(T_values, vc, type = "p", col = "blue", pch = 16,
     main = "Numerical Confidence Interval C(x)",
     xlab = expression(theta[0] ~ "values"),
     ylab = "Indicator")
grid()

# Analytical Confidence Interval for comparison
c_alpha <- qchisq(1 - alpha, df = 1)
margin <- sqrt((c_alpha * sigma_squared) / n)
analytical_Cx <- c(x_bar - margin, x_bar + margin)

# Add analytical confidence interval boundaries to the plot
abline(v = analytical_Cx[1], col = 'red', lty = 2, lwd = 2)
abline(v = analytical_Cx[2], col = 'green', lty = 2, lwd = 2)

cat(sprintf("Numerical C(x): [%.2f, %.2f]\n", numerical_Cx[1], numerical_Cx[2]))
cat(sprintf("Analytical C(x): [%.2f, %.2f]\n",
            analytical_Cx[1], analytical_Cx[2]))


# Clear workspace
rm(list = ls())

# Set the random seed for reproducibility
set.seed(2024)

# Parameter settings
M <- 1000  # Number of simulations
alpha <- 0.05  # Significance level
n <- 4  # Sample size
sigma_squared <- 6  # Known variance
sigma <- sqrt(sigma_squared)
theta_values <- seq(160, 180, by = 0.1)  # Range of θ₀ values
vc <- numeric(length(theta_values))  # Vector to record results

# Generate sample x
theta_true <- 175  # True value of θ
x <- rnorm(n, mean = theta_true, sd = sigma)
x_bar <- mean(x)

# Main loop: compute for each θ₀
for (idx in seq_along(theta_values)) {
  theta_0 <- theta_values[idx]
  
  # Step 1: Simulate M samples x^m ~ N(θ₀, σ²)
  T_values <- numeric(M)
  for (m in 1:M) {
    x_m <- rnorm(n, mean = theta_0, sd = sigma)
    x_bar_m <- mean(x_m)
    # Compute the test statistic T(x^m)
    T_m <- (n / sigma_squared) * (x_bar_m - theta_0)^2
    T_values[m] <- T_m
  }
  
  # Step 2: Sort and find critical value c_alpha(θ₀)
  T_values_sorted <- sort(T_values)
  c_alpha_theta <- T_values_sorted[ceiling(M * (1 - alpha))]
  # Or use quantile function
  # c_alpha_theta <- quantile(T_values, probs = 1 - alpha)
  
  # Step 5: Compute test statistic T(x; θ₀) for sample x
  T_x_theta <- (n / sigma_squared) * (x_bar - theta_0)^2
  
  # Determine whether θ₀ is in the confidence interval
  if (T_x_theta < c_alpha_theta) {
    vc[idx] <- 1  # θ₀ is in the confidence interval
  } else {
    vc[idx] <- 0  # θ₀ is not in the confidence interval
  }
}

# Numerical Confidence Interval
theta_in_Cx <- theta_values[vc == 1]
if (length(theta_in_Cx) > 0) {
  numerical_Cx <- c(min(theta_in_Cx), max(theta_in_Cx))
} else {
  cat("No values of θ₀ are included in the numerical confidence interval C(x).\n")
}

# Analytical Confidence Interval for comparison
c_alpha <- qchisq(1 - alpha, df = 1)
margin <- sqrt((c_alpha * sigma_squared) / n)
analytical_Cx <- c(x_bar - margin, x_bar + margin)


# Plotting C(x)
plot(theta_values, vc, type = "p", col = "blue", pch = 16,
     main = "Numerical Confidence Interval C(x)",
     xlab = expression(theta[0] ~ "values"),
     ylab = expression(Indicator))
grid()

# Add analytical confidence interval boundaries to the plot
abline(v = analytical_Cx[1], col = 'red', lty = 2, lwd = 2)
abline(v = analytical_Cx[2], col = 'green', lty = 2, lwd = 2)

# Add legend
#legend('topright', legend = c('Analytical CI Lower Bound', 'Analytical CI Upper Bound'),
#       col = c('red', 'green'), lty = 2, lwd = 2)

cat(sprintf("Numerical Confidence Interval C(x): [%.2f, %.2f]\n",
            numerical_Cx[1], numerical_Cx[2]))
cat(sprintf("Analytical Confidence Interval C(x): [%.2f, %.2f]\n",
            analytical_Cx[1], analytical_Cx[2]))
