data {
  int<lower=0> N;
  vector[N] x;
  vector[5] y_plausible[N];
}

// The parameters accepted by the model. Notice that true obscured y becomes 
// a parameter to be estimated
parameters {
  // regression parameters
  real beta_0;
  real beta_1;
  real<lower=0> sigma;
  
  // parameters of the distribution from which plausible values came. 
  // you can give them individual standard deviations if you want. I just do a
  // common one to all of them
  vector[N] y;
  real<lower=0> sigma_plausible;
  
}

// The model to be estimated. 
model {
  y ~ normal(beta_0 + beta_1*x, sigma);
  
  for (i in 1:N) {
    y_plausible[i] ~ normal(y[i], sigma_plausible);
  }
  
  // I just let stan set some default priors, whis is probably not advisable in
  // general but for this simple model seems to work fine
}

