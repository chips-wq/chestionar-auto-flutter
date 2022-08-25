import 'package:chestionar_auto/core/services/settings_service.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tutorial3 extends StatelessWidget {
  const Tutorial3({Key? key}) : super(key: key);

  void goToMainScreen(BuildContext context) {
    var settingsProvider = Provider.of<SettingsService>(context, listen: false);

    settingsProvider.setFirstLaunch(false);
    Navigator.pushReplacementNamed(context, 'main');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Să începem",
          style: TextStyle(fontSize: 32, color: AppColors.white),
        ),
        OutlinedButton.icon(
            icon: const Icon(Icons.start),
            onPressed: () => goToMainScreen(context),
            label: const Text("Începe"))
      ],
    ));
  }
}
