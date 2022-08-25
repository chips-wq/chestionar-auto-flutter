import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/cupertino.dart';

class QuestionInformationBox extends StatelessWidget {
  final String categoryName;
  final bool loading;
  final int? amountQuestions;
  final String bottomText;
  final Color borderColor;

  const QuestionInformationBox(
      {required this.categoryName,
      required this.loading,
      required this.amountQuestions,
      required this.bottomText,
      required this.borderColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          categoryName,
          style: TextStyle(fontSize: 14, color: AppColors.white),
        ),
        loading
            ? Container(height: 12, width: 60, color: AppColors.bgShade1)
            : Text(
                "$amountQuestions",
                style: TextStyle(fontSize: 15, color: AppColors.white),
              ),
        SizedBox(
          height: loading ? 5 : 0,
        ),
        loading
            ? Container(height: 12, width: 50, color: AppColors.bgShade1)
            : Text(
                "$bottomText",
                style: TextStyle(fontSize: 15, color: AppColors.bgShade1),
              ),
      ]),
    );
  }
}
