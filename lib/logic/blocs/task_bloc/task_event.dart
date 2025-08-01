// This file defines all possible events (actions) related to task operations.

import 'package:equatable/equatable.dart';
import 'package:to_do_application/data/models/task_model.dart';

/// All task events will extend this base class.
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all tasks from local storage
class LoadTasks extends TaskEvent {}

/// Event to add a new task
class AddTask extends TaskEvent {
  final TaskModel task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Event to update an existing task by index
class UpdateTask extends TaskEvent {
  final int index;
  final TaskModel updatedTask;

  const UpdateTask({required this.index, required this.updatedTask});

  @override
  List<Object?> get props => [index, updatedTask];
}

/// Event to delete a task by index
class DeleteTask extends TaskEvent {
  final int index;

  const DeleteTask(this.index);

  @override
  List<Object?> get props => [index];
}

/// Event to clear all tasks
class ClearAllTasks extends TaskEvent {}



class ToggleSortOrderEvent extends TaskEvent {}

