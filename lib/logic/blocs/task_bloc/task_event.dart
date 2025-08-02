// Import Equatable to help compare event objects easily.
// This is important for Bloc to know when events change.
import 'package:equatable/equatable.dart';

// Import the Task entity which defines the structure of a task.
import 'package:to_do_application/domain/entities/task.dart';

// This is the base abstract class for all task-related events.
// It extends Equatable so that Bloc can efficiently compare event instances.
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  // This tells Equatable which properties to use to check if two events are equal.
  @override
  List<Object?> get props => [];
}

// Event to load all tasks.
class LoadTasks extends TaskEvent {}

// Event to add a new task.
class AddTaskEvent extends TaskEvent {
  // The task to add.
  final Task task;

  // Constructor requires the task to be added.
  const AddTaskEvent(this.task);

  // Include the task in props for equality checks.
  @override
  List<Object?> get props => [task];
}

// Event to update an existing task.
class UpdateTaskEvent extends TaskEvent {
  // The task with updated data.
  final Task task;

  // Constructor requires the updated task.
  const UpdateTaskEvent(this.task);

  // Include the task in props for equality checks.
  @override
  List<Object?> get props => [task];
}

// Event to delete a task by its ID.
class DeleteTaskEvent extends TaskEvent {
  // The ID of the task to delete.
  final String taskId;

  // Constructor requires the task ID.
  const DeleteTaskEvent(this.taskId);

  // Include the taskId in props for equality checks.
  @override
  List<Object?> get props => [taskId];
}

// Event to toggle the completion status of a task by its ID.
class ToggleTaskStatusEvent extends TaskEvent {
  // The ID of the task to toggle.
  final String taskId;

  // Constructor requires the task ID.
  const ToggleTaskStatusEvent(this.taskId);

  // Include the taskId in props for equality checks.
  @override
  List<Object?> get props => [taskId];
}
