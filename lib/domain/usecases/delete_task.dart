import 'package:to_do_application/domain/repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(int index) async {
    await repository.deleteTask(index);
  }
}
