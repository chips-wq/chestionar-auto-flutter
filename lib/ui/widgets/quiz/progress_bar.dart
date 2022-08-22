import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
  }) : super(key: key);

  Color getColor(List<int> statusHistory, int index) {
    int status = statusHistory[index];
    if (index == 0) {
      if (statusHistory[0] == 0) {
        return AppColors.white;
      }
    } else if (statusHistory[index - 1] != 0 && status == 0) {
      return AppColors.white;
    }
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
    var quizProvider = Provider.of<QuizProvider>(context, listen: false);
    //scroll the progress bar into view
    if (quizProvider.scrollController.hasClients) {
      quizProvider.scrollController.position.ensureVisible(
        quizProvider.scrollKeys[quizProvider.questionIndex].currentContext!
            .findRenderObject()!,
        alignment:
            0.5, // how far into view the item should be scrolled (between 0 and 1).
        duration: const Duration(seconds: 1),
      );
    }
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
              color: getColor(quizProvider.statusHistory, i));
        },
      ),
    );
  }
}
