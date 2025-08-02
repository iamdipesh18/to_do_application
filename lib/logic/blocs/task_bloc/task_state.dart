// Import Equatable to help compare state objects easily,
// which is important for efficient Bloc state management.
import 'package:equatable/equatable.dart';

// Import the Task entity which represents a task object.
import 'package:to_do_application/domain/entities/task.dart';

// This is the base abstract class for all task-related states.
// It extends Equatable so Bloc can efficiently detect state changes.
abstract class TaskState extends Equatable {
  const TaskState();

  // This tells Equatable which properties to use for comparison.
  @override
  List<Object?> get props => [];
}

// Initial state before any task-related action happens.
class TaskInitial extends TaskState {}

// State while tasks are being loaded (e.g., show a loading spinner).
class TaskLoading extends TaskState {}

// State when tasks have been successfully loaded.
// Contains the list of tasks to display.
class TaskLoaded extends TaskState {
  final List<Task> tasks;

  // Constructor requires the loaded list of tasks.
  const TaskLoaded(this.tasks);

  // Include the tasks list in equality checks.
  @override
  List<Object?> get props => [tasks];
}

// State to represent an error with a message.
// For example, when loading or updating tasks fails.
class TaskError extends TaskState {
  final String message;

  // Constructor requires the error message.
  const TaskError(this.message);

  // Include the error message in equality checks.
  @override
  List<Object?> get props => [message];
}
