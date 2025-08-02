import '../entities/task.dart';
import '../../core/enums/sort_order.dart';

class SortTasks {
  List<Task> call(List<Task> tasks, SortOrder order) {
    final sortedTasks = List<Task>.from(tasks);
    sortedTasks.sort((a, b) {
      final compare = a.dueDate.compareTo(b.dueDate);
      return order == SortOrder.ascending ? compare : -compare;
    });
    return sortedTasks;
  }
}
