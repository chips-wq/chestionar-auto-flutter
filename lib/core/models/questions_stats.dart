class QuestionsStats {
  int totalQuestions;

  int neverSeenQuestions;
  int learningQuestions;
  int reviewQuestions;

  int neverSeenPercent;
  int learningPercent;
  int reviewPercent;

  int toLearnNowQuestions;
  int toReviewNowQuestions;

  QuestionsStats(
      {required this.totalQuestions,
      required this.neverSeenQuestions,
      required this.learningQuestions,
      required this.reviewQuestions,
      required this.toLearnNowQuestions,
      required this.toReviewNowQuestions})
      : neverSeenPercent =
            ((neverSeenQuestions / totalQuestions) * 100).floor(),
        learningPercent = ((learningQuestions / totalQuestions) * 100).floor(),
        reviewPercent = ((reviewQuestions / totalQuestions) * 100).floor();
}
