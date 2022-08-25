import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:chestionar_auto/ui/shared/no_glow_behaviour.dart';
import 'package:chestionar_auto/ui/widgets/quiz/review_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Tutorial1 extends StatelessWidget {
  const Tutorial1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 100),
      child: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: ListView(
          children: const [
            Text("Cum funcționează ?",
                style: TextStyle(fontSize: 32, color: AppColors.white)),
            SizedBox(
              height: 12,
            ),
            Text(
                "Vei fi prezentat cu întrebări din setul întrebărilor oficiale DRPCIV, iar dupa răspuns vei evalua dificultatea întrebării cu ajutorul formularului de mai jos.",
                style: TextStyle(fontSize: 16, color: AppColors.white)),
            SizedBox(
              height: 15,
            ),
            ReviewSmallPreviewRow(
                text: "nu am știut să răspund deloc", quality: 0),
            SizedBox(
              height: 10,
            ),
            ReviewSmallPreviewRow(
                text: "am răspuns parțial, îmi aduc aminte putin", quality: 1),
            SizedBox(
              height: 10,
            ),
            ReviewSmallPreviewRow(
                text: "am răspuns corect cu greu sau am răspuns parțial",
                quality: 2),
            SizedBox(
              height: 10,
            ),
            ReviewSmallPreviewRow(
                text: "am știut răspunsul după puțin timp de găndire",
                quality: 3),
            SizedBox(
              height: 10,
            ),
            ReviewSmallPreviewRow(
                text: "am știut răspunsul aproape imediat", quality: 4),
            SizedBox(
              height: 10,
            ),
            ReviewSmallPreviewRow(
                text: "am știut răspunsul și a fost foarte ușor", quality: 5),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewSmallPreviewRow extends StatelessWidget {
  final String text;
  final int quality;
  const ReviewSmallPreviewRow(
      {required this.text, required this.quality, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ReviewSmallPreview(quality: quality),
        Icon(
          Icons.arrow_back,
          size: 24,
          color: AppColors.white,
        ),
        SizedBox(
          width: 8,
        ),
        Flexible(child: Text(text, style: TextStyle(color: AppColors.white)))
      ],
    );
  }
}

class ReviewSmallPreview extends StatelessWidget {
  final int quality;
  const ReviewSmallPreview({required this.quality, Key? key}) : super(key: key);
  //TODO somehow use something from the review body because it is the same thing
  Color getColor(int quality) {
    if (quality == 0) {
      return Colors.white10;
    }
    if (quality == 1) {
      return Colors.white24;
    }
    if (quality == 2) {
      return Color.fromARGB(255, 8, 80, 62);
    }
    if (quality == 3) {
      return Color.fromARGB(255, 10, 129, 99);
    }
    if (quality == 4) {
      return Color.fromARGB(255, 14, 173, 134);
    }
    return AppColors.teal3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        onPressed: () => {},
        style: ElevatedButton.styleFrom(
          primary: getColor(quality),
          fixedSize: Size(70, 70),
        ),
        child: Text(
          "${quality + 1}",
          style: TextStyle(fontSize: 42),
        ),
      ),
    );
  }
}
