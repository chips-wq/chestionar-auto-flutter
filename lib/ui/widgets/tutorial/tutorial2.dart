import 'package:chestionar_auto/core/models/questions_stats.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:chestionar_auto/ui/shared/no_glow_behaviour.dart';
import 'package:chestionar_auto/ui/widgets/question_stats_widget.dart';
import 'package:flutter/cupertino.dart';

class Tutorial2 extends StatelessWidget {
  const Tutorial2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(18, 10, 18, 100),
      child: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: ListView(
          children: const [
            Text("Ce reprezintă datele ?",
                style: TextStyle(fontSize: 32, color: AppColors.white)),
            SizedBox(
              height: 12,
            ),
            DataExplanationWidget()
          ],
        ),
      ),
    );
  }
}

class DataExplanationWidget extends StatelessWidget {
  const DataExplanationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dummyQuestionStats = QuestionsStats(
        totalQuestions: 322,
        neverSeenQuestions: 34,
        learningQuestions: 12,
        reviewQuestions: 49,
        toLearnNowQuestions: 12,
        toReviewNowQuestions: 49);
    return Column(children: [
      const Text(
          "Odată ce ai evaluat dificultatea unei întrebări, aplicația calculează cănd trebuie reamintită astfel încât să rămână în memoria ta pe termen lung.",
          style: TextStyle(fontSize: 16, color: AppColors.white)),
      const SizedBox(
        height: 15,
      ),
      QuestionStatsWidget(isLoading: false, stats: dummyQuestionStats),
      const SizedBox(
        height: 15,
      ),
      const CategoryExplanation(
          firstText: "Categoria",
          categoryText: " Revizuire ",
          explanationText:
              "reprezintă câte întrebări ai de revizuit în acest moment (acestea sunt reamintite la intervale mai lungi de timp cu ajutorul algoritmilor construiți pentru memorare).",
          categoryColor: AppColors.teal3),
      const SizedBox(
        height: 20,
      ),
      const CategoryExplanation(
          firstText: "Categoria",
          categoryText: " Învățare ",
          explanationText:
              "reprezintă câte întrebări ai de învățat în acest moment (acestea sunt reamintite mult mai rapid).",
          categoryColor: AppColors.orange),
      const SizedBox(
        height: 20,
      ),
      const CategoryExplanation(
          firstText: "Categoria",
          categoryText: " Nevăzute ",
          explanationText:
              "reprezintă câte întrebări nu ai văzut încă în secțiunea Practică.",
          categoryColor: AppColors.lightBlue)
    ]);
  }
}

class CategoryExplanation extends StatelessWidget {
  final String firstText;
  final String categoryText;
  final String explanationText;
  final Color categoryColor;

  const CategoryExplanation(
      {required this.firstText,
      required this.categoryText,
      required this.explanationText,
      required this.categoryColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: firstText,
            style: const TextStyle(fontSize: 16, color: AppColors.white),
          ),
          TextSpan(
              text: categoryText,
              style: TextStyle(
                fontSize: 18,
                color: categoryColor,
              )),
          TextSpan(
            text: explanationText,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.white,
            ),
          )
        ],
      ),
    );
  }
}
