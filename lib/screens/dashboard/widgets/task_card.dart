import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:geode/models/task.dart';
import 'package:geode/providers/task_manager.dart';
import 'package:geode/screens/dashboard/widgets/add_task.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({
    super.key,
    required this.task,
  });

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.toDo:
        return Colors.orange.shade300;
      case TaskStatus.inProgress:
        return Colors.lightBlue.shade300;
      case TaskStatus.completed:
        return AppColors.primaryAccent;
    }
  }

  String _getSuccessMessage(TaskStatus oldStatus, TaskStatus newStatus) {
    if (newStatus == TaskStatus.inProgress) {
      return "Let's get started!";
    } else if (newStatus == TaskStatus.completed) {
      return "Well done! Task completed";
    }
    return "Task moved back to ${_getStatusLabel(newStatus)} 📝";
  }

  String _getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.toDo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    String _formatDate(DateTime date) {
      return '${date.day}/${date.month}/${date.year}';
    }

    String _getStatusText() {
      final now = DateTime.now();
      final daysLeft = task.deadline.difference(now).inDays;

      if (task.status == TaskStatus.completed) {
        final completedDaysEarly =
            task.deadline.difference(DateTime.now()).inDays;
        return 'Completed ${completedDaysEarly > 0 ? "$completedDaysEarly days early" : "on time"}\n'
            'Due: ${_formatDate(task.deadline)}';
      } else {
        return daysLeft < 0
            ? 'Overdue by ${-daysLeft}d (Due: ${_formatDate(task.deadline)})'
            : daysLeft == 0
                ? 'Due today (${_formatDate(task.deadline)})'
                : daysLeft == 1
                    ? 'Due tomorrow (${_formatDate(task.deadline)})'
                    : 'Due in ${daysLeft}d (${_formatDate(task.deadline)})';
      }
    }

    return Consumer<TaskManager>(
      builder: (context, taskManager, child) {
        return Dismissible(
          key: Key(task.id),
          onDismissed: (direction) {
            taskManager.deleteTask(task.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Task deleted"),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    taskManager.addTask(task);
                  },
                ),
              ),
            );
          },
          background: Container(
            color: Colors.red.shade700,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Card(
            color: AppColors.darkGrey,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: _getStatusColor(task.status).withOpacity(0.3),
                width: 1,
              ),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Task Header
                  Container(
                    decoration: BoxDecoration(
                      color: _getStatusColor(task.status).withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.status == TaskStatus.completed,
                          onChanged: (bool? value) {
                            final oldStatus = task.status;
                            TaskStatus newStatus;

                            // Determine the next status based on current status
                            if (oldStatus == TaskStatus.toDo) {
                              newStatus = TaskStatus.inProgress;
                            } else if (oldStatus == TaskStatus.inProgress) {
                              newStatus = TaskStatus.completed;
                            } else if (oldStatus == TaskStatus.completed) {
                              newStatus = TaskStatus.toDo;
                            } else {
                              return;
                            }

                            // Update the task status
                            taskManager.updateTaskStatus(task.id, newStatus);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    _getSuccessMessage(oldStatus, newStatus)),
                                backgroundColor: _getStatusColor(newStatus),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    taskManager.updateTaskStatus(
                                        task.id, oldStatus);
                                  },
                                ),
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          activeColor: AppColors.highlight,
                          checkColor: AppColors.primaryBackground,
                          side: BorderSide(
                            color: _getStatusColor(task.status),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            task.name,
                            style: AppTextStyles.body.copyWith(
                              decoration: task.status == TaskStatus.completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (task.isPriority)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Priority',
                                  style: TextStyle(
                                    color: Colors.amber.shade300,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Task Details
                  if (task.details.isNotEmpty ||
                      task.deadline.isAfter(DateTime.now()))
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddTask(task: task),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (task.details.isNotEmpty) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.notes_rounded,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      task.details,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.body_grey.copyWith(
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: task.status == TaskStatus.completed
                                      ? Colors.grey
                                      : task.deadline.isBefore(DateTime.now())
                                          ? Colors.red
                                          : Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _getStatusText(),
                                    style: AppTextStyles.body_grey.copyWith(
                                      fontSize: 13,
                                      color: task.status == TaskStatus.completed
                                          ? Colors.grey
                                          : task.deadline
                                                  .isBefore(DateTime.now())
                                              ? Colors.red
                                              : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
