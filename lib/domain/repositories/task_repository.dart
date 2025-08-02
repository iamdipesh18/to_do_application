// Importing the Task entity, which defines the structure of a task.
import '../entities/task.dart';

// This is an abstract class that defines the contract for a Task Repository.
// A "repository" is like a middle layer between your app's logic and the data source.
// This class tells what functions any task-related data manager must provide.
abstract class TaskRepository {
  // This method will return a list of all tasks.
  Future<List<Task>> getTasks();

  // This method will add a new task to the system.
  Future<void> addTask(Task task);

  // This method will update an existing task with new information.
  Future<void> updateTask(Task task);

  // This method will delete a task using its unique ID.
  Future<void> deleteTask(String taskId);

  // This method will toggle a task's completion status (from done to not done, or vice versa).
  Future<void> toggleTaskStatus(String taskId);
}
