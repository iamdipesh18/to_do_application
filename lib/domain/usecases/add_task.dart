// Import the Task entity that represents a task object.
import '../entities/task.dart';

// Import the TaskRepository interface to interact with task data.
import '../repositories/task_repository.dart';

// This class represents the "Add Task" use case in the app.
// A use case is a specific action or operation the app can perform.
class AddTask {
  // The repository that handles data operations related to tasks.
  final TaskRepository repository;

  // Constructor: Requires a TaskRepository to work with.
  AddTask(this.repository);

  // The call method allows us to run this use case like a function.
  // It takes a Task object and tells the repository to add it.
  Future<void> call(Task task) async {
    await repository.addTask(task);
  }
}
