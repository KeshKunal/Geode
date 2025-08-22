import 'package:flutter/material.dart';
import 'package:geode/core/constants/app_colors.dart';
import 'package:geode/core/constants/app_text_styles.dart';
import 'package:geode/models/task.dart';
import 'package:geode/providers/task_manager.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  final Task? task; // Add this line
  const AddTask({super.key, this.task}); // Update constructor

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  bool _isPriority = false;
  DateTime? _selectedDate;

  // Add these variables for validation
  bool _isNameEmpty = false;
  bool _isDateEmpty = false;

  @override
  void initState() {
    super.initState();
    // Initialize fields if editing an existing task
    if (widget.task != null) {
      _nameController.text = widget.task!.name;
      _detailsController.text = widget.task!.details;
      _isPriority = widget.task!.isPriority;
      _selectedDate = widget.task!.deadline;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

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
    final isEditing = widget.task != null;
    final titleText = isEditing ? "Edit Task" : "Add New Task";
    final buttonText = isEditing ? "Update" : "Create";

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: const BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(titleText, style: AppTextStyles.subheading),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Task Name',
              border: const OutlineInputBorder(),
              labelStyle: TextStyle(
                color: _isNameEmpty ? Colors.red : Colors.grey,
              ),
              // Add error text if validation fails
              errorText: _isNameEmpty ? '*required' : null,
            ),
            style: AppTextStyles.body,
            onChanged: (value) {
              // Clear error when user starts typing
              if (_isNameEmpty) {
                setState(() {
                  _isNameEmpty = false;
                });
              }
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _detailsController,
            decoration: const InputDecoration(
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
              Text(
                "Due Date",
                style: AppTextStyles.body.copyWith(
                  color: _isDateEmpty ? Colors.red : null,
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(_formatDate(_selectedDate)),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      _isDateEmpty ? Colors.red : AppColors.secondaryAccent,
                  side: BorderSide(
                    color: _isDateEmpty
                        ? Colors.red
                        : _selectedDate != null
                            ? AppColors.highlight
                            : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          if (_isDateEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '*required',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
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
                activeColor: AppColors.highlight,
                trackOutlineColor: MaterialStateProperty.all(Colors.grey),
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
                // Update validation states
                setState(() {
                  _isNameEmpty = _nameController.text.isEmpty;
                  _isDateEmpty = _selectedDate == null;
                });

                // Only proceed if validation passes
                if (!_isNameEmpty && !_isDateEmpty) {
                  final taskManager = context.read<TaskManager>();
                  if (widget.task != null) {
                    final updatedTask = widget.task!.copyWith(
                      name: _nameController.text,
                      details: _detailsController.text,
                      deadline: _selectedDate!,
                      isPriority: _isPriority,
                    );
                    taskManager.updateTask(updatedTask);
                  } else {
                    final newTask = Task(
                      name: _nameController.text,
                      details: _detailsController.text,
                      deadline: _selectedDate!,
                      isPriority: _isPriority,
                    );
                    taskManager.addTask(newTask);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(
                buttonText,
                style: const TextStyle(color: AppColors.primaryBackground),
              ),
            ),
          )
        ],
      ),
    );
  }
}
