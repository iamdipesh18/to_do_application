// Import the Task entity which represents a task object.
import '../entities/task.dart';

// Import the TaskRepository interface to fetch tasks.
import '../repositories/task_repository.dart';

// This class represents the "Get Tasks" use case.
// It handles the action of retrieving the list of tasks from the repository.
class GetTasks {
  // The repository that manages the task data.
  final TaskRepository repository;

  // Constructor: requires a TaskRepository instance.
  GetTasks(this.repository);

  // The call method runs this use case like a function.
  // It fetches and returns a list of tasks from the repository.
  Future<List<Task>> call() async {
    return await repository.getTasks();
  }
}
