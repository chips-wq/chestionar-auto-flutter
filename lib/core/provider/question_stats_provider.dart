import 'package:chestionar_auto/core/models/questions_stats.dart';
import 'package:chestionar_auto/core/services/database_helper.dart';
import 'package:flutter/cupertino.dart';

class QuestionStatsProvider extends ChangeNotifier {
  QuestionsStats? _stats;

  QuestionsStats? get stats => _stats;

  Future<void> fetchQuestionStats() async {
    _stats = null;
    notifyListeners();
    _stats = await DatabaseHelper().getQuestionsStats();
    notifyListeners();
  }

  QuestionStatsProvider() {
    fetchQuestionStats();
  }
}
