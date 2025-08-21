import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:geode/models/task.dart';
import 'package:geode/providers/task_manager.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool _isPriority = false;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.highlight,
              onPrimary: AppColors.primaryBackground,
              surface: AppColors.darkGrey,
              onSurface: AppColors.secondaryAccent,
            ),
            dialogBackgroundColor: AppColors.primaryBackground,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.highlight,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: const BoxDecoration(
          color: AppColors.darkGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add New Task", style: AppTextStyles.subheading),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Task Name',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.grey),
            ),
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 15),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Notes (Optional)',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.grey),
            ),
            maxLines: 3, // Makes it a multi-line text area
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Text("Due Date", style: AppTextStyles.body),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(_formatDate(_selectedDate)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondaryAccent,
                  side: BorderSide(
                    color: _selectedDate != null
                        ? AppColors.highlight
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Mark as Priority", style: AppTextStyles.body),
              Switch(
                value: _isPriority,
                onChanged: (newval) {
                  setState(() {
                    _isPriority = newval;
                  });
                },
                activeColor: const Color(0xFFFF5252),
                trackOutlineColor: WidgetStateProperty.all(Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlight,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                final taskName = _nameController.text;
                final taskDetails = _detailsController.text;
                final isPriority = _isPriority;

                if (taskName.isEmpty) {
                  return;
                }

                final newTask = Task(
        name: taskName,
        details: taskDetails,
        deadline: DateTime.now().add(const Duration(days: 2)), // Placeholder deadline for now
        isPriority: isPriority,
      );

      Provider.of<TaskManager>(context, listen: false).addTask(newTask);

       Navigator.pop(context);
              },
              child: const Text(
                "Create",
                style: TextStyle(color: AppColors.primaryBackground),
              ),
            ),
          )
        ],
      ),
    );
  }
}
