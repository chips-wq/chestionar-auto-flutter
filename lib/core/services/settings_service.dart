import 'package:chestionar_auto/core/provider/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  bool isLoading = false;
  bool? isFirstLaunch;
  DrivingCategory? drivingCategory;

  Future<void> setFirstLaunch(bool firstLaunchVal) async {
    isFirstLaunch = firstLaunchVal;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstLaunch', isFirstLaunch!);
  }

  Future<void> setDrivingCategory(DrivingCategory newDrivingCategory) async {
    drivingCategory = newDrivingCategory;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('drivingCategory', drivingCategory!.toShortString());
  }

  Future<void> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    isFirstLaunch = prefs.getBool('isFirstLaunch');
    if (isFirstLaunch == null) {
      isFirstLaunch = true;
      prefs.setBool('isFirstLaunch', isFirstLaunch!);
    }
    String? drivingCategoryStr = prefs.getString('drivingCategory');
    if (drivingCategoryStr == null) {
      drivingCategory = DrivingCategory.B;
      prefs.setString('drivingCategory', drivingCategory!.toShortString());
    } else {
      drivingCategory = DrivingCategory.values.firstWhere(
          (element) => element.toShortString() == drivingCategoryStr);
    }
  }

  SettingsService();
}
