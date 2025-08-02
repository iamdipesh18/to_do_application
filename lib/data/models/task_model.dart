// This line tells the Dart analyzer to ignore warnings about fields being overridden.
// We are intentionally overriding fields from the parent class.
// (i.e., from the 'Task' class we're extending)
// This is safe in this context.
// ignore_for_file: overridden_fields

// Import the Hive package so we can store and retrieve data from local storage.
import 'package:hive/hive.dart';

// Import our custom enum type 'Priority' which defines task priority levels.
import 'package:to_do_application/core/enums/priority.dart';

// Import the base 'Task' class which this model will extend.
import 'package:to_do_application/domain/entities/task.dart';

// This line allows Hive to generate supporting code for this model.
// It will create a file named `task_model.g.dart` with boilerplate code needed for Hive.
part 'task_model.g.dart';

// This annotation tells Hive that this class can be stored in its database.
// The 'typeId' must be unique for each model. This is set to 0 here.
@HiveType(typeId: 0)

// This class defines how a Task is stored in Hive.
// It extends 'Task' (the base class that defines the task structure)
// and mixes in 'HiveObjectMixin', which adds helper functions for Hive.
class TaskModel extends Task with HiveObjectMixin {
  // Below, each @HiveField gives a number (index) to the field.
  // Hive uses these numbers to save and read the data.

  @HiveField(0)
  @override
  final String id; // Unique ID for the task

  @HiveField(1)
  @override
  final String title; // Title of the task

  @HiveField(2)
  @override
  final String description; // Detailed description of the task

  @HiveField(3)
  @override
  final DateTime
      dueDate; // The date and time by which the task should be completed

  @HiveField(4)
  @override
  final Priority priority; // Priority level of the task (low, medium, high)

  @HiveField(5)
  @override
  final bool isCompleted; // Whether the task is finished or not (true or false)

  // Constructor: Creates a new TaskModel instance with required values
  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
  }) : super(
          // Passes values to the parent Task class
          id: id,
          title: title,
          description: description,
          dueDate: dueDate,
          priority: priority,
          isCompleted: isCompleted,
        );

  // This method allows us to create a copy of a task with some updated values.
  // It's useful for updating a task without changing the original one.
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
  }) {
    return TaskModel(
      // If a new value is provided, use it; otherwise, keep the old value.
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
