import 'dart:math';

import 'package:chestionar_auto/core/provider/enums.dart';
import 'package:chestionar_auto/core/provider/question_stats_provider.dart';
import 'package:chestionar_auto/core/services/database_helper.dart';
import 'package:chestionar_auto/ui/screens/quiz.dart';
import 'package:chestionar_auto/ui/screens/setari.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<PreferredSizeWidget?> AppBars = [
    AppBar(title: Text('Acasa')),
    AppBar(title: Text("Setari"))
  ];

  final List<Widget> Screens = [HomePage(), SetariPage()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuestionStatsProvider(DrivingCategory.B),
      child: Scaffold(
        appBar: AppBars[currentIndex],
        body: Screens[currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: BottomNavigationBar(
              currentIndex: currentIndex,
              backgroundColor: AppColors.bgColor,
              iconSize: 24,
              selectedFontSize: 13,
              unselectedFontSize: 13,
              selectedItemColor: AppColors.white,
              unselectedItemColor: AppColors.bgShade1,
              onTap: (newIndex) => setState(() {
                    currentIndex = newIndex;
                  }),
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Acasa'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Setari'),
              ]),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DrivingCategory drivingCategory =
        Provider.of<QuestionStatsProvider>(context, listen: false)
            .drivingCategory;
    return Column(
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
              // Text(
              //   "Statistici",
              //   style: TextStyle(fontSize: 36, color: AppColors.white),
              // ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Consumer<QuestionStatsProvider>(
                    builder: (context, questionStats, child) {
                  if (questionStats.isLoading) {
                    return Container(
                      height: 225,
                      width: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return PieChart(
                    chartType: ChartType.ring,
                    dataMap: {
                      "Revizuire":
                          questionStats.stats!.toReviewNowQuestions.toDouble(),
                      "Nevazute":
                          questionStats.stats!.neverSeenQuestions.toDouble(),
                      "Learning":
                          questionStats.stats!.toLearnNowQuestions.toDouble(),
                    },
                    chartRadius:
                        min(400, MediaQuery.of(context).size.width / 2),
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
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuizWrapper(
                                      drivingCategory: drivingCategory,
                                    ))).then((value) =>
                            Provider.of<QuestionStatsProvider>(context,
                                    listen: false)
                                .fetchQuestionStats())
                      },
                      child: Text("Practica"),
                    ),
                    ElevatedButton(
                      onPressed: () => {},
                      child: Text("Simulare"),
                    ),
                  ],
                )
              ]),
              SizedBox(
                height: 20,
              ),
              Consumer<QuestionStatsProvider>(
                  builder: (context, questionStats, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QuestionInformationBox(
                        categoryName: "De revizuit",
                        loading: questionStats.isLoading,
                        amountQuestions:
                            questionStats.stats?.toReviewNowQuestions,
                        borderColor: AppColors.teal3,
                        bottomText: "Ramase"),
                    SizedBox(
                      width: 6,
                    ),
                    QuestionInformationBox(
                        categoryName: "De invatat",
                        loading: questionStats.isLoading,
                        amountQuestions:
                            questionStats.stats?.toLearnNowQuestions,
                        borderColor: AppColors.orange,
                        bottomText: "Ramase"),
                    SizedBox(
                      width: 6,
                    ),
                    QuestionInformationBox(
                        categoryName: "Nevazute",
                        loading: questionStats.isLoading,
                        amountQuestions:
                            questionStats.stats?.neverSeenQuestions,
                        borderColor: AppColors.lightBlue,
                        bottomText: "Ramase"),
                  ],
                );
              }),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Ce reprezinta aceste date?",
                      style: TextStyle(fontSize: 16, color: AppColors.white),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Categorii",
                  style: TextStyle(fontSize: 28, color: AppColors.white))
            ],
          ),
        )
      ],
    );
  }
}

class QuestionInformationBox extends StatelessWidget {
  final String categoryName;
  final bool loading;
  final int? amountQuestions;
  final String bottomText;
  final Color borderColor;

  const QuestionInformationBox(
      {required this.categoryName,
      required this.loading,
      required this.amountQuestions,
      required this.bottomText,
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
                "$bottomText",
                style: TextStyle(fontSize: 16, color: AppColors.bgShade1),
              ),
      ]),
    );
  }
}
