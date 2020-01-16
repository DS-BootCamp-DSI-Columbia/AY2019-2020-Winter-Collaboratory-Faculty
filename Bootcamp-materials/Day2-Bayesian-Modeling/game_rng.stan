functions {
  int[,] scorecard_rng(vector pi) {
    int scorecard[12, 2] = rep_array(0, 12, 2);
    for (frame in 1:10) {
      int x_1 = categorical_rng(pi) - 1;
      scorecard[frame, 1] = x_1;
      if (x_1 < 10) {
        int x_2;                          // must declare before drawing
        int pins = 10 - x_1 + 1;          // actually pins + 1
        vector[pins] pi_ = pi[1:pins];
        pi_ /= sum(pi_);
        x_2 = categorical_rng(pi_) - 1;   // simulated second roll of frame
        scorecard[frame, 2] = x_2;        
      }
    }
    if (scorecard[10, 1] == 10) {         // strike in tenth frame
      int x_1 = categorical_rng(pi) - 1;
      scorecard[11, 1] = x_1;
      if (x_1 < 10) {
        int x_2;                          // must declare before drawing
        int pins = 10 - x_1 + 1;          // actually pins + 1
        vector[pins] pi_ = pi[1:pins];
        pi_ /= sum(pi_);
        x_2 = categorical_rng(pi_) - 1;   // simulated second roll of frame
        scorecard[11, 2] = x_2;        
      } else {
        scorecard[12, 1] = categorical_rng(pi) - 1;
      }
    } else if (sum(scorecard[10, ]) == 10) { // spare in tenth frame
      scorecard[11, 1] = categorical_rng(pi) - 1;
    }
    return scorecard;
  }
  
  int score_game(int[,] scorecard) {
    int score = 0;
    for (frame in 1:10) {
      int x_1 = scorecard[frame, 1];
      score += x_1;
      if (x_1 == 10) {
        score += scorecard[frame + 1, 1];
        if (scorecard[frame + 1, 1] == 10) {
          score += scorecard[frame + 2, 1];
        } else score += scorecard[frame + 1, 2];
      } else {
        int x_2 = scorecard[frame, 2];
        score += x_2;
        if (x_1 + x_2 == 10) {
          score += scorecard[frame + 1, 1];
        }
      }
    }
    return score;
  }
}
