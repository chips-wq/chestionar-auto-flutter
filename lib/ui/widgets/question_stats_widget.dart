import 'package:chestionar_auto/core/models/questions_stats.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:chestionar_auto/ui/widgets/question_information_widget.dart';
import 'package:flutter/cupertino.dart';

class QuestionStatsWidget extends StatelessWidget {
  const QuestionStatsWidget(
      {Key? key, required this.isLoading, required this.stats})
      : super(key: key);

  final bool isLoading;
  final QuestionsStats? stats; // <- is null while loading

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QuestionInformationBox(
            categoryName: "De revizuit",
            loading: isLoading,
            amountQuestions: stats?.toReviewNowQuestions,
            borderColor: AppColors.teal3,
            bottomText: "Ramase"),
        SizedBox(
          width: 6,
        ),
        QuestionInformationBox(
            categoryName: "De invatat",
            loading: isLoading,
            amountQuestions: stats?.toLearnNowQuestions,
            borderColor: AppColors.orange,
            bottomText: "Ramase"),
        SizedBox(
          width: 6,
        ),
        QuestionInformationBox(
            categoryName: "Nevazute",
            loading: isLoading,
            amountQuestions: stats?.neverSeenQuestions,
            borderColor: AppColors.lightBlue,
            bottomText: "Ramase"),
      ],
    );
  }
}
