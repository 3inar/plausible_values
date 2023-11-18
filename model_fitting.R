set.seed(2023-11-17)

# True model is y = 1 + x + noise
x = rnorm(50)
y = 1 + x + rnorm(50, sd=.05)

# for some reason (privacy perhaps?) we choose to provide some randomly drawn
# "plausible values" instead of the true value so that the plausible values are
# centered on the true value
y_plausible = t(sapply(y, function(yy) { rnorm(5, mean=yy, sd=.025) }))
head(y_plausible)

# It is not so difficult to use what we know about this process in a Bayesian
# model; the response for each data point x_i is an unknown y_i which we provide
# a prior for.
library(rstan)
dataset = list(N=50, x=x, y_plausible=y_plausible)
stan_fit = stan("model.stan", data=dataset)

draws = extract(stan_fit)

# the intercept, truth marked as a vertical bar
hist(draws$beta_1, breaks = 50, prob=T, border = "lightgrey", 
     main="Draws from beta_1 posterior")
abline(v=1, lwd=1.5)

# Let's look at the first y value, truth marked as vertical bar
estimated_y = draws$y
hist(estimated_y[, 1], breaks = 50, prob=T, border = "lightgrey", 
     main="Draws from y[1] posterior")
abline(v=y[1], lwd=1.5)
