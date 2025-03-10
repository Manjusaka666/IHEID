#Point a

set.seed(2025)
n <- 100
u_i <- rnorm(n, mean = 0, sd = sqrt(5)) 
g_i <- rgamma(n, shape = 2, scale = 2) 
r_i <- rbinom(n, size = 1, prob = 0.5)
x_star_i <- numeric(n)
for (i in 1:n) {
  if (r_i[i] == 1) {
    x_star_i[i] <- rgamma(1, shape = 3, scale = 1)
  } else {
    x_star_i[i] <- rgamma(1, shape = 7, scale = 1) }
}
beta_0 <- 400
beta_1 <- 5
beta_2 <- 200
beta_3 <- 10
y_i <- beta_0 + beta_1 * x_star_i + beta_2 * r_i + beta_3 * g_i + u_i
n_i <- rnorm(n, mean = 10, sd = sqrt(3))
b_i <- rnorm(n, mean = 5 + sqrt(x_star_i), sd = sqrt(3))
data <- data.frame( y = y_i,
                    x_star = x_star_i, r = r_i,
                    g = g_i, n = n_i, b = b_i)
                    
#Point b

# Load necessary libraries (if needed)
set.seed(2025)

# Simulate dataset
n <- 100
u_i <- rnorm(n, mean = 0, sd = sqrt(5))
g_i <- rgamma(n, shape = 2, scale = 2)
r_i <- rbinom(n, size = 1, prob = 0.5)

x_star_i <- numeric(n)
for (i in 1:n) {
  if (r_i[i] == 1) {
    x_star_i[i] <- rgamma(1, shape = 3, scale = 1)
  } else {
    x_star_i[i] <- rgamma(1, shape = 7, scale = 1)
  }
}

# Define coefficients
beta_0 <- 400
beta_1 <- 5
beta_2 <- 200
beta_3 <- 10

# Generate dependent variable
y_i <- beta_0 + beta_1 * x_star_i + beta_2 * r_i + beta_3 * g_i + u_i

# Generate additional variables
n_i <- rnorm(n, mean = 10, sd = sqrt(3))
b_i <- rnorm(n, mean = 5 + sqrt(x_star_i), sd = sqrt(3))

# Store data in a dataframe
data <- data.frame(y = y_i, x_star = x_star_i, r = r_i, g = g_i, n = n_i, b = b_i)

# Run regressions
reg1 <- lm(y ~ x_star, data = data)
reg2 <- lm(y ~ x_star + r, data = data)
reg3 <- lm(y ~ x_star + r + g, data = data)
reg4 <- lm(y ~ x_star + r + n, data = data)
reg5 <- lm(y ~ x_star + r + b, data = data)

# Extract results
summary_reg1 <- summary(reg1)
summary_reg2 <- summary(reg2)
summary_reg3 <- summary(reg3)
summary_reg4 <- summary(reg4)
summary_reg5 <- summary(reg5)

# Function to extract results
extract_results <- function(reg_summary, reg_name) {
  beta1_estimate <- reg_summary$coefficients["x_star", "Estimate"]
  beta1_se <- reg_summary$coefficients["x_star", "Std. Error"]
  beta1_true <- 5
  
  cat(paste0("\n", reg_name, ":\n"))
  cat(paste0(" Estimated beta_1: ", round(beta1_estimate, 4), "\n"))
  cat(paste0(" True beta_1: ", beta1_true, "\n"))
  cat(paste0(" Standard Error: ", round(beta1_se, 4), "\n"))
  cat(paste0(" Difference from true value: ", round(beta1_estimate - beta1_true, 4), "\n"))
  cat(paste0(" Adjusted R^2: ", round(reg_summary$adj.r.squared, 4), "\n"))
}

# Print results
extract_results(summary_reg1, "Regression 1 (y ~ x_star)")
extract_results(summary_reg2, "Regression 2 (y ~ x_star + r)")
extract_results(summary_reg3, "Regression 3 (y ~ x_star + r + g)")
extract_results(summary_reg4, "Regression 4 (y ~ x_star + r + n)")
extract_results(summary_reg5, "Regression 5 (y ~ x_star + r + b)")

#Point c

# Set seed for reproducibility
set.seed(2025)
M <- 1000  # Increase iterations to ensure variation
n <- 100   # Sample size

# Matrix to store beta1 estimates
beta1_estimates <- matrix(NA, nrow = M, ncol = 5)
colnames(beta1_estimates) <- c("Reg1", "Reg2", "Reg3", "Reg4", "Reg5")

# Monte Carlo Simulation
for (m in 1:M) {
  # Generate variables
  u_i <- rnorm(n, mean = 0, sd = sqrt(5))
  g_i <- rgamma(n, shape = 2, scale = 2)
  r_i <- rbinom(n, size = 1, prob = 0.5)
  
  x_star_i <- numeric(n)
  for (i in 1:n) {
    if (r_i[i] == 1) {
      x_star_i[i] <- rgamma(1, shape = 3, scale = 1)
    } else {
      x_star_i[i] <- rgamma(1, shape = 7, scale = 1)
    }
  }
  
  beta_0 <- 400
  beta_1 <- 5
  beta_2 <- 200
  beta_3 <- 10
  
  # Generate y
  y_i <- beta_0 + beta_1 * x_star_i + beta_2 * r_i + beta_3 * g_i + u_i
  
  # Additional variables
  n_i <- rnorm(n, mean = 10, sd = sqrt(3))
  b_i <- rnorm(n, mean = 5 + sqrt(x_star_i), sd = sqrt(3))
  
  # Create data frame
  data <- data.frame(
    y = y_i,
    x_star = x_star_i,
    r = r_i,
    g = g_i,
    n = n_i,
    b = b_i
  )
  
  # Run regressions
  reg1 <- lm(y ~ x_star, data = data)
  reg2 <- lm(y ~ x_star + r, data = data)
  reg3 <- lm(y ~ x_star + r + g, data = data)
  reg4 <- lm(y ~ x_star + r + n, data = data)
  reg5 <- lm(y ~ x_star + r + b, data = data)
  
  # Store beta1 estimates
  beta1_estimates[m, 1] <- coef(reg1)["x_star"]
  beta1_estimates[m, 2] <- coef(reg2)["x_star"]
  beta1_estimates[m, 3] <- coef(reg3)["x_star"]
  beta1_estimates[m, 4] <- coef(reg4)["x_star"]
  beta1_estimates[m, 5] <- coef(reg5)["x_star"]
}


# Set up layout (2 rows, 3 columns) and margin adjustments
par(mfrow = c(2, 3), mar = c(4.5, 4.5, 2, 1))

# Plot histograms for each regression
for (i in 1:5) {
  hist(beta1_estimates[, i],
       main = paste("Regression", i),
       xlab = expression(hat(beta)[1]),
       ylab = "Frequency",
       breaks = 30,   # More bins for smooth distribution
       col = "lightblue",
       border = "black",
       freq = TRUE,   # Show actual count-based histogram
       ylim = c(0, max(hist(beta1_estimates[, i], plot = FALSE)$counts) + 5)  # Ensure visibility
  )
  
  # Add reference lines
  abline(v = 5, col = "red", lwd = 3)  # True beta_1
  abline(v = mean(beta1_estimates[, i]), col = "blue", lty = 2, lwd = 3)  # Mean estimate
  
  # Add a legend
  legend("topright", 
         legend = c("True value", "Mean estimate"),
         col = c("red", "blue"),
         lty = c(1, 2),
         lwd = 3,
         cex = 1.2)
}



