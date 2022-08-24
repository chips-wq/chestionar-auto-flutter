import 'package:chestionar_auto/core/models/question_model.dart';
import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:chestionar_auto/core/utils/question_utils.dart';
import 'package:flutter/cupertino.dart';

enum AnswerState { wrong, unselected, selected }

class QuestionProvider extends ChangeNotifier {
  Question question;

  List<AnswerState> selectedAnswers;
  bool answeredIncorrectly = false;

  void swap(int id) {
    if (!answeredIncorrectly) {
      if (selectedAnswers[id] == AnswerState.unselected) {
        selectedAnswers[id] = AnswerState.selected;
      } else if (selectedAnswers[id] == AnswerState.selected) {
        selectedAnswers[id] = AnswerState.unselected;
      }
      notifyListeners();
    }
  }

  QuestionProvider({required this.question})
      : selectedAnswers =
            question.answers.map((e) => AnswerState.unselected).toList();

  bool validate(QuizProvider quizProvider) {
    //returns true if correct false otherwise
    if (!QuestionUtils.isSelectedCorrect(
        selectedAnswers, question.correctAnswer)) {
      //this branch handles incorrect answer of a question
      answeredIncorrectly = true;
      //set selected answers so that we highlight them in red
      selectedAnswers =
          QuestionUtils.getArrayFromAnswerNumber(question.correctAnswer)
              .map((e) => e == AnswerState.selected
                  ? AnswerState.wrong
                  : AnswerState.unselected)
              .toList();
      quizProvider.setCurrentIncorrect();
      notifyListeners();
      return false;
    }
    //this branch handles if it was a correct answer
    quizProvider.setCurrentCorrect();
    return true;
  }
}
