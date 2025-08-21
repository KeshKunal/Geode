import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart'; // Import Hive
import '../models/task.dart';

class TaskManager extends ChangeNotifier {
  final List<Task> _tasks = [];
  late Box<Task> _taskBox; // A variable to hold our Hive box

  List<Task> get tasks => _tasks;

  // A constructor to load data when the TaskManager is first created
  TaskManager() {
    _init();
  }

  // An initialization method to open the box and load tasks
  Future<void> _init() async {
    _taskBox = await Hive.openBox<Task>('tasks');
    _tasks.addAll(_taskBox.values);
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _updateDatabase(); // Save changes to Hive
    notifyListeners();
  }

  // A new method to update a task's status
  void updateTaskStatus(String id, TaskStatus newStatus) {
    // Changed from Task to String id
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      _tasks[taskIndex] = Task(
        name: task.name,
        details: task.details,
        deadline: task.deadline,
        isPriority: task.isPriority,
        status: newStatus,
      );
      _updateDatabase();
      notifyListeners();
    }
  }

  // A new method to delete a task
  void deleteTask(Task task) {
    _tasks.remove(task);
    _updateDatabase();
    notifyListeners();
  }

  // A private helper method to save the current list to the Hive box
  void _updateDatabase() {
    _taskBox.clear(); // Clear the box first
    _taskBox.addAll(_tasks); // Add all current tasks
  }
}
