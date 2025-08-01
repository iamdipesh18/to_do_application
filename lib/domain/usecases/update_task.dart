import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/domain/repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<void> call(int index, Task task) async {
    await repository.updateTask(index, task);
  }
}
