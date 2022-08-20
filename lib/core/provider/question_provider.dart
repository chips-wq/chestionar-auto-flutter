
import 'package:chestionar_auto/core/models/question_model.dart';
import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:flutter/cupertino.dart';

class QuestionProvider extends ChangeNotifier{
  Question question;

  List<bool> selectedAnswers;
  bool answeredIncorrectly = false;

  void swap(int id) {
    selectedAnswers[id] = !selectedAnswers[id];
    notifyListeners();
  }

  void resetSelected() {
    selectedAnswers = selectedAnswers
        .map(
          (e) => false,
    )
        .toList();
    notifyListeners();
  }

  QuestionProvider({required this.question}) : selectedAnswers = question.answers.map((e) => false).toList();

  int getStatus(int key, bool currentSelected) {
    if (answeredIncorrectly) {
      if (question.correctAnswer == 7) {
        return -1;
      }
      if (question.correctAnswer == 6 && (key == 1 || key == 2)) {
        return -1;
      }
      if (question.correctAnswer == 5 && (key == 0 || key == 2)) {
        return -1;
      }
      if (question.correctAnswer == 4 && (key == 0 || key == 1)) {
        return -1;
      }
      return key == question.correctAnswer - 1 ? -1 : 0;
    }
    return currentSelected ? 1 : 0;
  }

  void validate(QuizProvider quizProvider) {
    if (answeredIncorrectly) {
      quizProvider.toggleReview();
      return;
    }
    if (!question.isSelectedCorrect(selectedAnswers)) {
      answeredIncorrectly = true;
      quizProvider.setCurrentIncorrect();
      notifyListeners();
      return;
    }
    quizProvider.setCurrentCorrect();
    quizProvider.toggleReview();
  }

}