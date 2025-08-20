import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';

class TaskSummaryCard extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const TaskSummaryCard({
    super.key,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: AppTextStyles.subheading.copyWith(color: color),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: AppTextStyles.body_grey,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}