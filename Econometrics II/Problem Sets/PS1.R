# Set seed for reproducibility
set.seed(2025)

# Sample size
n <- 100

# Simulate error terms
u_i <- rnorm(n, mean = 0, sd = sqrt(5))

# Simulate precipitation (rainfall)
g_i <- rgamma(n, shape = 2, scale = 2)

# Simulate land quality indicator (high quality = 1, low quality = 0)
r_i <- rbinom(n, size = 1, prob = 0.5)

# Simulate fertilizer amounts conditional on land quality
x_star_i <- numeric(n)
for (i in 1:n) {
  if (r_i[i] == 1) {
    x_star_i[i] <- rgamma(1, shape = 3, scale = 1)
  } else {
    x_star_i[i] <- rgamma(1, shape = 7, scale = 1)
  }
}

# Set parameter values
beta_0 <- 400
beta_1 <- 5
beta_2 <- 200
beta_3 <- 10

# Generate crop yields
y_i <- beta_0 + beta_1 * x_star_i + beta_2 * r_i + beta_3 * g_i + u_i

# Generate additional variables
n_i <- rnorm(n, mean = 10, sd = sqrt(3))
b_i <- rnorm(n, mean = 5 + sqrt(x_star_i), sd = sqrt(3))

# Create dataframe
data <- data.frame(
  y = y_i,
  x_star = x_star_i,
  r = r_i,
  g = g_i,
  n = n_i,
  b = b_i
)

# Display summary statistics
summary(data)



# Question (b)
# Regression 1: y ~ x_star
reg1 <- lm(y ~ x_star, data = data)
summary_reg1 <- summary(reg1)

# Regression 2: y ~ x_star + r
reg2 <- lm(y ~ x_star + r, data = data)
summary_reg2 <- summary(reg2)

# Regression 3: y ~ x_star + r + g
reg3 <- lm(y ~ x_star + r + g, data = data)
summary_reg3 <- summary(reg3)

# Regression 4: y ~ x_star + r + g + n
reg4 <- lm(y ~ x_star + r + n, data = data)
summary_reg4 <- summary(reg4)

# Regression 5: y ~ x_star + r + g + b
reg5 <- lm(y ~ x_star + r + b, data = data)
summary_reg5 <- summary(reg5)

# Function to extract and format regression results
extract_results <- function(reg_summary, reg_name) {
  beta1_estimate <- reg_summary$coefficients["x_star", "Estimate"]
  beta1_se <- reg_summary$coefficients["x_star", "Std. Error"]
  beta1_true <- 5
  
  cat(paste0("\n", reg_name, ":\n"))
  cat(paste0("Estimated β₁: ", round(beta1_estimate, 4), "\n"))
  cat(paste0("True β₁: ", beta1_true, "\n"))
  cat(paste0("Standard Error: ", round(beta1_se, 4), "\n"))
  cat(paste0("Difference from true value: ", round(beta1_estimate - beta1_true, 4), "\n"))
  cat(paste0("Adjusted R²: ", round(reg_summary$adj.r.squared, 4), "\n"))
}

# Print results for all regressions
extract_results(summary_reg1, "Regression 1 (y ~ x_star)")
extract_results(summary_reg2, "Regression 2 (y ~ x_star + r)")
extract_results(summary_reg3, "Regression 3 (y ~ x_star + r + g)")
extract_results(summary_reg4, "Regression 4 (y ~ x_star + r + n)")
extract_results(summary_reg5, "Regression 5 (y ~ x_star + r + b)")

results_b <- data.frame(
  Regression      = c("y ~ x_star", "y ~ x_star + r", "y ~ x_star + r + g", 
                      "y ~ x_star + r + n", "y ~ x_star + r + b"),
  Estimated_beta1 = round(c(coef(reg1)["x_star"], coef(reg2)["x_star"], 
                            coef(reg3)["x_star"], coef(reg4)["x_star"], 
                            coef(reg5)["x_star"]), 4),
  True_beta1      = rep(5, 5),
  Std_Error       = round(c(summary(reg1)$coefficients["x_star", "Std. Error"],
                            summary(reg2)$coefficients["x_star", "Std. Error"],
                            summary(reg3)$coefficients["x_star", "Std. Error"],
                            summary(reg4)$coefficients["x_star", "Std. Error"],
                            summary(reg5)$coefficients["x_star", "Std. Error"]), 4),
  Difference      = round(c(coef(reg1)["x_star"] - 5, coef(reg2)["x_star"] - 5, 
                            coef(reg3)["x_star"] - 5, coef(reg4)["x_star"] - 5, 
                            coef(reg5)["x_star"] - 5), 4),
  Adjusted_R2     = round(c(summary(reg1)$adj.r.squared,
                            summary(reg2)$adj.r.squared,
                            summary(reg3)$adj.r.squared,
                            summary(reg4)$adj.r.squared,
                            summary(reg5)$adj.r.squared), 4)
)

# 利用 knitr::kable() 生成 LaTeX 三线表
library(knitr)
latex_table_b <- kable(results_b, format = "latex", booktabs = TRUE,
                       caption = "Regression Results for Question (b)")

# 直接输出到 LaTeX 文件
output_file_b <- "b.tex"
cat(latex_table_b, file = output_file_b)
cat("\n%% Table saved to ", output_file_b, "\n", sep = "", file = output_file_b, append = TRUE)


# Question (c)
# Monte Carlo simulation with M = 100 repetitions
set.seed(2025)
M <- 100
n <- 100

# Initialize matrices to store β₁ estimates
beta1_estimates <- matrix(NA, nrow = M, ncol = 5)
colnames(beta1_estimates) <- c("Reg1", "Reg2", "Reg3", "Reg4", "Reg5")

# Run Monte Carlo simulation
for (m in 1:M) {
  # Generate data according to DGP
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
  
  y_i <- beta_0 + beta_1 * x_star_i + beta_2 * r_i + beta_3 * g_i + u_i
  
  n_i <- rnorm(n, mean = 10, sd = sqrt(3))
  b_i <- rnorm(n, mean = 5 + sqrt(x_star_i), sd = sqrt(3))
  
  data <- data.frame(
    y = y_i,
    x_star = x_star_i,
    r = r_i,
    g = g_i,
    n = n_i,
    b = b_i
  )
  
  # Run the five regressions
  reg1 <- lm(y ~ x_star, data = data)
  reg2 <- lm(y ~ x_star + r, data = data)
  reg3 <- lm(y ~ x_star + r + g, data = data)
  reg4 <- lm(y ~ x_star + r + n, data = data)
  reg5 <- lm(y ~ x_star + r + b, data = data)
  
  # Store β₁ estimates
  beta1_estimates[m, 1] <- coef(reg1)["x_star"]
  beta1_estimates[m, 2] <- coef(reg2)["x_star"]
  beta1_estimates[m, 3] <- coef(reg3)["x_star"]
  beta1_estimates[m, 4] <- coef(reg4)["x_star"]
  beta1_estimates[m, 5] <- coef(reg5)["x_star"]
}

# Create data frame from estimates for plotting
beta1_df <- data.frame(
  Estimate = c(beta1_estimates),
  Regression = rep(colnames(beta1_estimates), each = M)
)

# Calculate summary statistics
beta1_summary <- data.frame(
  Regression = colnames(beta1_estimates),
  Mean = colMeans(beta1_estimates),
  SD = apply(beta1_estimates, 2, sd),
  Bias = colMeans(beta1_estimates) - 5
)
print(beta1_summary)

# Plot histograms
pdf("Q(c).pdf")
par(mfrow = c(2, 3))
for (i in 1:5) {
  hist(beta1_estimates[, i], 
       main = paste("Regression", i), 
       xlab = "β₁ estimate",
       breaks = 20,
       col = "lightblue",
       border = "white")
  abline(v = 5, col = "red", lwd = 2)  # True value
  abline(v = mean(beta1_estimates[, i]), 
        col = "blue", lty = 2, lwd = 2)  # Mean estimate
  legend("topright",
         legend = c("True value", "Mean estimate"),
         col = c("red", "blue"),
         lty = c(1, 2),
         lwd = 2,
         cex = 0.8)
}
dev.off()



# Question (d)
# Function to run Monte Carlo simulation with specific DGP parameters
run_monte_carlo <- function(x_star_equal = FALSE, beta2_zero = FALSE, r_prob = 0.5, beta3_value = 10) {
  M <- 100
  n <- 100
  
  # Initialize matrices to store β₁ estimates
  beta1_estimates <- matrix(NA, nrow = M, ncol = 3)
  colnames(beta1_estimates) <- c("Reg1", "Reg2", "Reg3")
  
  # Run Monte Carlo simulation
  for (m in 1:M) {
    # Generate data according to modified DGP
    u_i <- rnorm(n, mean = 0, sd = sqrt(5))
    g_i <- rgamma(n, shape = 2, scale = 2)
    r_i <- rbinom(n, size = 1, prob = r_prob)
    
    # Modify x_star distribution based on parameter
    x_star_i <- numeric(n)
    if (x_star_equal) {
      x_star_i <- rgamma(n, shape = 5, scale = 1)
    } else {
      for (i in 1:n) {
        if (r_i[i] == 1) {
          x_star_i[i] <- rgamma(1, shape = 3, scale = 1)
        } else {
          x_star_i[i] <- rgamma(1, shape = 7, scale = 1)
        }
      }
    }
    
    # Set parameter values
    beta_0 <- 400
    beta_1 <- 5
    beta_2 <- ifelse(beta2_zero, 0, 200)
    beta_3 <- beta3_value
    
    # Generate crop yields
    y_i <- beta_0 + beta_1 * x_star_i + beta_2 * r_i + beta_3 * g_i + u_i
    
    data <- data.frame(
      y = y_i,
      x_star = x_star_i,
      r = r_i,
      g = g_i
    )
    
    # Run the three regressions
    reg1 <- lm(y ~ x_star, data = data)
    reg2 <- lm(y ~ x_star + r, data = data)
    reg3 <- lm(y ~ x_star + r + g, data = data)
    
    # Store β₁ estimates
    beta1_estimates[m, 1] <- coef(reg1)["x_star"]
    beta1_estimates[m, 2] <- coef(reg2)["x_star"]
    beta1_estimates[m, 3] <- coef(reg3)["x_star"]
  }
  
  return(beta1_estimates)
}

# Run simulations with different DGP modifications
results_original <- run_monte_carlo()
results_xstar_equal <- run_monte_carlo(x_star_equal = TRUE)
results_beta2_zero <- run_monte_carlo(beta2_zero = TRUE)
results_r_prob_0.1 <- run_monte_carlo(r_prob = 0.1)
results_beta3_50 <- run_monte_carlo(beta3_value = 50)

# Function to calculate summary statistics
calc_summary <- function(results, scenario_name) {
  summary_df <- data.frame(
    Scenario = rep(scenario_name, 3),
    Regression = c("Reg1", "Reg2", "Reg3"),
    Mean = colMeans(results),
    SD = apply(results, 2, sd),
    Bias = colMeans(results) - 5
  )
  return(summary_df)
}

# Calculate summaries for all scenarios
summary_original <- calc_summary(results_original, "Original DGP")
summary_xstar_equal <- calc_summary(results_xstar_equal, "x_star equal")
summary_beta2_zero <- calc_summary(results_beta2_zero, "β₂ = 0")
summary_r_prob_0.1 <- calc_summary(results_r_prob_0.1, "r_prob = 0.1")
summary_beta3_50 <- calc_summary(results_beta3_50, "β₃ = 50")

# Combine all summaries
all_summaries <- rbind(
  summary_original,
  summary_xstar_equal,
  summary_beta2_zero,
  summary_r_prob_0.1,
  summary_beta3_50
)

# print(all_summaries)
latex_table_d <- kable(all_summaries, format = "latex", booktabs = TRUE,
                       caption = "Simulation Summary Statistics for Question (d)")

# 将模拟结果直接输出到 LaTeX 文件
output_file_d <- "d.tex"
cat(latex_table_d, file = output_file_d)
cat("\n%% Table saved to ", output_file_d, "\n", sep = "", file = output_file_d, append = TRUE)


# Visualization function for each scenario
plot_scenario_comparison <- function(original, modified, title) {
  par(mfrow = c(2, 3))
  
  for (i in 1:3) {
    # Original DGP
    hist(original[, i], 
         main = paste("Reg", i, "- Original"), 
         xlab = "β₁ estimate",
         breaks = 15,
         col = "lightblue",
         border = "white",
         xlim = range(c(original[, i], modified[, i])))
    abline(v = 5, col = "red", lwd = 2)
    abline(v = mean(original[, i]), col = "blue", lty = 2, lwd = 2)
    
    # Modified DGP
    hist(modified[, i], 
         main = paste("Reg", i, "- Modified"), 
         xlab = "β₁ estimate",
         breaks = 15,
         col = "lightgreen",
         border = "white",
         xlim = range(c(original[, i], modified[, i])))
    abline(v = 5, col = "red", lwd = 2)
    abline(v = mean(modified[, i]), col = "blue", lty = 2, lwd = 2)
  }
  mtext(title, side = 3, line = -1.5, outer = TRUE)
}

# Plot comparisons
par(mfrow = c(1, 1))
