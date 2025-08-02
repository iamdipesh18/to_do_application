import 'package:hive/hive.dart';
import '../models/task_model.dart';

class LocalTaskDataSource {
  static const String _boxName = 'tasks';

  Future<List<TaskModel>> getTasks() async {
    final box = Hive.box<TaskModel>(_boxName);
    return box.values.toList();
  }

  Future<void> addTask(TaskModel task) async {
    final box = Hive.box<TaskModel>(_boxName);
    await box.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    final box = Hive.box<TaskModel>(_boxName);
    await box.put(task.id, task);
  }

  Future<void> deleteTask(String taskId) async {
    final box = Hive.box<TaskModel>(_boxName);
    await box.delete(taskId);
  }
}
