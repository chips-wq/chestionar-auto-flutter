import 'package:flutter/material.dart';
import 'package:chestionar_auto/database_helper.dart';
import 'package:chestionar_auto/models.dart/question_model.dart';
import 'package:chestionar_auto/utils/app_colors.dart';

class Review extends StatelessWidget {
  final Question currentQuestion;
  final Function nextQuestion;

  Review({Key? key, required this.currentQuestion, required this.nextQuestion})
      : super(key: key);

  void rateQuestion(int quality) {
    currentQuestion.updateSm2(quality);
    print(currentQuestion);
    DatabaseHelper().updateQuestion(currentQuestion);
    nextQuestion();
  }

  List<Widget> generateButtons(List<int> qualities) {
    return qualities
        .map(
          (quality) => Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              onPressed: () => rateQuestion(quality),
              style: ElevatedButton.styleFrom(
                primary: getColor(quality),
                fixedSize: Size(100, 100),
              ),
              child: Text(
                "${quality + 1}",
                style: TextStyle(fontSize: 52),
              ),
            ),
          ),
        )
        .toList();
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
