import 'package:chestionar_auto/core/provider/enums.dart';
import 'package:chestionar_auto/core/provider/question_stats_provider.dart';
import 'package:chestionar_auto/core/services/settings_service.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetariPage extends StatelessWidget {
  const SetariPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO: make this look nice
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, 'tutorial'),
            child: Text(
              "Tutorial",
              style: TextStyle(fontSize: 24, color: AppColors.white),
            ),
          ),
          Text(
            "Schimba Categoria",
            style: TextStyle(fontSize: 24, color: AppColors.white),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: DrivingCategory.values
                  .map((value) => MiniCategoryWidget(drivingCategory: value))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class MiniCategoryWidget extends StatelessWidget {
  final DrivingCategory drivingCategory;

  const MiniCategoryWidget({
    required this.drivingCategory,
    Key? key,
  }) : super(key: key);

  void updateDrivingCategory(BuildContext context) {
    Provider.of<GeneralQuestionStatsProvider>(context, listen: false)
        .updateDrivingCategory(drivingCategory);
    Provider.of<SettingsService>(context, listen: false)
        .setDrivingCategory(drivingCategory);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(
          "Categoria schimbata in ${drivingCategory.toShortString()}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 0),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      height: 80,
      width: 80,
      child: ElevatedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.bgShade2,
        ),
        onPressed: () => {updateDrivingCategory(context)},
        child: Text(
          drivingCategory.toShortString(),
          style: TextStyle(fontSize: 48, color: AppColors.white),
        ),
      ),
    );
  }
}
