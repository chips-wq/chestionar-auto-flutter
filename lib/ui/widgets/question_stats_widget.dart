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
    return Center(
      child: SizedBox(
        width: 320,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: QuestionInformationBox(
                  categoryName: "Revizuire",
                  loading: isLoading,
                  amountQuestions: stats?.toReviewNowQuestions,
                  borderColor: AppColors.teal3,
                  bottomText: "Rămase"),
            ),
            SizedBox(
              width: 6,
            ),
            Expanded(
              child: QuestionInformationBox(
                  categoryName: "Învățare",
                  loading: isLoading,
                  amountQuestions: stats?.toLearnNowQuestions,
                  borderColor: AppColors.orange,
                  bottomText: "Rămase"),
            ),
            SizedBox(
              width: 6,
            ),
            Expanded(
              child: QuestionInformationBox(
                  categoryName: "Nevăzute",
                  loading: isLoading,
                  amountQuestions: stats?.neverSeenQuestions,
                  borderColor: AppColors.lightBlue,
                  bottomText: "Rămase"),
            ),
          ],
        ),
      ),
    );
  }
}
