import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chestionar_auto/database_helper.dart';
import 'package:chestionar_auto/models.dart/question_model.dart';
import 'package:chestionar_auto/screens/homepage.dart';
import 'package:chestionar_auto/screens/quiz.dart';
import 'package:chestionar_auto/utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(),
        scaffoldBackgroundColor: AppColors.bgColor,
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1, color: Colors.blue),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class QuizWrapper extends StatelessWidget {
  const QuizWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper().getQuestions(26),
      builder: (BuildContext context, AsyncSnapshot<List<Question>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Loading ...",
                style: TextStyle(fontSize: 24, color: AppColors.white),
              ),
            ),
          );
        }
        return Quiz(quizList: snapshot.data ?? []);
      },
    );
  }
}
