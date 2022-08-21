import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:chestionar_auto/core/provider/quiz_provider.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:chestionar_auto/core/models/question_model.dart';
import 'package:chestionar_auto/ui/widgets/question_body.dart';
import 'package:chestionar_auto/ui/widgets/quiz_heading.dart';
import 'package:chestionar_auto/ui/widgets/review_body.dart';
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

class ExplanationWidget extends StatelessWidget {
  const ExplanationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? explanation = Provider.of<QuestionProvider>(context, listen: false)
        .question
        .explanation;
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.bgShade1),
          height: 8,
          width: 50,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Explicatie",
                style: TextStyle(fontSize: 30, color: AppColors.white),
              ),
              Text(explanation == null || true ? "No explanation" : explanation,
                  style: TextStyle(color: AppColors.white, fontSize: 16)),
            ],
          ),
        ),
      ],
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
