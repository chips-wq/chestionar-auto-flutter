import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:chestionar_auto/ui/widgets/quiz/quiz_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:chestionar_auto/core/models/question_model.dart';
import 'package:chestionar_auto/ui/widgets/quiz/question_body.dart';
import 'package:chestionar_auto/ui/widgets/quiz/quiz_heading.dart';
import 'package:chestionar_auto/ui/widgets/quiz/review_body.dart';
import 'package:provider/provider.dart';

class QuizWrapper extends StatelessWidget {
  const QuizWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => QuizProvider(), child: Quiz());
  }
}

class Quiz extends StatelessWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<QuizProvider, List<Question>?>(
        //when we get the data from the database update it
        selector: (context, quizProvider) => quizProvider.quiz,
        builder: (context, quiz, child) {
          if (quiz == null) {
            return const Scaffold(
              body: Center(
                child: Text(
                  "Loading ...",
                  style: TextStyle(fontSize: 24, color: AppColors.white),
                ),
              ),
            );
          }
          return Selector<QuizProvider, int>(
              //whenever the question index changes, update everything
              selector: (context, quizProvider) => quizProvider.questionIndex,
              builder: (context, questionIndex, child) {
                return ListenableProxyProvider0(
                  update: (context, _) =>
                      QuestionProvider(question: quiz[questionIndex]),
                  child: Scaffold(
                    body: SafeArea(
                      child: Container(
                        padding: EdgeInsets.all(24),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: ScrollConfiguration(
                                behavior: NoGlowBehavior(),
                                child: ListView(
                                  children: [
                                    QuizHeading(),
                                    //the actual question starts
                                    Selector<QuizProvider, bool>(
                                        selector: (context, quizProvider) =>
                                            quizProvider.showReview,
                                        builder: (context, showReview, child) {
                                          if (showReview) {
                                            return Review();
                                          }
                                          return const QuestionBody();
                                        })
                                  ],
                                ),
                              ),
                            ),
                            const QuizBottomBar(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
