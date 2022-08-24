import 'dart:math';

import 'package:chestionar_auto/core/models/subcategory_model.dart';
import 'package:chestionar_auto/core/provider/enums.dart';
import 'package:chestionar_auto/core/provider/question_stats_provider.dart';
import 'package:chestionar_auto/core/provider/subcategory_provider.dart';
import 'package:chestionar_auto/core/services/database_helper.dart';
import 'package:chestionar_auto/ui/screens/quiz.dart';
import 'package:chestionar_auto/ui/screens/setari.dart';
import 'package:chestionar_auto/ui/screens/subcategory.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:chestionar_auto/ui/widgets/question_information_widget.dart';
import 'package:chestionar_auto/ui/widgets/question_stats_widget.dart';
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
      create: (_) => GeneralQuestionStatsProvider(DrivingCategory.B),
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
        Provider.of<GeneralQuestionStatsProvider>(context, listen: false)
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
                Consumer<GeneralQuestionStatsProvider>(
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
                              subcategory:
                                  null, //no subcategory meaning it is general(takes all questions)
                            ),
                          ),
                        ).then((value) =>
                            Provider.of<GeneralQuestionStatsProvider>(context,
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
              Consumer<GeneralQuestionStatsProvider>(
                  builder: (context, questionStats, child) {
                return QuestionStatsWidget(
                    isLoading: questionStats.isLoading,
                    stats: questionStats.stats);
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
              Text(
                "Categorii",
                style: TextStyle(fontSize: 28, color: AppColors.white),
              ),
              Consumer<GeneralQuestionStatsProvider>(
                  builder: ((context, questionStats, child) {
                if (questionStats.isLoading) {
                  return Text(
                    "Se incarca...",
                    style: TextStyle(color: AppColors.white, fontSize: 24),
                  );
                }
                final subcategories = questionStats.subcategories!;
                return Container(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: subcategories.length,
                    itemBuilder: (context, i) => Container(
                      width: 110,
                      margin: EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (_) => SubcategoryProvider(
                                    drivingCategory, subcategories[i]),
                                lazy: false,
                                child: SubcategoryScreen(),
                              ),
                            ),
                          )
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.bgShade2,
                        ),
                        child: Text(
                          subcategories[i].name,
                          style:
                              TextStyle(fontSize: 14, color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                );
              }))
            ],
          ),
        )
      ],
    );
  }
}
