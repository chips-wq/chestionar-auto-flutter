import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:chestionar_auto/ui/widgets/tutorial/tutorial1.dart';
import 'package:chestionar_auto/ui/widgets/tutorial/tutorial2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: [
                Tutorial1(),
                Tutorial2(),
                Container(color: Colors.yellow)
              ],
            ),
            Align(
              alignment: Alignment(0, 0.85),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: SlideEffect(
                    activeDotColor: AppColors.white,
                    dotColor: AppColors.bgShade1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
