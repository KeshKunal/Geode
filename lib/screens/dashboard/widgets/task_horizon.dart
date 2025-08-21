import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:geode/models/task.dart';
import 'package:geode/providers/task_manager.dart';
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
          final tasks = taskManager.tasks;

          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                'You have no tasks yet. Add one!',
                style: AppTextStyles.body_grey,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.darkGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(task.name, style: AppTextStyles.body),
                  subtitle: Text(
                    'Deadline: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                    style: AppTextStyles.body_grey,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (task.isPriority)
                        const Icon(Icons.star, color: Colors.amber),
                      PopupMenuButton<TaskStatus>(
                        icon: const Icon(Icons.more_vert,
                            color: AppColors.secondaryAccent),
                        onSelected: (TaskStatus result) {
                          context
                              .read<TaskManager>()
                              .updateTaskStatus(task.id, result);
                        },
                        itemBuilder: (BuildContext context) => TaskStatus.values
                            .map((status) => PopupMenuItem<TaskStatus>(
                                  value: status,
                                  child:
                                      Text(status.toString().split('.').last),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
