import 'package:chestionar_auto/core/models/questions_stats.dart';
import 'package:chestionar_auto/core/provider/enums.dart';
import 'package:chestionar_auto/core/services/database_helper.dart';
import 'package:flutter/cupertino.dart';

class QuestionStatsProvider extends ChangeNotifier {
  bool isLoading = false;

  DrivingCategory drivingCategory;

  QuestionsStats? _stats;

  QuestionsStats? get stats => _stats;

  Future<void> fetchQuestionStats() async {
    isLoading = true;
    notifyListeners();
    _stats = await DatabaseHelper().getQuestionsStats(drivingCategory);
    isLoading = false;
    notifyListeners();
  }

  void updateDrivingCategory(DrivingCategory newDrivingCategory) {
    drivingCategory = newDrivingCategory;
    fetchQuestionStats();
  }

  QuestionStatsProvider(this.drivingCategory) {
    fetchQuestionStats();
  }
}
