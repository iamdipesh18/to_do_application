import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/domain/usecases/add_task.dart';
import 'package:to_do_application/domain/usecases/delete_task.dart';
import 'package:to_do_application/domain/usecases/get_tasks.dart';
import 'package:to_do_application/domain/usecases/update_task.dart';
import 'package:to_do_application/domain/usecases/toggle_task_status.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final DeleteTask deleteTask;
  final UpdateTask updateTask;
  final ToggleTaskStatus toggleTaskStatus;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.deleteTask,
    required this.updateTask,
    required this.toggleTaskStatus,
  }) : super(TaskState.initial()) {
    on<LoadTasks>((event, emit) {
      emit(state.copyWith(tasks: getTasks()));
    });

    on<AddTaskEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await addTask(event.task);
      emit(state.copyWith(
        tasks: getTasks(),
        isLoading: false,
      ));
    });

    on<UpdateTaskEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await updateTask(event.index, event.updatedTask);
      emit(state.copyWith(
        tasks: getTasks(),
        isLoading: false,
      ));
    });

    on<DeleteTaskEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await deleteTask(event.index);
      emit(state.copyWith(
        tasks: getTasks(),
        isLoading: false,
      ));
    });

    on<ToggleSortOrderEvent>((event, emit) {
      final toggled = !state.isAscending;
      final sortedTasks = [...state.tasks];

      sortedTasks.sort((a, b) => toggled
          ? a.dueDate.compareTo(b.dueDate)
          : b.dueDate.compareTo(a.dueDate));

      emit(state.copyWith(
        tasks: sortedTasks,
        isAscending: toggled,
      ));
    });
  }
}
