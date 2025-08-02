// Import the model class that defines how tasks are stored in Hive.
import 'package:to_do_application/data/models/task_model.dart';

// Import the local data source which handles saving and loading tasks from Hive.
import 'package:to_do_application/data/sources/local_task_data_source.dart';

// Import the base Task entity class, which is used throughout the app.
import 'package:to_do_application/domain/entities/task.dart';

// Import the abstract TaskRepository, which defines the functions any task repo must have.
import 'package:to_do_application/domain/repositories/task_repository.dart';

// This class implements the TaskRepository interface.
// It acts as a bridge between the app and the local data source (Hive in this case).
class TaskRepositoryImpl implements TaskRepository {
  // This is a reference to the local data source that actually stores the data.
  final LocalTaskDataSource dataSource;

  // Constructor: it requires a LocalTaskDataSource to work with.
  TaskRepositoryImpl({required this.dataSource});

  // This method gets all tasks from the local data source.
  @override
  Future<List<Task>> getTasks() async {
    return dataSource.getTasks();
  }

  // This method adds a new task.
  // It first converts the Task object into a TaskModel (Hive-friendly version),
  // then passes it to the local data source to be saved.
  @override
  Future<void> addTask(Task task) async {
    final taskModel = _toTaskModel(task);
    await dataSource.addTask(taskModel);
  }

  // This method updates an existing task.
  // Again, it converts the Task to a TaskModel before saving.
  @override
  Future<void> updateTask(Task task) async {
    final taskModel = _toTaskModel(task);
    await dataSource.updateTask(taskModel);
  }

  // This deletes a task using its unique ID.
  @override
  Future<void> deleteTask(String taskId) async {
    await dataSource.deleteTask(taskId);
  }

  // This toggles a task's completion status (done ↔ not done).
  // It finds the task by its ID, flips the `isCompleted` value,
  // and then updates the task in the data source.
  @override
  Future<void> toggleTaskStatus(String taskId) async {
    final tasks = await dataSource.getTasks(); // Load all tasks
    final task = tasks.firstWhere((t) => t.id == taskId); // Find task by ID
    final updatedTask =
        task.copyWith(isCompleted: !task.isCompleted); // Toggle status
    await dataSource.updateTask(updatedTask); // Save updated task
  }

  // This private helper method converts a base Task object into a TaskModel object.
  // If the task is already a TaskModel, it just returns it.
  TaskModel _toTaskModel(Task task) {
    if (task is TaskModel) return task; // Already in correct form
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
