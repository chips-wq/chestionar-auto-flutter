import 'package:chestionar_auto/core/provider/question_stats_provider.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chestionar_auto/ui/screens/homepage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ChestionareApp());
}

class ChestionareApp extends StatelessWidget {
  const ChestionareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: AppColors.bgShade2,
        ),
        textTheme: GoogleFonts.nunitoSansTextTheme(),
        scaffoldBackgroundColor: AppColors.bgColor,
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 1, color: Colors.blue),
          ),
        ),
      ),
      home: ChangeNotifierProvider(
        create: (_) => QuestionStatsProvider(),
        child: const HomePage(),
      ),
    );
  }
}
