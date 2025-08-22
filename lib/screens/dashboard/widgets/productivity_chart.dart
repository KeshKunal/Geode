import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';

class ProductivityChart extends StatelessWidget {
  const ProductivityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.engineering_rounded,
            size: 48,
            color: AppColors.highlight,
          ),
          const SizedBox(height: 16),
          Text(
            "Time Machine Under Construction!",
            style: AppTextStyles.subheading.copyWith(
              color: AppColors.highlight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Our productivity stats are currently training with Doctor Strange. "
            "They'll be back once they master the Time Stone!",
            textAlign: TextAlign.center,
            style: AppTextStyles.body_grey.copyWith(
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.highlight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.upcoming_rounded,
                  size: 16,
                  color: AppColors.highlight,
                ),
                SizedBox(width: 8),
                Text(
                  "Coming Soon",
                  style: TextStyle(
                    color: AppColors.highlight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* Original chart code preserved for future reference
   Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Completed in the Last 7 Days", style: AppTextStyles.body),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barTouchData: BarTouchData(enabled: false),
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: _chartGroups(),
              ),
            ),
          ),
           const SizedBox(height: 10),
           const Row(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text("108 Tasks", style: AppTextStyles.body_grey),
               SizedBox(width: 20),
               Text("6 Projects", style: AppTextStyles.body_grey),
             ],
           )
        ],
      ),
    );
  }

  List<BarChartGroupData> _chartGroups() {
    // Dummy data for the last 7 days
    final List<double> dailyData = [5, 8, 12, 6, 15, 7, 18];
    return List.generate(dailyData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: dailyData[index],
            color: AppColors.highlight,
            width: 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    });
  }
}.
*/
