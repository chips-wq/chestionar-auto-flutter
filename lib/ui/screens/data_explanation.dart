import 'package:chestionar_auto/ui/shared/no_glow_behaviour.dart';
import 'package:chestionar_auto/ui/widgets/tutorial/tutorial2.dart';
import 'package:flutter/material.dart';

class DataExplanationScreen extends StatelessWidget {
  const DataExplanationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ce reprezintă datele ?")),
      body: Container(
          padding: EdgeInsets.all(18),
          child: ScrollConfiguration(
              behavior: NoGlowBehavior(),
              child: ListView(children: [DataExplanationWidget()]))),
    );
  }
}
