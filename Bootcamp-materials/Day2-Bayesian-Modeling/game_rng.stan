functions {
  int game_rng(vector pi) {
    int strike_previous = 0;              // flag for strike on previous frame
    int spare_previous = 0;               // flag for spare on previous frame
    int score = 0;                        // increment this to score a simulated game
    for (frame in 1:10) {
      int x_1 = categorical_rng(pi) - 1;  // simulated first roll of frame
      if (strike_previous || spare_previous) score += x_1;
      if (x_1 == 10) {
        score += 10;
        strike_previous = 1;
        spare_previous = 0;
      } else {
        int x_2;                          // must declare before drawing
        int pins = 11 - x_1 + 1;
        vector[pins] pi_ = pi[1:pins];
        pi_ /= sum(pi_);
        x_2 = categorical_rng(pi_) - 1;   // simulated second roll of frame
        if (strike_previous) score += x_2;
        if (x_1 + x_2 == 10) {
          score += 10;
          spare_previous = 1;
        } else {
          spare_previous = 0;
        }
        strike_previous = 0;
      }
    }
    // possible extra rolls in the tenth frame
    if (strike_previous) {
      int x_1 = categorical_rng(pi) - 1;   // simulated first extra roll
      if (x_1 == 10) {
        int x_2 = categorical_rng(pi) - 1; // simulated second extra roll
        score += x_1 + x_2;
      } else {
        int x_2;                          // must declare before drawing
        int pins = 11 - x_1 + 1;
        vector[pins] pi_ = pi[1:pins];
        pi_ /= sum(pi_);
        x_2 = categorical_rng(pi_) - 1;   // simulated second roll
        score += x_1 + x_2;
      }
    } else if (spare_previous) {
      int x_1 = categorical_rng(pi) - 1;  // simulated extra roll
      score += x_1;
    }
    return score;
  }
}
