import 'package:fl_chart/fl_chart.dart';
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
}