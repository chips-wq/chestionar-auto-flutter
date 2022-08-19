//the widget containing the entire question

import 'package:flutter/material.dart';
import 'package:chestionar_auto/models.dart/question_model.dart';
import 'package:chestionar_auto/utils/app_colors.dart';
import 'package:chestionar_auto/widgets/quiz_answer.dart';

class QuestionBody extends StatelessWidget {
  final Question currentQuestion;
  final List<bool> selectedAnswers;
  final Function getStatus;
  final Function swap;

  const QuestionBody(
      {Key? key,
      required this.currentQuestion,
      required this.selectedAnswers,
      required this.getStatus,
      required this.swap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentQuestion.text,
          style: TextStyle(
              fontSize: currentQuestion.text.length > 200 ? 17 : 18,
              fontWeight: FontWeight.w300,
              color: AppColors.white),
        ),
        currentQuestion.image != null
            ? SizedBox(
                height: 10,
              )
            : SizedBox.shrink(),
        currentQuestion.image != null
            ? Image(
                image: AssetImage("assets/images/${currentQuestion.image}"),
              )
            : SizedBox.shrink(),
        SizedBox(
          height: 20,
        ),
        Container(
          //width: double.infinity,
          child: Column(
              children: selectedAnswers
                  .asMap()
                  .entries
                  .map(
                    (el) => QuizAnswer(
                        text: currentQuestion.answers[el.key].answer,
                        status: getStatus(el.key, el.value),
                        id: el.key,
                        swap: swap),
                  )
                  .toList()),
        )
      ],
    );
  }
}
