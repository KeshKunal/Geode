import 'package:hive/hive.dart';

part 'grove.g.dart';

@HiveType(typeId: 2)
class Grove extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime completedAt;

  @HiveField(2)
  final int duration; // Session duration in minutes

  Grove({
    String? id,
    required this.completedAt,
    required this.duration,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}
