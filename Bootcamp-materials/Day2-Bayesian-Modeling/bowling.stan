#include bowling_kernel.stan
data { // exogenous and endogenous knowns
  int<lower = 0> N;                       // number of frames
  int<lower = 0, upper = 10> x1_x2[N, 2]; // results of each frame
  vector<lower=0>[11] a;                  // shapes for Dirichlet prior
}
transformed data { // functions of data
  real a_0 = sum(a);
  real prior_entropy = sum(lgamma(a)) - lgamma(a_0) + (a_0 - 11) * digamma(a_0)
                     - dot_product(a - 1, digamma(a));
}
parameters { // exogenous unknowns
  simplex[11] pi; // probability of knocking down 0:10 pins
}
model { // target becomes the log-numerator of Bayes Rule
  target += bowling_kernel(pi, a, x1_x2); // defined in functions block
}
generated quantities { // endogenous unknowns not needed for likelihood
  real posterior_entropy = -dot_product(pi, log(pi));
  real entropy_change = posterior_entropy - prior_entropy;
}
