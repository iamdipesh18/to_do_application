import 'package:to_do_application/data/models/task_model.dart';
import 'package:to_do_application/data/sources/local_task_data_source.dart';
import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalTaskDataSource dataSource;

  TaskRepositoryImpl({required this.dataSource});

  @override
  Future<List<Task>> getTasks() async {
    return dataSource.getTasks();
  }

  @override
  Future<void> addTask(Task task) async {
    final taskModel = _toTaskModel(task);
    await dataSource.addTask(taskModel);
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskModel = _toTaskModel(task);
    await dataSource.updateTask(taskModel);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await dataSource.deleteTask(taskId);
  }

  @override
  Future<void> toggleTaskStatus(String taskId) async {
    final tasks = await dataSource.getTasks();
    final task = tasks.firstWhere((t) => t.id == taskId);
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await dataSource.updateTask(updatedTask);
  }

  TaskModel _toTaskModel(Task task) {
    if (task is TaskModel) return task;
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      priority: task.priority,
      isCompleted: task.isCompleted,
    );
  }
}
