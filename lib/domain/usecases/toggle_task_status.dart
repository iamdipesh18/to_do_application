import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/domain/repositories/task_repository.dart';

class ToggleTaskStatus {
  final TaskRepository repository;

  ToggleTaskStatus(this.repository);

  Future<void> call(int index, Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await repository.updateTask(index, updatedTask);
  }
}
