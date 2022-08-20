import 'package:chestionar_auto/core/models/question_model.dart';
import 'package:chestionar_auto/core/provider/question_provider.dart';
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
    scrollController.position.ensureVisible(
      scrollKeys[questionIndex].currentContext!.findRenderObject()!,
      alignment:
          0.5, // how far into view the item should be scrolled (between 0 and 1).
      duration: const Duration(seconds: 1),
    );
    if (questionIndex + 1 < quiz!.length) {
      questionIndex++;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> getQuiz() async {
    quiz = await DatabaseHelper().getQuestions(26);
    statusHistory = quiz!.map((e) => 0).toList();
    scrollKeys = quiz!.map((e) => GlobalKey()).toList();
    notifyListeners();
  }

  QuizProvider() {
    getQuiz();
  }
}
