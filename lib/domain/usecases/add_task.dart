import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<void> call(Task task) async {
    await repository.addTask(task);
  }
}
