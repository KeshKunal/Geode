import 'package:hive/hive.dart';

// This line connects our file to the generated file.
part 'task.g.dart';

@HiveType(typeId: 1) // Give the enum a unique typeId
enum TaskStatus {
  @HiveField(0)
  toDo,

  @HiveField(1)
  inProgress,

  @HiveField(2)
  completed,
}

@HiveType(typeId: 0) // Give the class a unique typeId
class Task extends HiveObject {
  // Add HiveObject extension
  @HiveField(0) // Give each field a unique, sequential index
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String details;

  @HiveField(3)
  final DateTime deadline;

  @HiveField(4)
  final bool isPriority;

  @HiveField(5)
  final TaskStatus status;

  Task({
    required this.name,
    required this.details,
    required this.deadline,
    required this.isPriority,
    this.status = TaskStatus.toDo,
  }) : id = DateTime.now().toIso8601String();
}
