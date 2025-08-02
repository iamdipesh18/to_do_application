import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_application/domain/usecases/add_task.dart';
import 'package:to_do_application/domain/usecases/delete_task.dart';
import 'package:to_do_application/domain/usecases/get_tasks.dart';
import 'package:to_do_application/domain/usecases/toggle_task_status.dart';
import 'package:to_do_application/domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';


class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks _getTasks;
  final AddTask _addTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final ToggleTaskStatus _toggleTaskStatus;

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
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskStatusEvent>(_onToggleTaskStatus);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await _getTasks.call();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await _addTask.call(event.task);
        final updatedTasks = List.of(currentState.tasks)..add(event.task);
        emit(TaskLoaded(updatedTasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await _updateTask.call(event.task);
        final updatedTasks = currentState.tasks.map((task) {
          return task.id == event.task.id ? event.task : task;
        }).toList();
        emit(TaskLoaded(updatedTasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await _deleteTask.call(event.taskId);
        final updatedTasks = currentState.tasks.where((task) => task.id != event.taskId).toList();
        emit(TaskLoaded(updatedTasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  Future<void> _onToggleTaskStatus(ToggleTaskStatusEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await _toggleTaskStatus.call(event.taskId);
        final updatedTasks = currentState.tasks.map((task) {
          if (task.id == event.taskId) {
            return task.copyWith(isCompleted: !task.isCompleted);
          }
          return task;
        }).toList();
        emit(TaskLoaded(updatedTasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }
}
