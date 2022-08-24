import 'package:chestionar_auto/core/models/subcategory_model.dart';
import 'package:chestionar_auto/core/provider/enums.dart';
import 'package:chestionar_auto/core/provider/subcategory_provider.dart';
import 'package:chestionar_auto/ui/screens/homepage.dart';
import 'package:chestionar_auto/ui/screens/quiz.dart';
import 'package:chestionar_auto/ui/screens/subcategory.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubcategoryPageData {
  final DrivingCategory drivingCategory;
  final Subcategory subcategory;

  SubcategoryPageData(this.drivingCategory, this.subcategory);
}

class QuizPageData {
  final bool isPractice;
  final DrivingCategory drivingCategory;
  final Subcategory? subcategory;

  QuizPageData(this.isPractice, this.drivingCategory, this.subcategory);
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainPage());
      // case 'login':
      //   return MaterialPageRoute(builder: (_) => LoginView());
      // case 'post':
      //   var post = settings.arguments as Post;
      //   return MaterialPageRoute(builder: (_) => PostView(post: post));
      case '/quiz':
        var quizPageData = settings.arguments as QuizPageData;
        return MaterialPageRoute(
          builder: (context) => QuizWrapper(
            isPractice: quizPageData.isPractice,
            drivingCategory: quizPageData.drivingCategory,
            subcategory: quizPageData
                .subcategory, //no subcategory meaning it is general(takes all questions)
          ),
        );
      case '/subcategory':
        var subcategoryPageData = settings.arguments as SubcategoryPageData;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => SubcategoryProvider(
                subcategoryPageData.drivingCategory,
                subcategoryPageData.subcategory),
            lazy: false,
            child: SubcategoryScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}',
                        style: TextStyle(fontSize: 24, color: AppColors.white)),
                  ),
                ));
    }
  }
}
