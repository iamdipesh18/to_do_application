// Importing the Priority enum which defines levels of task importance (low, medium, high).
import 'package:to_do_application/core/enums/priority.dart';

// This is a basic "Task" class that represents a single to-do item in the app.
class Task {
  // Unique identifier for each task.
  final String id;

  // The title or name of the task (e.g., "Buy groceries").
  final String title;

  // A more detailed description of the task.
  final String description;

  // The due date and time by which the task should be completed.
  final DateTime dueDate;

  // The priority of the task (low, medium, or high).
  final Priority priority;

  // Whether the task is completed (true) or still pending (false).
  final bool isCompleted;

  // Constructor: Used to create a Task object with all the necessary values.
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
  });

  // This method creates a new version (copy) of the task with updated values.
  // If a value isn't provided, it keeps the existing one.
  // Useful for editing tasks without changing the original directly.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
