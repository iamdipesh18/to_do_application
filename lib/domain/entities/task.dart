import 'package:to_do_application/core/enums/priority.dart';

/// A clean, plain Dart representation of a Task.
///
/// This class holds all the data for a task and is used in the domain layer.
/// It does NOT depend on Flutter or Hive, so it's easy to test and maintain.
class Task {
  final String id; // Unique identifier, e.g. a timestamp string
  final String title; // Title of the task
  final String? description; // Optional description
  final bool isCompleted; // Whether the task is done
  final TaskPriority priority; // Priority enum: high, medium, low
  final DateTime dueDate; // When the task should be done by

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    required this.dueDate,
  });

  /// Creates a new Task object by copying current values and
  /// replacing any provided fields.
  ///
  /// Useful for immutability and updating tasks.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, isCompleted: $isCompleted, priority: $priority, dueDate: $dueDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isCompleted == isCompleted &&
        other.priority == priority &&
        other.dueDate == dueDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        (description?.hashCode ?? 0) ^
        isCompleted.hashCode ^
        priority.hashCode ^
        dueDate.hashCode;
  }
}
