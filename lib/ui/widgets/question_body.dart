//the widget containing the entire question

import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:chestionar_auto/ui/widgets/quiz_answer.dart';
import 'package:provider/provider.dart';

class QuestionBody extends StatelessWidget {
  const QuestionBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currQuestion =
        Provider.of<QuestionProvider>(context, listen: false).question;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currQuestion.text,
          style: TextStyle(
              fontSize: currQuestion.text.length > 200 ? 17 : 18,
              fontWeight: FontWeight.w300,
              color: AppColors.white),
        ),
        currQuestion.image != null
            ? SizedBox(
                height: 10,
              )
            : SizedBox.shrink(),
        currQuestion.image != null
            ? Image(
                image: AssetImage("assets/images/${currQuestion.image}"),
              )
            : SizedBox.shrink(),
        SizedBox(
          height: 20,
        ),
        //TODO: figure out how to use a selector on selected answers
        Consumer<QuestionProvider>(builder: (_, questionProvider, __) {
          var selectedAnswers = questionProvider.selectedAnswers;
          return Container(
            child: Column(
                children: selectedAnswers
                    .asMap()
                    .entries
                    .map(
                      (el) => QuizAnswer(
                        text: currQuestion.answers[el.key].answer,
                        status: selectedAnswers[el.key],
                        id: el.key,
                      ),
                    )
                    .toList()),
          );
        }),
      ],
    );
  }
}
