//the widget containing the entire question

import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:flutter/material.dart';
import 'package:chestionar_auto/core/models/question_model.dart';
import 'package:chestionar_auto/utils/app_colors.dart';
import 'package:chestionar_auto/widgets/quiz_answer.dart';
import 'package:provider/provider.dart';

class QuestionBody extends StatelessWidget {
  const QuestionBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionProvider>(
        builder: (context, questionProvider, child) {
      var currQuestion = questionProvider.question;
      print("building question body");
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
          Container(
            //width: double.infinity,
            child: Column(
                children: questionProvider.selectedAnswers
                    .asMap()
                    .entries
                    .map(
                      (el) => QuizAnswer(
                        text: currQuestion.answers[el.key].answer,
                        status: Provider.of<QuestionProvider>(context,
                                listen: false)
                            .getStatus(el.key, el.value),
                        id: el.key,
                      ),
                    )
                    .toList()),
          )
        ],
      );
    });
  }
}
