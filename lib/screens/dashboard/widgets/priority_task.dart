import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';

class PriorityTask extends StatelessWidget {
  const PriorityTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Priority Task Progress",
            style: AppTextStyles.subheading,
          ),
          const SizedBox(height: 10),
          const Text(
            "3/5 is completed",
            style: AppTextStyles.body_grey,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: LinearProgressIndicator(
                  value: 0.6, // 3/5
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.highlight),
                  minHeight: 10,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "68.99%",
                style: AppTextStyles.body.copyWith(color: AppColors.highlight),
              ),
            ],
          ),
        ],
      ),
    );
  }
}