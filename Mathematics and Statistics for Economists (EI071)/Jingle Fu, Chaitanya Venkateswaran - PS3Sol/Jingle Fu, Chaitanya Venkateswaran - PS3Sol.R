#1.1
data(mtcars)

#1.2
ncol(mtcars)
nrow(mtcars)

#1.3
library(dplyr)
selected_data <- select(mtcars, mpg, cyl, hp)
mtcars %>% select('mpg', 'cyl', 'hp')


#1.4
data1_4 <- filter(mtcars, cyl == 6, hp > 100)
mtcars %>% filter(cyl == 6, hp > 100)


#1.5
mtcars$hp_per_cyl <- mtcars$hp / mtcars$cyl

#1.6
average_mpg <- mtcars %>%
  group_by(cyl) %>%
  summarize(avg_mpg = mean(mpg))

#2.1
library(ggplot2)
ggplot(mtcars, aes(x = hp, y = mpg, color = as.factor(cyl))) +
  geom_point() +
  labs(color = "Number of Cylinders")

#2.2
ggplot(mtcars, aes(x = as.factor(cyl), y = mpg, fill = as.factor(cyl))) +
  geom_boxplot() +
  scale_fill_discrete(name = "Number of Cylinders") +
  labs(x = "Number of Cylinders", y = "Miles Per Gallon")

#2.3
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(binwidth = 2) +
  xlab("Miles Per Gallon") +
  ylab("Frequency")

#3.1
mean_mpg <- mean(mtcars$mpg)
mean_hp <- mean(mtcars$hp)

#3.2
var_mpg <- var(mtcars$mpg)
var_hp <- var(mtcars$hp)

#3.3
cov_mpg_hp <- cov(mtcars$mpg, mtcars$hp)

#3.4
cor_mpg_hp <- cor(mtcars$mpg, mtcars$hp)

#4.1
car_names <- data.frame(
  car_model = rownames(mtcars),
  origin = c(rep('USA', 10), rep('Europe', 10), rep('Japan', 12))
)

mtcars$car_model <- rownames(mtcars)
merged_data <- merge(mtcars, car_names, by = "car_model")

#4.2
library(tidyr)
long_format <- pivot_longer(mtcars, cols = -car_model, names_to = "variable", values_to = "value")

#4.3
short_format <- pivot_wider(long_format, names_from = variable, values_from = value, id_cols = car_model)

#5.1
library(stargazer)
model <- lm(mpg ~ hp + wt, data = mtcars)

#5.2
summary(model)
stargazer(model, type = "latex", out = "PS3-5_2.tex", title = "Regression Results", single.row = TRUE, header = FALSE, no.space = TRUE)

#5.3
predict_mpg <- predict(model, newdata = data.frame(hp = 150, wt = 3.0))
predict_mpg

