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
  TaskStatus status;

  Task({
    String? id,
    required this.name,
    required this.details,
    required this.deadline,
    this.isPriority = false,
    this.status = TaskStatus.toDo,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Add this copyWith method
  Task copyWith({
    String? id,
    String? name,
    String? details,
    DateTime? deadline,
    bool? isPriority,
    TaskStatus? status,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      details: details ?? this.details,
      deadline: deadline ?? this.deadline,
      isPriority: isPriority ?? this.isPriority,
      status: status ?? this.status,
    );
  }
}
