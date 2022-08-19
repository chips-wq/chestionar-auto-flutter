import 'package:flutter/material.dart';
import 'package:chestionar_auto/utils/app_colors.dart';

class ProgressBar extends StatelessWidget {
  final List<int> statusHistory;
  final List<GlobalKey> scrollKeys;
  final ScrollController scrollController;

  const ProgressBar(
      {Key? key,
      required this.statusHistory,
      required this.scrollController,
      required this.scrollKeys})
      : super(key: key);

  Color getColor(int index) {
    int status = statusHistory[index];
    if (status == -1) {
      return Colors.red;
    }
    if (status == 0) {
      return AppColors.bgShade1;
    }
    return AppColors.teal3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 20,
        child: ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.symmetric(vertical: 8),
          scrollDirection: Axis.horizontal,
          itemCount: statusHistory.length,
          itemBuilder: (context, i) {
            return Container(
                key: scrollKeys[i],
                margin: EdgeInsets.symmetric(horizontal: 2),
                width: 15,
                color: getColor(i));
          },
        ));
  }
}
