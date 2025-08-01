import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../core/enums/priority.dart';

part 'task_model.g.dart'; // Generated file for Hive adapter

/// Hive box type ID (must be unique)
@HiveType(typeId: 0)
class TaskModel extends HiveObject with EquatableMixin {
  /// Unique ID for the task
  @HiveField(0)
  final String id;

  /// Title of the task
  @HiveField(1)
  final String title;

  /// Detailed description
  @HiveField(2)
  final String description;

  /// Date and time of the task
  @HiveField(3)
  final DateTime date;

  /// Priority of the task
  @HiveField(4)
  final TaskPriority priority;

  /// Completion status of the task
  @HiveField(5)
  final bool isCompleted;

  TaskModel({
    String? id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4(); // Generate UUID if not provided

  /// Create a copy of the task with updated fields
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TaskPriority? priority,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Used to compare two tasks (for BLoC equality)
  @override
  List<Object?> get props => [id, title, description, date, priority, isCompleted];
}
