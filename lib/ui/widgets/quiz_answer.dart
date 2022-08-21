import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String idToChar(int id) {
  if (id == 0) {
    return 'A';
  }
  if (id == 1) {
    return 'B';
  }
  return 'C';
}

class QuizAnswer extends StatelessWidget {
  final String text;
  final AnswerState status;
  final int id;

  const QuizAnswer(
      {Key? key, required this.text, required this.id, required this.status})
      : super(key: key);

  Color getColor() {
    if (status == AnswerState.wrong) {
      //should be highlighted in red
      return Colors.red;
    }
    if (status == AnswerState.selected) {
      return AppColors.teal3;
    }
    return AppColors.bgShade3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      child: GestureDetector(
        onTap: () =>
            {Provider.of<QuestionProvider>(context, listen: false).swap(id)},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: getColor()),
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF181E38),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color:
                      status == AnswerState.selected ? AppColors.teal3 : null,
                  border: Border.all(width: 2, color: getColor()),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(idToChar(id),
                      style: TextStyle(color: AppColors.white, fontSize: 18)),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Text(text,
                    style: TextStyle(color: AppColors.white, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
