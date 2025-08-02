// Import the TaskRepository interface to interact with task data.
import '../repositories/task_repository.dart';

// This class represents the "Delete Task" use case.
// It handles the action of removing a task by its ID.
class DeleteTask {
  // The repository responsible for managing task data.
  final TaskRepository repository;

  // Constructor: requires a TaskRepository to work.
  DeleteTask(this.repository);

  // The call method runs this use case like a function.
  // It takes the ID of the task to delete and tells the repository to delete it.
  Future<void> call(String taskId) async {
    await repository.deleteTask(taskId);
  }
}
