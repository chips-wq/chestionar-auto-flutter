import 'package:flutter/material.dart';
import 'package:chestionar_auto/utils/app_colors.dart';
import 'package:chestionar_auto/widgets/progress_bar.dart';

class QuizHeading extends StatelessWidget {
  final int questionNumber;
  final int quizLength;
  final int correctAnswers;
  final int wrongAnswers;
  final List<int> statusHistory;
  final ScrollController scrollController;
  final List<GlobalKey> scrollKeys;

  const QuizHeading(
      {Key? key,
      required this.questionNumber,
      required this.quizLength,
      required this.correctAnswers,
      required this.wrongAnswers,
      required this.statusHistory,
      required this.scrollController,
      required this.scrollKeys})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Chestionar auto",
            style: TextStyle(color: AppColors.bgShade1, fontSize: 18),
          ),
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: AppColors.teal3),
                child: Center(
                  child: Text(
                    "$correctAnswers",
                    style: TextStyle(color: AppColors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3), color: Colors.red),
                child: Center(
                  child: Text(
                    "$wrongAnswers",
                    style: TextStyle(color: AppColors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 10),
      RichText(
        text: TextSpan(
          style: TextStyle(),
          children: [
            TextSpan(
              text: "Intrebarea ${questionNumber}",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                  color: AppColors.white),
            ),
            TextSpan(
              text: "/${quizLength}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: AppColors.bgShade1,
              ),
            )
          ],
        ),
      ),
      SizedBox(height: 10),
      //progress bar
      ProgressBar(
        statusHistory: statusHistory,
        scrollController: scrollController,
        scrollKeys: scrollKeys,
      ),
      //here the actual question starts
      SizedBox(height: 10),
    ]);
  }
}
