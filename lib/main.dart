import 'package:chestionar_auto/core/services/settings_service.dart';
import 'package:chestionar_auto/ui/router.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

String getInitialRoute(SettingsService settingsProvider) {
  return settingsProvider.isFirstLaunch! ? "tutorial" : "main";
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SettingsService settingsProvider = SettingsService();
  await settingsProvider.getPreferences();
  runApp(
    Provider<SettingsService>.value(
      value: settingsProvider,
      child: ChestionareApp(
        initialRoute: getInitialRoute(settingsProvider),
      ),
    ),
  );
}

class ChestionareApp extends StatelessWidget {
  final String initialRoute;
  const ChestionareApp({required this.initialRoute, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        snackBarTheme: const SnackBarThemeData(
            backgroundColor: AppColors.white,
            contentTextStyle:
                TextStyle(color: AppColors.bgShade2, fontSize: 15),
            behavior: SnackBarBehavior.floating),
        appBarTheme: const AppBarTheme(
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
      initialRoute: initialRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
