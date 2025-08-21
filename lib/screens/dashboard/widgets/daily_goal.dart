import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DailyGoal extends StatelessWidget {
  const DailyGoal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Daily Goal", style: AppTextStyles.subheading),
                const SizedBox(height: 10),
                Text("3/5 tasks",
                    style: AppTextStyles.body
                        .copyWith(color: AppColors.highlight)),
                const SizedBox(height: 5),
                const Text("You marked 3/5 tasks",
                    style: AppTextStyles.body_grey),
              ],
            ),
            CircularPercentIndicator(
              radius: 45.0,
              lineWidth: 8.0,
              percent: 0.60, // This is 3/5
              center: const Text(
                "60%",
                style: AppTextStyles.body,
              ),
              progressColor: AppColors.highlight,
              backgroundColor: Colors.white24,
              circularStrokeCap: CircularStrokeCap.round,
            )
          ],
        ));
  }
}
