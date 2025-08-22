import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskManager extends ChangeNotifier {
  final List<Task> _tasks = [];
  late Box<Task> _taskBox;

  List<Task> get tasks => List.unmodifiable(_tasks);

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
    _taskBox.put(task.id, task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _taskBox.put(updatedTask.id, updatedTask);
      notifyListeners();
    }
  }

  void updateTaskStatus(String taskId, TaskStatus newStatus) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final updatedTask = _tasks[index].copyWith(status: newStatus);
      _tasks[index] = updatedTask;
      _taskBox.put(taskId, updatedTask);
      notifyListeners();
      
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    _taskBox.delete(taskId);
    notifyListeners();
  }
}
