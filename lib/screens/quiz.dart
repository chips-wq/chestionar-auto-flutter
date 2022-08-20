import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:chestionar_auto/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:chestionar_auto/core/models/question_model.dart';
import 'package:chestionar_auto/widgets/question_body.dart';
import 'package:chestionar_auto/widgets/quiz_heading.dart';
import 'package:chestionar_auto/widgets/review_body.dart';
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
                                          return QuestionBody();
                                        })
                                  ],
                                ),
                              ),
                            ),
                            QuizBottomBar(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
          // return Text("hello world");
        });
  }
}

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
            width: 30,
          ),
          //TODO: bottom sheet needs work, overrflow and design probably
          OutlinedButton(
            onPressed: () => {
              showBottomSheet(
                context: context,
                builder: ((context) => Container(
                    height: 400,
                    padding: EdgeInsets.all(32),
                    color:AppColors.bgShade2,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Explicatie",
                          style: TextStyle(
                              fontSize: 24, color: AppColors.white),
                        ),
                        Text(questionProvider.question.explanation , style:TextStyle(color:AppColors.white , fontSize: 16)),
                      ],
                    ))),
              ),
            },
            child: Text("Explicatie"),
          ),
          SizedBox(
            width: !quizProvider.showReview ? 30 : 0,
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

// class _QuizState extends State<Quiz> {
// int questionIndex = 0;
// int correctAnswers = 0;
// int wrongAnswers = 0;
// bool answeredIncorrectly = false;
// bool showReview = false;
//
// late Question currentQuestion = widget.quizList[questionIndex];
// late List<int> statusHistory = widget.quizList.map((e) => 0).toList();
//
// late List<GlobalKey> scrollKeys =
//     widget.quizList.map((e) => GlobalKey()).toList();
//
// ScrollController scrollController = ScrollController();
//
// @override
// void dispose() {
//   scrollController.dispose();
//   super.dispose();
// }
//
// void exit() {
//   Navigator.pop(context);
// }
//
// void setShowReview() {
//   setState(() {
//     showReview = !showReview;
//   });
// }

// void nextQuestion() {
//   setShowReview();
//   scrollController.position.ensureVisible(
//     scrollKeys[questionIndex].currentContext!.findRenderObject()!,
//     alignment:
//         0.5, // How far into view the item should be scrolled (between 0 and 1).
//     duration: const Duration(seconds: 1),
//   );
//   setState(() {
//     answeredIncorrectly = false;
//     if (questionIndex + 1 < widget.quizList.length) {
//       resetSelected();
//       questionIndex++;
//       currentQuestion = widget.quizList[questionIndex];
//     } else {
//       exit();
//     }
//   });
// }

// void validate(List<bool> selectedAnswers) {
//   if (answeredIncorrectly) {
//     setShowReview();
//     return;
//   }
//   if (!currentQuestion.isSelectedCorrect(selectedAnswers)) {
//     setState(() {
//       answeredIncorrectly = true;
//       statusHistory[questionIndex] = -1;
//       wrongAnswers++;
//     });
//     return;
//   }
//   setState(() {
//     correctAnswers++;
//     statusHistory[questionIndex] = 1;
//   });
//   setShowReview();
// }
//
// int getStatus(int key, bool currentSelected) {
//   if (answeredIncorrectly) {
//     if (currentQuestion.correctAnswer == 7) {
//       return -1;
//     }
//     if (currentQuestion.correctAnswer == 6 && (key == 1 || key == 2)) {
//       return -1;
//     }
//     if (currentQuestion.correctAnswer == 5 && (key == 0 || key == 2)) {
//       return -1;
//     }
//     if (currentQuestion.correctAnswer == 4 && (key == 0 || key == 1)) {
//       return -1;
//     }
//     return key == currentQuestion.correctAnswer - 1 ? -1 : 0;
//   }
//   return currentSelected ? 1 : 0;
// }
// @override
// Widget build(BuildContext context) {
//   return ChangeNotifierProvider(
//     create: (_) => QuestionProvider(question: null),
//     child: Scaffold(
//       body: SafeArea(
//         child: Container(
//           padding: EdgeInsets.all(24),
//           child: Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 50),
//                 child: ScrollConfiguration(
//                   behavior: NoGlowBehavior(),
//                   child: ListView(
//                     children: [
//                       // QuizHeading(
//                       //     questionNumber: questionIndex + 1,
//                       //     quizLength: widget.quizList.length,
//                       //     correctAnswers: correctAnswers,
//                       //     wrongAnswers: wrongAnswers,
//                       //     statusHistory: statusHistory,
//                       //     scrollController: scrollController,
//                       //     scrollKeys: scrollKeys),
//                       //the actual question starts
//                       // showReview
//                       //     ? Review(
//                       //         nextQuestion: nextQuestion,
//                       //         currentQuestion: currentQuestion,
//                       //       )
//                       //     : QuestionBody(
//                       //         getStatus: getStatus,
//                       // )
//                     ],
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // OutlinedButton(
//                     //   onPressed: () => {exit()},
//                     //   child: Text("Iesire"),
//                     // ),
//                     // SizedBox(
//                     //   width: !showReview ? 30 : 0,
//                     // ),
//                     // showReview
//                     //     ? SizedBox.shrink()
//                     //     : ElevatedButton(
//                     //         onPressed: () => {
//                     //               validate()
//                     //               //check if the answer is correct
//                     //             },
//                     //         child: answeredIncorrectly
//                     //             ? Text("Evalueaza")
//                     //             : Text("Raspunde"))
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       // floatingActionButton:
//       //     FloatingActionButton(onPressed: () => {DatabaseHelper().test()}),
//     ),
//   );
// }
// }

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
