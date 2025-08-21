import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';

class TaskSummaryCard extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const TaskSummaryCard({
    required this.count,
    required this.label,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.27,
      height: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 20, // Fixed height for text container
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: Colors.grey[400],
                fontSize: 13,
              ),
              maxLines: 1, // Ensure single line
              overflow: TextOverflow.ellipsis, // Handle long text
            ),
          ),
          // const SizedBox(height: 8),
          // LinearProgressIndicator(
          //   value: double.parse(count) / 100,
          //   backgroundColor: color.withOpacity(0.2),
          //   valueColor: AlwaysStoppedAnimation<Color>(color),
          //   borderRadius: BorderRadius.circular(4),
          // ),
        ],
      ),
    );
  }
}
