import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:geode/models/task.dart';
import 'package:geode/providers/task_manager.dart';
import 'package:geode/screens/dashboard/widgets/task_card.dart'; // Add this import
import 'package:provider/provider.dart';

class TaskHorizonScreen extends StatelessWidget {
  const TaskHorizonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Task Horizon', style: AppTextStyles.subheading),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.secondaryAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<TaskManager>(
        builder: (context, taskManager, child) {
          // Create a mutable copy of the tasks list for sorting
          final tasks = List<Task>.from(taskManager.tasks);

          // Sort tasks by deadline
          tasks
              .sort((taskA, taskB) => taskA.deadline.compareTo(taskB.deadline));

          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                'You have no tasks yet. Add one!',
                style: AppTextStyles.body_grey,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(task: task);
            },
          );
        },
      ),
    );
  }
}
