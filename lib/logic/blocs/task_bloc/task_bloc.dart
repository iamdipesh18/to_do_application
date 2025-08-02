// Importing flutter_bloc for Bloc pattern state management.
import 'package:flutter_bloc/flutter_bloc.dart';

// Importing the use cases for managing tasks.
import 'package:to_do_application/domain/usecases/add_task.dart';
import 'package:to_do_application/domain/usecases/delete_task.dart';
import 'package:to_do_application/domain/usecases/get_tasks.dart';
import 'package:to_do_application/domain/usecases/toggle_task_status.dart';
import 'package:to_do_application/domain/usecases/update_task.dart';

// Importing the event and state definitions for tasks.
import 'task_event.dart';
import 'task_state.dart';

// This Bloc handles all the task-related states and events in the app.
// It listens for events like loading, adding, updating, deleting, and toggling tasks,
// then updates the UI state accordingly.
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  // Use cases that the Bloc will call to perform actions on tasks.
  final GetTasks _getTasks;
  final AddTask _addTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final ToggleTaskStatus _toggleTaskStatus;

  // Constructor: requires all the use cases to be passed in.
  // It initializes the Bloc with an initial empty state (TaskInitial).
  TaskBloc({
    required GetTasks getTasks,
    required AddTask addTask,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
    required ToggleTaskStatus toggleTaskStatus,
  })  : _getTasks = getTasks,
        _addTask = addTask,
        _updateTask = updateTask,
        _deleteTask = deleteTask,
        _toggleTaskStatus = toggleTaskStatus,
        super(TaskInitial()) {
    // Register event handlers for different task events.
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskStatusEvent>(_onToggleTaskStatus);
  }

  // Event handler for loading all tasks.
  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading()); // Show loading indicator
    try {
      final tasks = await _getTasks.call(); // Fetch tasks
      emit(TaskLoaded(tasks)); // Emit loaded tasks state
    } catch (e) {
      emit(TaskError(e.toString())); // Emit error state if something fails
    }
  }

  // Event handler for adding a new task.
  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    // Only proceed if the current state has tasks loaded
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await _addTask.call(event.task); // Add the new task using the use case
        // Create a new list with the existing tasks plus the new task
        final updatedTasks = List.of(currentState.tasks)..add(event.task);
        emit(TaskLoaded(updatedTasks)); // Emit updated list of tasks
      } catch (e) {
        emit(TaskError(e.toString())); // Emit error if add fails
      }
    }
  }

  // Event handler for updating an existing task.
  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await _updateTask.call(event.task); // Update the task
        // Replace the updated task in the existing task list
        final updatedTasks = currentState.tasks.map((task) {
          return task.id == event.task.id ? event.task : task;
        }).toList();
        emit(TaskLoaded(updatedTasks)); // Emit updated list
      } catch (e) {
        emit(TaskError(e.toString())); // Emit error on failure
      }
    }
  }

  // Event handler for deleting a task by ID.
  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await _deleteTask.call(event.taskId); // Delete the task
        // Remove the deleted task from the list
        final updatedTasks = currentState.tasks.where((task) => task.id != event.taskId).toList();
        emit(TaskLoaded(updatedTasks)); // Emit updated list
      } catch (e) {
        emit(TaskError(e.toString())); // Emit error if delete fails
      }
    }
  }

  // Event handler for toggling the completion status of a task.
  Future<void> _onToggleTaskStatus(ToggleTaskStatusEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await _toggleTaskStatus.call(event.taskId); // Toggle completion status
        // Update the task in the list with its toggled status
        final updatedTasks = currentState.tasks.map((task) {
          if (task.id == event.taskId) {
            return task.copyWith(isCompleted: !task.isCompleted);
          }
          return task;
        }).toList();
        emit(TaskLoaded(updatedTasks)); // Emit updated list
      } catch (e) {
        emit(TaskError(e.toString())); // Emit error if toggle fails
      }
    }
  }
}
