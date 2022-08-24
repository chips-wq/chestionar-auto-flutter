import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:chestionar_auto/ui/widgets/quiz/question_explanation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizBottomBar extends StatelessWidget {
  const QuizBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var quizProvider = Provider.of<QuizProvider>(context);
    var questionProvider = Provider.of<QuestionProvider>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () => {Navigator.pop(context)},
            child: Text("Iesire"),
          ),
          SizedBox(
            width: 10,
          ),
          OutlinedButton(
            onPressed: Provider.of<QuestionProvider>(context, listen: false)
                        .question
                        .explanation ==
                    null
                ? () => {}
                : () => {
                      showBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        context: context,
                        backgroundColor: AppColors.bgShade2,
                        builder: ((context) => DraggableScrollableSheet(
                              maxChildSize: 0.90,
                              expand: false,
                              builder: ((context, scrollController) =>
                                  SingleChildScrollView(
                                    controller: scrollController,
                                    child: ExplanationWidget(),
                                  )),
                            )),
                      ),
                    },
            child: Text("Explicatie"),
          ),
          SizedBox(
            width: !quizProvider.showReview ? 10 : 0,
          ),
          quizProvider.showReview
              ? SizedBox.shrink()
              : ElevatedButton(
                  onPressed: () => {
                        questionProvider.validate(quizProvider)
                        // validate()
                        //check if the answer is correct
                      },
                  child:
                      Provider.of<QuestionProvider>(context).answeredIncorrectly
                          ? Text("Evalueaza")
                          : Text("Raspunde"))
        ],
      ),
    );
  }
}
