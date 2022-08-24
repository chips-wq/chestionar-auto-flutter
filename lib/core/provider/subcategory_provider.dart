import 'package:chestionar_auto/core/models/subcategory_model.dart';
import 'package:chestionar_auto/core/provider/enums.dart';
import 'package:chestionar_auto/core/services/database_helper.dart';
import 'package:flutter/cupertino.dart';

class SubcategoryProvider extends ChangeNotifier {
  bool isLoadingStats = false;

  Subcategory subcategory;
  DrivingCategory drivingCategory;

  Future<void> getSubcategoryStats() async {
    isLoadingStats = true;
    notifyListeners();
    subcategory.stats =
        await DatabaseHelper().getQuestionsStats(drivingCategory, subcategory);
    isLoadingStats = false;
    notifyListeners();
  }

  SubcategoryProvider(this.drivingCategory, this.subcategory) {
    getSubcategoryStats();
  }
}
