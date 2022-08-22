import 'package:chestionar_auto/core/provider/question_provider.dart';
import 'package:chestionar_auto/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplanationWidget extends StatelessWidget {
  const ExplanationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? explanation = Provider.of<QuestionProvider>(context, listen: false)
        .question
        .explanation;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.bgShade1),
          height: 8,
          width: 50,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Explicatie",
                style: TextStyle(fontSize: 30, color: AppColors.white),
              ),
              Text(explanation ?? "No explanation",
                  style: const TextStyle(color: AppColors.white, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
