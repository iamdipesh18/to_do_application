// Import the Task entity that represents a task object.
import '../entities/task.dart';

// Import the TaskRepository interface to manage task data.
import '../repositories/task_repository.dart';

// This class represents the "Update Task" use case.
// It handles editing or updating an existing task.
class UpdateTask {
  // The repository responsible for task data operations.
  final TaskRepository repository;

  // Constructor: requires a TaskRepository instance.
  UpdateTask(this.repository);

  // The call method runs this use case like a function.
  // It takes a Task object with updated information and tells the repository to save it.
  Future<void> call(Task task) async {
    await repository.updateTask(task);
  }
}
