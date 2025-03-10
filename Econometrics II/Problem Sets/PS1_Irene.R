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

M <- 100  # Number of Monte Carlo repetitions
beta1_estimates <- matrix(NA, nrow = M, ncol = 5)  # Store β1 estimates for each regression

for (m in 1:M) {
  # Generate new data
  u <- rnorm(n, mean = 0, sd = sqrt(5))
  g <- rgamma(n, shape = 2, scale = 2)
  r <- sample(c(0, 1), n, replace = TRUE)
  x_star <- ifelse(r == 1, rgamma(n, shape = 3, scale = 1), rgamma(n, shape = 7, scale = 1))
  y <- beta0 + beta1 * x_star + beta2 * r + beta3 * g + u
  n_i <- rnorm(n, mean = 10, sd = 3)
  b_i <- rnorm(n, mean = 5 + sqrt(x_star), sd = 3)
  sim_data <- data.frame(y, x_star, r, g, n_i, b_i)
  
  # Run regressions and store β1 estimates
  beta1_estimates[m, 1] <- coef(lm(y ~ x_star, data = sim_data))[2]
  beta1_estimates[m, 2] <- coef(lm(y ~ x_star + r, data = sim_data))[2]
  beta1_estimates[m, 3] <- coef(lm(y ~ x_star + r + g, data = sim_data))[2]
  beta1_estimates[m, 4] <- coef(lm(y ~ x_star + r + n_i, data = sim_data))[2]
  beta1_estimates[m, 5] <- coef(lm(y ~ x_star + r + b_i, data = sim_data))[2]
}

# Convert to data frame
beta1_df <- data.frame(beta1_estimates)
colnames(beta1_df) <- c("Reg1", "Reg2", "Reg3", "Reg4", "Reg5")

# Plot histograms
par(mfrow = c(2, 3))
hist(beta1_df$Reg1, main = "β1 in Reg1", xlab = "Estimate", col = "lightblue")
hist(beta1_df$Reg2, main = "β1 in Reg2", xlab = "Estimate", col = "lightblue")
hist(beta1_df$Reg3, main = "β1 in Reg3", xlab = "Estimate", col = "lightblue")
hist(beta1_df$Reg4, main = "β1 in Reg4", xlab = "Estimate", col = "lightblue")
hist(beta1_df$Reg5, main = "β1 in Reg5", xlab = "Estimate", col = "lightblue")