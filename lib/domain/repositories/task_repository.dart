import 'package:to_do_application/data/models/task_model.dart';

abstract class TaskRepository {
  Future<void> init();
  List<TaskModel> getAllTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(int index, TaskModel task);
  Future<void> deleteTask(int index);
  Future<void> clearAllTasks();
}
