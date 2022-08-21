import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:chestionar_auto/ui/widgets/progress_bar.dart';
import 'package:provider/provider.dart';

class QuizHeading extends StatelessWidget {
  const QuizHeading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //we don't have to listen to changes because this should rebuilt only on questionIndex change, and we already have a selector
    //for that up the widget tree which in turn updates this
    var quizProvider = Provider.of<QuizProvider>(context, listen: false);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
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
                    "${quizProvider.correctAnswers}",
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
                    "${quizProvider.wrongAnswers}",
                    style: TextStyle(color: AppColors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(),
                children: [
                  TextSpan(
                    text: "Intrebarea ${quizProvider.questionIndex + 1}",
                    style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                        color: AppColors.white),
                  ),
                  TextSpan(
                    text: "/${quizProvider.quiz!.length}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: AppColors.bgShade1,
                    ),
                  )
                ],
              ),
            ),
            Text(
              Provider.of<QuestionProvider>(context, listen: false)
                  .question
                  .typeName,
              style: const TextStyle(fontSize: 22, color: AppColors.white),
            ),
          ]),
      const SizedBox(height: 10),
      //progress bar
      ProgressBar(),
      const SizedBox(height: 10),
    ]);
  }
}
