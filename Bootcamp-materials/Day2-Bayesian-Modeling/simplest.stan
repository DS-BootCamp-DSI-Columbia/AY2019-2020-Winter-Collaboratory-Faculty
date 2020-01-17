data {
  int<lower = 0> N;                     // number of frames with data
  int<lower = 1, upper = 11> roll_1[N]; // 1 = gutter ball, ..., 11 = strike
  int<lower = 1, upper = 11> roll_2[N]; // same
  vector<lower = 0>[11] a;              // hyperparameters for Dirichlet prior
}
parameters {
  simplex[11] pi;                       // probability of events 1 ... 11
}
model {
  vector[11] log_pi = log(pi);          // local variable, not stored in output
  target += (a - 1) .* log_pi;          // Dirichlet prior with elementwise multiplication
  target += log_pi[roll_1];             // Categorical log-likelihood over the data
  
  /* the above is equivalent to, but more computationally efficient than
  for (k in 1:11) {
    target += (a[k] - 1) * log_pi[k];
  }
  for (n in 1:N) {
    target += log_pi[roll_1[n]];
  }
  */
}
generated quantities {
  vector[N] log_p;
  for (n in 1:N) {
    int pins = 11 - roll_1[n] + 1;      // number of pins upright (+ 1)
    vector[pins] pi_ = pi[1:pins];      // condition on pins available
    pi_ /= sum(pi_);                    // renormalize probabilities
    log_p[n] = log(pi_[roll_2[n]]);     // log predictive probability
  }
}
