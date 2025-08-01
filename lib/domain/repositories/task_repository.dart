import 'package:to_do_application/data/models/task_model.dart';
import 'package:to_do_application/data/sources/local_task_data_source.dart';

class TaskRepository {
  final LocalTaskDataSource _localDataSource;

  TaskRepository(this._localDataSource);

  /// Initialize the local storage (Hive box)
  Future<void> init() async {
    await _localDataSource.init();
  }

  /// Fetch all tasks
  List<TaskModel> getAllTasks() {
    return _localDataSource.getAllTasks();
  }

  /// Add a task
  Future<void> addTask(TaskModel task) async {
    await _localDataSource.addTask(task);
  }

  /// Update a task by index
  Future<void> updateTask(int index, TaskModel task) async {
    await _localDataSource.updateTask(index, task);
  }

  /// Delete a task by index
  Future<void> deleteTask(int index) async {
    await _localDataSource.deleteTask(index);
  }

  /// Clear all tasks
  Future<void> clearAllTasks() async {
    await _localDataSource.clearAllTasks();
  }
}
