import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:chestionar_auto/utils/app_colors.dart';
import 'package:provider/provider.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
  }) : super(key: key);

  Color getColor(List<int> statusHistory ,int index) {
    int status = statusHistory[index];
    if (status == -1) {
      return Colors.red;
    }
    if (status == 0) {
      return AppColors.bgShade1;
    }
    return AppColors.teal3;
  }

  @override
  Widget build(BuildContext context) {
    var quizProvider = Provider.of<QuizProvider>(context);
    return Container(
        height: 20,
        child: ListView.builder(
           controller: quizProvider.scrollController,
          padding: EdgeInsets.symmetric(vertical: 8),
          scrollDirection: Axis.horizontal,
          itemCount: quizProvider.statusHistory.length,
          itemBuilder: (context, i) {
            return Container(
                 key: quizProvider.scrollKeys[i],
                margin: EdgeInsets.symmetric(horizontal: 2),
                width: 15,
                color: getColor(quizProvider.statusHistory,i));
          },
        ));
  }
}
