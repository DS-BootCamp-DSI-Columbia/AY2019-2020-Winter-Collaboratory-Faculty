functions {
  /* Kernel of joint PMF, i.e. numerator of Bayes rule ignoring constants
   * @param pi success probability between 0 and 1
   * @param pi_c failure probability between 0 and 1 (conceptually)
   * @param unused real array of other parameters (none in this case)
   * @param x_r real array of constants, namely shape hyperparameters
   * @param x_i integer array of constants, namely data values
   * @return kernel value
   */
  real kernel(real pi, real pi_c, real[] unused, real[] x_r, int[] x_i) {
    int n = x_i[1]; // the Stan language indexes starting from 1 (not 0)
    int y = x_i[2];
    real a_star = x_r[1] + y;
    real b_star = x_r[2] - y + n;
    if (pi <= 0.5) return pi ^ (a_star - 1) * (1 - pi) ^ (b_star + 1);
    // else if pi > 0.5, utilize pi_c to avoid numerical cancellation
    return pi ^ (a_star - 1) * pi_c ^ (b_star + 1);
  }
}

data { // everything conditioned on in Bayes rule (passed from the interface)
  int<lower = 0> n;            // number of trials
  int<lower = 0, upper = n> y; // number of successes
  real<lower = 0> a;           // first shape for beta prior
  real<lower = 0> b;           // second shape for beta prior
}

transformed data { // any functions of things in the data block only
  real empty[0];   // this is unused but the integrator needs it to be defined
  real normalizer = integrate_1d(kernel,  // function being integrated
                                  0.0,    // left limit of integration
                                  1.0,    // right limit of integration
                                  empty,  // shared parameters 
                                  {a, b}, // double precision data
                                  {n, y}, // integer data
                                  1e-8);  // relative tolerance
  real log_normalizer = log(normalizer);  // used below in model block
}

parameters { // all exogenous unknowns when using Bayes rule
  real<lower = 0, upper = 1> pi; // success probability
} // log Jacobian determinant of transformation to (0,1) is put into target

transformed parameters { // functions of things in the parameters block
  real log_pi = log(pi); // intermediate value that is stored in the output
}

model { // basically a function that returns the log (kernel) of Bayes rule
  real log_1mpi = log1m(pi); // local intermediate value not stored in output
  target += y * log_pi + (n - y) * log_1mpi;       // log binomial likelihood
  target += (a - 1) * log_pi + (b - 1) * log_1mpi; // log beta prior kernel
  target += -log_normalizer;                       // not actually necessary
} // implicitly returns accumulated value of target

generated quantities { // can refer to symbols except those in the model block
  // functions of things in the parameters block not needed for log-kernel
  int y_ = binomial_rng(n, pi); // draw from posterior predictive distribtution
}
