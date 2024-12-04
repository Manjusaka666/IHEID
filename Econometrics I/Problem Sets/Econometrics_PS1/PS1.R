# Parameters
theta <- 175
n <- 10

# Simulation of a single dataset
u_i <- runif(n, min = -5, max = 5)  # ui ~ U(-5, 5)
x_i <- theta + u_i
theta_hat <- mean(x_i)

# Output the estimated theta
print(paste("Estimated theta:", theta_hat))



# Function to simulate LS estimator theta_hat for n = 10
simulate_theta_hat_10 <- function(theta, M) {
  theta_hats <- numeric(M)
  for (i in 1:M) {
    u_i <- runif(10, min = -5, max = 5)  # ui ~ U(-5, 5)
    x_i <- theta + u_i
    theta_hats[i] <- mean(x_i)
  }
  return(theta_hats)
}

# Parameters
M <- 100  # Number of datasets

# Simulate and plot for n = 10
theta_hats_10 <- simulate_theta_hat_10(theta, M)
hist(theta_hats_10, breaks = 20, main = "Histogram of theta_hat for n = 10", xlab = expression(hat(theta)), ylab = "Frequency")



# Function to simulate LS estimator theta_hat for n = 10
simulate_theta_hat_100 <- function(theta, M) {
  theta_hats <- numeric(M)
  for (i in 1:M) {
    u_i <- runif(100, min = -5, max = 5)  # ui ~ U(-5, 5)
    x_i <- theta + u_i
    theta_hats[i] <- mean(x_i)
  }
  return(theta_hats)
}

# Parameters
M <- 100  # Number of datasets

# Simulate and plot for n = 10
theta_hats_100 <- simulate_theta_hat_100(theta, M)
hist(theta_hats_100, breaks = 20, main = "Histogram of theta_hat for n = 100", xlab = expression(hat(theta)), ylab = "Frequency")



# Function to simulate LS estimator theta_hat for n = 10
simulate_theta_hat_1000 <- function(theta, M) {
  theta_hats <- numeric(M)
  for (i in 1:M) {
    u_i <- runif(1000, min = -5, max = 5)  # ui ~ U(-5, 5)
    x_i <- theta + u_i
    theta_hats[i] <- mean(x_i)
  }
  return(theta_hats)
}

# Parameters
M <- 100  # Number of datasets

# Simulate and plot for n = 10
theta_hats_1000 <- simulate_theta_hat_1000(theta, M)
hist(theta_hats_1000, breaks = 20, main = "Histogram of theta_hat for n = 1000", xlab = expression(hat(theta)), ylab = "Frequency")

