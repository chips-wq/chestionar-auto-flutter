import 'package:chestionar_auto/core/provider/question_stats_provider.dart';
import 'package:chestionar_auto/core/services/database_helper.dart';
import 'package:chestionar_auto/ui/screens/quiz.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acasa"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Statistici",
                  style: TextStyle(fontSize: 36, color: AppColors.white),
                ),
                Consumer<QuestionStatsProvider>(
                    builder: (context, questionStats, child) {
                  if (questionStats.stats == null) {
                    return Container(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return PieChart(
                    dataMap: {
                      "Revizuire":
                          questionStats.stats!.reviewQuestions.toDouble(),
                      "Nevazute":
                          questionStats.stats!.neverSeenQuestions.toDouble(),
                      "Learning":
                          questionStats.stats!.learningQuestions.toDouble(),
                    },
                    chartRadius: MediaQuery.of(context).size.width / 1.7,
                    centerText: "Intrebari",
                    colorList: [
                      AppColors.teal3,
                      AppColors.lightBlue,
                      AppColors.orange
                    ],
                    legendOptions: LegendOptions(showLegends: false),
                    chartValuesOptions:
                        ChartValuesOptions(showChartValues: false),
                  );
                }),
                Consumer<QuestionStatsProvider>(
                    builder: (context, questionStats, child) {
                  return Row(
                    children: [
                      QuestionInformationBox(
                          categoryName: "Nevazute",
                          loading: questionStats.stats == null ? true : false,
                          amountQuestions:
                              questionStats.stats?.neverSeenQuestions,
                          borderColor: AppColors.lightBlue,
                          percentOfTotal:
                              questionStats.stats?.neverSeenPercent),
                      SizedBox(
                        width: 6,
                      ),
                      QuestionInformationBox(
                          categoryName: "De invatat",
                          loading: questionStats.stats == null ? true : false,
                          amountQuestions:
                              questionStats.stats?.learningQuestions,
                          borderColor: AppColors.orange,
                          percentOfTotal: questionStats.stats?.learningPercent),
                      SizedBox(
                        width: 6,
                      ),
                      QuestionInformationBox(
                          categoryName: "Revizuire",
                          loading: questionStats.stats == null ? true : false,
                          amountQuestions: questionStats.stats?.reviewQuestions,
                          borderColor: AppColors.teal3,
                          percentOfTotal: questionStats.stats?.reviewPercent),
                    ],
                  );
                }),
                ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizWrapper(),
                      ),
                    ).then((value) => Provider.of<QuestionStatsProvider>(
                            context,
                            listen: false)
                        .fetchQuestionStats())
                  },
                  child: Text("Genereaza Chestionar"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class QuestionInformationBox extends StatelessWidget {
  final String categoryName;
  final bool loading;
  final int? amountQuestions;
  final int? percentOfTotal;
  final Color borderColor;

  const QuestionInformationBox(
      {required this.categoryName,
      required this.loading,
      required this.amountQuestions,
      required this.percentOfTotal,
      required this.borderColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          categoryName,
          style: TextStyle(fontSize: 16, color: AppColors.white),
        ),
        loading
            ? Container(height: 12, width: 60, color: AppColors.bgShade1)
            : Text(
                "$amountQuestions",
                style: TextStyle(fontSize: 16, color: AppColors.white),
              ),
        SizedBox(
          height: loading ? 5 : 0,
        ),
        loading
            ? Container(height: 12, width: 50, color: AppColors.bgShade1)
            : Text(
                "$percentOfTotal%",
                style: TextStyle(fontSize: 16, color: AppColors.bgShade1),
              ),
      ]),
    );
  }
}
