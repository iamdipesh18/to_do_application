import 'package:hive/hive.dart';
import 'package:to_do_application/data/models/task_model.dart';

class LocalTaskDataSource {
  static const String taskBoxName = 'tasks_box';

  late Box<TaskModel> _taskBox;

  /// Initialize Hive box
  Future<void> init() async {
    // Open the Hive box where all tasks will be stored
    _taskBox = await Hive.openBox<TaskModel>(taskBoxName);
  }

  /// Get all tasks from the box
  List<TaskModel> getAllTasks() {
    // Return all values as a list
    return _taskBox.values.toList();
  }

  /// Add a new task to the box
  Future<void> addTask(TaskModel task) async {
    await _taskBox.add(task);
  }

  /// Update an existing task
  Future<void> updateTask(int index, TaskModel updatedTask) async {
    await _taskBox.putAt(index, updatedTask);
  }

  /// Delete a task from the box
  Future<void> deleteTask(int index) async {
    await _taskBox.deleteAt(index);
  }

  /// Clear all tasks
  Future<void> clearAllTasks() async {
    await _taskBox.clear();
  }
}
