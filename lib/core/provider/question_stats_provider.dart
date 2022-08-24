import 'package:chestionar_auto/core/models/questions_stats.dart';
import 'package:chestionar_auto/core/models/subcategory_model.dart';
import 'package:chestionar_auto/core/provider/enums.dart';
import 'package:chestionar_auto/core/services/database_helper.dart';
import 'package:flutter/cupertino.dart';

class GeneralQuestionStatsProvider extends ChangeNotifier {
  bool isLoading = false;

  DrivingCategory drivingCategory;
  List<Subcategory>? _subcategories;

  QuestionsStats? _stats;

  List<Subcategory>? get subcategories => _subcategories;
  QuestionsStats? get stats => _stats;

  Future<void> fetchQuestionStats() async {
    isLoading = true;
    notifyListeners();
    _stats = await DatabaseHelper().getQuestionsStats(drivingCategory);
    _subcategories = await DatabaseHelper().getSubcategories(drivingCategory);
    isLoading = false;
    notifyListeners();
  }

  void updateDrivingCategory(DrivingCategory newDrivingCategory) {
    drivingCategory = newDrivingCategory;
    fetchQuestionStats();
  }

  GeneralQuestionStatsProvider(this.drivingCategory) {
    fetchQuestionStats();
  }
}
