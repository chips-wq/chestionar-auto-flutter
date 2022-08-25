import 'package:chestionar_auto/core/provider/subcategory_provider.dart';
import 'package:chestionar_auto/ui/router.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
                      Navigator.pushNamed(context, '/quiz',
                              arguments: QuizPageData(
                                  true,
                                  subcategoryProvider.drivingCategory,
                                  subcategoryProvider.subcategory))
                          .then((value) =>
                              subcategoryProvider.getSubcategoryStats())
                    },
                child: Text("Practica"))
          ]),
        ),
      ),
    );
  }
}
