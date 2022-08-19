import 'package:flutter/material.dart';
import 'package:chestionar_auto/models.dart/question_model.dart';
import 'package:chestionar_auto/widgets/question_body.dart';
import 'package:chestionar_auto/widgets/quiz_heading.dart';
import 'package:chestionar_auto/widgets/review_body.dart';

class Quiz extends StatefulWidget {
  final List<Question> quizList;
  const Quiz({
    Key? key,
    required this.quizList,
  }) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int questionIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  bool answeredIncorrectly = false;
  bool showReview = false;

  late Question currentQuestion = widget.quizList[questionIndex];
  late List<int> statusHistory = widget.quizList.map((e) => 0).toList();

  late List<bool> selectedAnswers =
      currentQuestion.answers.map((e) => false).toList();

  late List<GlobalKey> scrollKeys =
      widget.quizList.map((e) => GlobalKey()).toList();

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void exit() {
    Navigator.pop(context);
  }

  void setShowReview() {
    setState(() {
      showReview = !showReview;
    });
  }

  void swap(int id) {
    setState(() {
      selectedAnswers[id] = !selectedAnswers[id];
    });
  }

  void resetSelected() {
    selectedAnswers = currentQuestion.answers
        .map(
          (e) => false,
        )
        .toList();
  }

  void nextQuestion() {
    setShowReview();
    scrollController.position.ensureVisible(
      scrollKeys[questionIndex].currentContext!.findRenderObject()!,
      alignment:
          0.5, // How far into view the item should be scrolled (between 0 and 1).
      duration: const Duration(seconds: 1),
    );
    setState(() {
      answeredIncorrectly = false;
      if (questionIndex + 1 < widget.quizList.length) {
        resetSelected();
        questionIndex++;
        currentQuestion = widget.quizList[questionIndex];
      } else {
        exit();
      }
    });
  }

  void validate() {
    if (answeredIncorrectly) {
      setShowReview();
      return;
    }
    if (!currentQuestion.isSelectedCorrect(selectedAnswers)) {
      setState(() {
        answeredIncorrectly = true;
        statusHistory[questionIndex] = -1;
        wrongAnswers++;
      });
      return;
    }
    setState(() {
      correctAnswers++;
      statusHistory[questionIndex] = 1;
    });
    setShowReview();
  }

  int getStatus(int key, bool currentSelected) {
    if (answeredIncorrectly) {
      if (currentQuestion.correctAnswer == 7) {
        return -1;
      }
      if (currentQuestion.correctAnswer == 6 && (key == 1 || key == 2)) {
        return -1;
      }
      if (currentQuestion.correctAnswer == 5 && (key == 0 || key == 2)) {
        return -1;
      }
      if (currentQuestion.correctAnswer == 4 && (key == 0 || key == 1)) {
        return -1;
      }
      return key == currentQuestion.correctAnswer - 1 ? -1 : 0;
    }
    return currentSelected ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      QuizHeading(
                          questionNumber: questionIndex + 1,
                          quizLength: widget.quizList.length,
                          correctAnswers: correctAnswers,
                          wrongAnswers: wrongAnswers,
                          statusHistory: statusHistory,
                          scrollController: scrollController,
                          scrollKeys: scrollKeys),
                      //the actual question starts
                      showReview
                          ? Review(
                              nextQuestion: nextQuestion,
                              currentQuestion: currentQuestion,
                            )
                          : QuestionBody(
                              currentQuestion: currentQuestion,
                              selectedAnswers: selectedAnswers,
                              getStatus: getStatus,
                              swap: swap)
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => {exit()},
                      child: Text("Iesire"),
                    ),
                    SizedBox(
                      width: !showReview ? 30 : 0,
                    ),
                    showReview
                        ? SizedBox.shrink()
                        : ElevatedButton(
                            onPressed: () => {
                                  validate()
                                  //check if the answer is correct
                                },
                            child: answeredIncorrectly
                                ? Text("Evalueaza")
                                : Text("Raspunde"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton:
      //     FloatingActionButton(onPressed: () => {DatabaseHelper().test()}),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
