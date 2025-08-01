import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  List<Task> call() {
    return repository.getAllTasks();
  }
}
