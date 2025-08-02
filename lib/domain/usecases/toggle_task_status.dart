import '../repositories/task_repository.dart';

class ToggleTaskStatus {
  final TaskRepository repository;

  ToggleTaskStatus(this.repository);

  Future<void> call(String taskId) async {
    await repository.toggleTaskStatus(taskId);
  }
}
