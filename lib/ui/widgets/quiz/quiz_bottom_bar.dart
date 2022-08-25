import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:chestionar_auto/ui/widgets/quiz/question_explanation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizBottomBar extends StatelessWidget {
  const QuizBottomBar({Key? key}) : super(key: key);

  void goForward(BuildContext context, QuizProvider quizProvider) {
    //either goes to review if this is practice or to the next question if this is simulation(is practice is false)
    if (quizProvider.isPractice) {
      quizProvider.toggleReview();
    } else {
      var ended = !quizProvider.nextQuestion();
      if (ended) {
        Navigator.pop(context);
      }
    }
  }

  void validateAnswer(BuildContext context, QuestionProvider questionProvider,
      QuizProvider quizProvider) {
    bool isCorrect = questionProvider.validate(quizProvider);
    if (isCorrect) {
      goForward(context, quizProvider);
    }
  }

  String getMainButtonText(bool answeredIncorrectly, bool isPractice) {
    if (answeredIncorrectly) {
      if (isPractice) {
        return 'Evalueaza';
      } else {
        return 'Urmatoarea';
      }
    }
    return 'Raspunde';
  }

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
            width: 4,
          ),
          OutlinedButton(
            onPressed: questionProvider.question.explanation == null
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
            width: !quizProvider.showReview ? 4 : 0,
          ),
          quizProvider.showReview
              ? SizedBox.shrink()
              : ElevatedButton(
                  onPressed: questionProvider.answeredIncorrectly
                      ? () => goForward(context, quizProvider)
                      : () => {
                            validateAnswer(
                                context, questionProvider, quizProvider)
                          },
                  child: Text(
                    getMainButtonText(questionProvider.answeredIncorrectly,
                        quizProvider.isPractice),
                  ),
                )
        ],
      ),
    );
  }
}
