// Importing Hive, which is a lightweight local database used to store data on the device.
import 'package:hive/hive.dart';

// Importing the TaskModel class that defines the structure of a task for Hive.
import '../models/task_model.dart';

// This class handles reading from and writing to local storage (Hive).
// It's like the local database manager for tasks.
class LocalTaskDataSource {
  // This is the name of the Hive "box" (like a table in a database) that stores the tasks.
  static const String _boxName = 'tasks';

  // This method gets all tasks stored in the Hive box.
  // It returns a list of TaskModel objects.
  Future<List<TaskModel>> getTasks() async {
    final box = Hive.box<TaskModel>(_boxName); // Open the tasks box
    return box.values.toList(); // Return all stored tasks as a list
  }

  // This method adds a new task to Hive using the task's id as the key.
  Future<void> addTask(TaskModel task) async {
    final box = Hive.box<TaskModel>(_boxName); // Open the box
    await box.put(task.id, task); // Save the task using its id as the key
  }

  // This method updates an existing task.
  // If the task with the given id already exists, it will be replaced.
  Future<void> updateTask(TaskModel task) async {
    final box = Hive.box<TaskModel>(_boxName); // Open the box
    await box.put(task.id, task); // Overwrite the task with the same id
  }

  // This method deletes a task from Hive using its id.
  Future<void> deleteTask(String taskId) async {
    final box = Hive.box<TaskModel>(_boxName); // Open the box
    await box.delete(taskId); // Remove the task with the given id
  }
}
