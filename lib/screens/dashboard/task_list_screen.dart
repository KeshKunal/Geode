import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:geode/models/task.dart';
import 'package:geode/providers/task_manager.dart';
import 'package:geode/screens/dashboard/widgets/task_card.dart';
import 'package:provider/provider.dart'; // Add this import

class TaskListScreen extends StatelessWidget {
  final String title;
  final List<Task> tasks; // We'll keep this for initial data

  const TaskListScreen({
    super.key,
    required this.title,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title, style: AppTextStyles.subheading),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.secondaryAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<TaskManager>(
        builder: (context, taskManager, child) {
          // Filter tasks based on the initial tasks' status
          final TaskStatus targetStatus =
              tasks.isNotEmpty ? tasks.first.status : TaskStatus.toDo;
          final currentTasks = taskManager.tasks
              .where((task) => task.status == targetStatus)
              .toList();

          return currentTasks.isEmpty
              ? Center(
                  child: Text(
                    'No tasks in this category yet.',
                    style: AppTextStyles.body_grey,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: currentTasks.length,
                  itemBuilder: (context, index) {
                    final task = currentTasks[index];
                    return TaskCard(task: task);
                  },
                );
        },
      ),
    );
  }
}
