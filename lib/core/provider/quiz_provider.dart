import 'package:chestionar_auto/core/models/question_model.dart';
import 'package:chestionar_auto/core/provider/enums.dart';
import 'package:chestionar_auto/core/services/database_helper.dart';
import 'package:flutter/cupertino.dart';

class QuizProvider extends ChangeNotifier {
  List<Question>? quiz;

  int questionIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;

  bool showReview = false;

  ScrollController scrollController = ScrollController();
  late List<int> statusHistory;
  late List<GlobalKey> scrollKeys;

  void toggleReview() {
    showReview = !showReview;
    notifyListeners();
  }

  void setCurrentIncorrect() {
    wrongAnswers++;
    statusHistory[questionIndex] = -1;
    notifyListeners();
  }

  void setCurrentCorrect() {
    correctAnswers++;
    statusHistory[questionIndex] = 1;
    notifyListeners();
  }

  bool nextQuestion() {
    //returns true if it got to the next question(if there is one) and false otherwise
    toggleReview();
    if (questionIndex + 1 < quiz!.length) {
      questionIndex++;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> getQuiz(DrivingCategory drivingCategory) async {
    quiz = await DatabaseHelper().getQuestions(26, drivingCategory);
    statusHistory = quiz!.map((e) => 0).toList();
    scrollKeys = quiz!.map((e) => GlobalKey()).toList();
    notifyListeners();
  }

  QuizProvider(DrivingCategory drivingCategory) {
    getQuiz(drivingCategory);
  }
}
