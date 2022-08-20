class QuestionsStats{
  int totalQuestions;
  int neverSeenQuestions;
  int learningQuestions;
  int reviewQuestions;

  int neverSeenPercent;
  int learningPercent;
  int reviewPercent;

  QuestionsStats({required this.totalQuestions ,  required this.neverSeenQuestions ,
    required this.learningQuestions , required this.reviewQuestions}) :
        neverSeenPercent = ((neverSeenQuestions / totalQuestions) * 100).floor(),
        learningPercent = ((learningQuestions / totalQuestions) * 100).floor(),
        reviewPercent = ((reviewQuestions / totalQuestions) * 100).floor();
}
