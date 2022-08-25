import 'package:chestionar_auto/core/models/subcategory_model.dart';
import 'package:chestionar_auto/core/provider/enums.dart';
import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:chestionar_auto/ui/shared/no_glow_behaviour.dart';
import 'package:chestionar_auto/ui/widgets/quiz/quiz_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:chestionar_auto/core/models/question_model.dart';
import 'package:chestionar_auto/ui/widgets/quiz/question_body.dart';
import 'package:chestionar_auto/ui/widgets/quiz/quiz_heading.dart';
import 'package:chestionar_auto/ui/widgets/quiz/review_body.dart';
import 'package:provider/provider.dart';

class QuizWrapper extends StatelessWidget {
  final bool isPractice;
  final DrivingCategory drivingCategory;
  final Subcategory? subcategory;
  const QuizWrapper({
    required this.isPractice,
    required this.drivingCategory,
    this.subcategory,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => QuizProvider(isPractice, drivingCategory, subcategory),
        child: Quiz());
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
                  "Se încarcă ...",
                  style: TextStyle(fontSize: 24, color: AppColors.white),
                ),
              ),
            );
          }
          if (quiz.isEmpty) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.assignment_turned_in,
                          color: AppColors.teal3, size: 48),
                      const Text(
                        "Nu mai ai întrebări de revizuit acum, revino mai târziu sau încearca modul Simulare.",
                        style: TextStyle(color: AppColors.white, fontSize: 16),
                      ),
                      OutlinedButton(
                          onPressed: () => {Navigator.pop(context)},
                          child: const Text("Înapoi"))
                    ],
                  ),
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
