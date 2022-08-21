import 'package:chestionar_auto/core/provider/question_provider.dart';

class QuestionUtils {
  static List<AnswerState> getArrayFromAnswerNumber(int answer) {
    //NOTE: Assuming that answer is in the range [1,7], so the resulting array has three elements with all possible combinations
    List<AnswerState> correctAnswers = [
      AnswerState.unselected,
      AnswerState.unselected,
      AnswerState.unselected
    ];
    if (answer <= 3) {
      correctAnswers[answer - 1] = AnswerState.selected;
      return correctAnswers;
    }
    if (answer == 4) {
      correctAnswers[0] = correctAnswers[1] = AnswerState.selected;
      return correctAnswers;
    }
    if (answer == 5) {
      correctAnswers[0] = correctAnswers[2] = AnswerState.selected;
      return correctAnswers;
    }
    if (answer == 6) {
      correctAnswers[1] = correctAnswers[2] = AnswerState.selected;
      return correctAnswers;
    }
    if (answer == 7) {
      correctAnswers[0] =
          correctAnswers[1] = correctAnswers[2] = AnswerState.selected;
      return correctAnswers;
    }
    throw ("Answer not in the range [1,7]");
  }

  static bool isSelectedCorrect(List<AnswerState> selectedAnswers, int answer) {
    //NOTE: Assuming that answer is in the range [1,7], so the resulting array has three elements with all possible combinations
    List<AnswerState> correctAnswers = getArrayFromAnswerNumber(answer);
    return selectedAnswers[0] == correctAnswers[0] &&
        selectedAnswers[1] == correctAnswers[1] &&
        selectedAnswers[2] == correctAnswers[2];
  }
}
