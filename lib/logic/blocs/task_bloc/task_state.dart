import 'package:equatable/equatable.dart';
import 'package:to_do_application/domain/entities/task.dart';

class TaskState extends Equatable {
  final List<Task> tasks;
  final bool isLoading;
  final String? error;
  final bool isAscending;

  const TaskState(
    this.isAscending, {
    required this.tasks,
    this.isLoading = false,
    this.error,
  });

  // Initial/default state (empty task list)
  factory TaskState.initial() {
    return const TaskState(tasks: [], isLoading: false);
  }

  // Creates a copy with optional new values
  TaskState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? error,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object> get props => [tasks, isLoading, isAscending];
}
