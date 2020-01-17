#include game_rng.stan
data {
  int<lower = 0> J;                         // number of bowlers
  int<lower = 1, upper = 11> roll_1[J, 10]; // 1 = gutter ball, ..., 11 = strike
  int<lower = 1, upper = 11> roll_2[J, 10]; // same
  vector<lower = 0>[11] a; // hyperparameters for Dirichlet prior on mu
  real<lower = 0> rate;    // hyperparameter for exponential prior on gamma
}
parameters {
  simplex[11] pi[J];      // probability of 1 ... 11 for each bowler
  simplex[11] mu;         // expectation of pi across professional bowlers
  real<lower = 0> gamma;  // concentration of professional bowlers around mu
}
model {
  vector[11] mu_gamma = mu * gamma;
  target += dirichlet_lpdf(mu | a);            // Dirichlet hyperprior
  target += exponential_lpdf(gamma | rate);    // Exponential hyperior
  for (j in 1:J) {
    vector[11] pi_j = pi[j];
    target += dirichlet_lpdf(pi_j | mu_gamma); // Dirichlet prior for j-th bowler
    target += log(pi_j)[roll_1[j]];            // log-likelihood over first rolls
    for (n in 1:10) if (roll_1[j, n] < 11) {   // log-likelihood over second rolls
      int pins = 11 - roll_1[j, n] + 1;
      vector[pins] pi_ = pi_j[1:pins];
      pi_ /= sum(pi_);
      target += log(pi_[roll_2[j, n]]);
    }
  }
}
generated quantities {
  int score[J];
  int winner;
  for (j in 1:J) score[j] = score_game(scorecard_rng(pi[j]));
  winner = sort_indices_desc(score)[1]; // index of bowler with highest score
}
