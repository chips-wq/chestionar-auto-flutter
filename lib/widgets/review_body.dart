import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:chestionar_auto/core/services/database_helper.dart';
import 'package:chestionar_auto/core/models/question_model.dart';
import 'package:chestionar_auto/utils/app_colors.dart';
import 'package:provider/provider.dart';

class Review extends StatelessWidget {
  Review({Key? key}) : super(key: key);

  List<Widget> generateButtons(List<int> qualities) {
    return qualities
        .map((e) => QualityBox(
              quality: e,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cat de usoara a fost intrebarea?",
          style: TextStyle(color: AppColors.white, fontSize: 24),
        ),
        SizedBox(
          height: 15,
        ),
        Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: generateButtons([0, 1]),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: generateButtons([2, 3]),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: generateButtons([4, 5]),
          ),
        ])
      ],
    );
  }
}

class QualityBox extends StatelessWidget {
  final int quality;

  const QualityBox({required this.quality, Key? key}) : super(key: key);

  void rateQuestion(context,
      QuestionProvider questionProvider, Function() nextQuestion, int quality) {
    var currQuestion = questionProvider.question;
    currQuestion.updateSm2(quality);
    print(currQuestion);
    DatabaseHelper().updateQuestion(currQuestion);
    var ended = !nextQuestion();
    if(ended){
      Navigator.pop(context);
    }
  }

  Color getColor(int quality) {
    if (quality == 0) {
      return Colors.white10;
    }
    if (quality == 1) {
      return Colors.white24;
    }
    if (quality == 2) {
      return Color.fromARGB(255, 8, 80, 62);
    }
    if (quality == 3) {
      return Color.fromARGB(255, 10, 129, 99);
    }
    if (quality == 4) {
      return Color.fromARGB(255, 14, 173, 134);
    }
    return AppColors.teal3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        onPressed: () => rateQuestion(
          context,
            Provider.of<QuestionProvider>(context, listen: false),
            Provider.of<QuizProvider>(context, listen: false).nextQuestion,
            quality),
        style: ElevatedButton.styleFrom(
          primary: getColor(quality),
          fixedSize: Size(100, 100),
        ),
        child: Text(
          "${quality + 1}",
          style: TextStyle(fontSize: 52),
        ),
      ),
    );
  }
}
