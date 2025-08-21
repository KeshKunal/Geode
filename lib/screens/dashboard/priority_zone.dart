import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:geode/providers/task_manager.dart';
import 'package:geode/screens/main_screen.dart';
import 'package:geode/screens/timer.dart';
import 'package:provider/provider.dart';

class PriorityZone extends StatelessWidget {
  const PriorityZone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Priority Zone", style: AppTextStyles.subheading),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.secondaryAccent),
        ),
      ),
      body: Consumer<TaskManager>(
        builder: (context, taskManager, child) {
          final priorityTasks =
              taskManager.tasks.where((task) => task.isPriority).toList();

          if (priorityTasks.isEmpty) {
            return const Center(
              child: Text(
                'No priority tasks set yet.',
                style: AppTextStyles.body_grey,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: priorityTasks.length,
            itemBuilder: (context, index) {
              final task = priorityTasks[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.darkGrey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.highlight.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    task.name,
                    style: AppTextStyles.body,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Due: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                        style: AppTextStyles.body_grey,
                      ),
                    ],
                  ),
                  // trailing: ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pop(
                  //         context); // First pop the PriorityZone screen
                  //     // Find the MainScreen state and update the index
                  //     if (context.mounted) {
                  //       final mainScreenState =
                  //           context.findAncestorStateOfType<MainScreenState>();
                  //       if (mainScreenState != null) {
                  //         mainScreenState.onItemTapped(1);
                  //       }
                  //     }
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: AppColors.highlight,
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 8,
                  //     ),
                  //   ),
                  //   child: const Text(
                  //     "Begin Focus",
                  //     style: TextStyle(
                  //       color: AppColors.primaryBackground,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
