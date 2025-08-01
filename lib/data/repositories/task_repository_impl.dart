import 'package:to_do_application/data/models/task_model.dart';
import 'package:to_do_application/data/sources/local_task_data_source.dart';
import 'package:to_do_application/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalTaskDataSource _localDataSource;

  TaskRepositoryImpl(this._localDataSource);

  @override
  Future<void> init() async {
    await _localDataSource.init();
  }

  @override
  List<TaskModel> getAllTasks() {
    return _localDataSource.getAllTasks();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await _localDataSource.addTask(task);
  }

  @override
  Future<void> updateTask(int index, TaskModel task) async {
    await _localDataSource.updateTask(index, task);
  }

  @override
  Future<void> deleteTask(int index) async {
    await _localDataSource.deleteTask(index);
  }

  @override
  Future<void> clearAllTasks() async {
    await _localDataSource.clearAllTasks();
  }
}
