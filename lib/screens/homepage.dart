import 'package:flutter/material.dart';
import 'package:chestionar_auto/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuizWrapper(),
                ),
              ),
            },
            child: Text("Genereaza Chestionar"),
          ),
        ),
      ),
    );
  }
}
