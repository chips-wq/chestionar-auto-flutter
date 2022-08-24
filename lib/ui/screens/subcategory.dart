import 'package:chestionar_auto/core/models/questions_stats.dart';
import 'package:chestionar_auto/core/models/subcategory_model.dart';
import 'package:chestionar_auto/core/provider/subcategory_provider.dart';
import 'package:chestionar_auto/ui/screens/quiz.dart';
import 'package:chestionar_auto/ui/widgets/question_stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubcategoryScreen extends StatelessWidget {
  const SubcategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var subcategoryProvider = Provider.of<SubcategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(subcategoryProvider.subcategory.name)),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Consumer<SubcategoryProvider>(
              builder: (context, subcategoryProvider, child) {
            var questionStats = subcategoryProvider.subcategory;
            var isLoading = subcategoryProvider.isLoadingStats;

            return QuestionStatsWidget(
                isLoading: isLoading, stats: questionStats.stats);
          }),
          ElevatedButton(
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizWrapper(
                          isPractice: true,
                          drivingCategory: subcategoryProvider.drivingCategory,
                          subcategory: subcategoryProvider
                              .subcategory, //no subcategory meaning it is general(takes all questions)
                        ),
                      ),
                    ).then((value) => subcategoryProvider.getSubcategoryStats())
                  },
              child: Text("Practica"))
        ]),
      ),
    );
  }
}
