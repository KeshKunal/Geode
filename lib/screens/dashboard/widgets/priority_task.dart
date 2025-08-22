import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:geode/models/task.dart';
import 'package:geode/providers/task_manager.dart';
import 'package:provider/provider.dart';

class PriorityTask extends StatelessWidget {
  const PriorityTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskManager>(
      builder: (context, taskManager, child) {
        // Calculate progress from live data
        final priorityTasks =
            taskManager.tasks.where((task) => task.isPriority).toList();
        final completedPriorityTasks = priorityTasks
            .where((task) => task.status == TaskStatus.completed)
            .toList();

        // Calculate progress percentage
        double progress = 0.0;
        if (priorityTasks.isNotEmpty) {
          progress = completedPriorityTasks.length / priorityTasks.length;
        }

        final percentage = (progress * 100).toStringAsFixed(0);

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
              Text(
                "${completedPriorityTasks.length}/${priorityTasks.length} is completed",
                style: AppTextStyles.body_grey,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.highlight),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "$percentage%",
                    style:
                        AppTextStyles.body.copyWith(color: AppColors.highlight, fontSize: 40),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
