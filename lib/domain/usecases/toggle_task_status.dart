// Import the TaskRepository interface to manage task data.
import '../repositories/task_repository.dart';

// This class represents the "Toggle Task Status" use case.
// It changes a task's completion status from done to not done or vice versa.
class ToggleTaskStatus {
  // The repository responsible for task data operations.
  final TaskRepository repository;

  // Constructor: requires a TaskRepository instance.
  ToggleTaskStatus(this.repository);

  // The call method runs this use case like a function.
  // It takes the ID of the task and tells the repository to toggle its status.
  Future<void> call(String taskId) async {
    await repository.toggleTaskStatus(taskId);
  }
}
