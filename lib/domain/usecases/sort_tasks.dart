// Import the Task entity which represents a task object.
import '../entities/task.dart';

// Import the SortOrder enum which defines sorting order (ascending or descending).
import '../../core/enums/sort_order.dart';

// This class represents the "Sort Tasks" use case.
// It sorts a list of tasks by their due date, either ascending or descending.
class SortTasks {
  // This method takes a list of tasks and a sort order,
  // then returns a new list sorted by due date.
  List<Task> call(List<Task> tasks, SortOrder order) {
    // Create a new list by copying the original tasks
    final sortedTasks = List<Task>.from(tasks);

    // Sort the copied list based on the dueDate of each task
    sortedTasks.sort((a, b) {
      // Compare the due dates of two tasks
      final compare = a.dueDate.compareTo(b.dueDate);

      // If the order is ascending, use the comparison result as is.
      // If descending, reverse the comparison result by negating it.
      return order == SortOrder.ascending ? compare : -compare;
    });

    // Return the sorted list
    return sortedTasks;
  }
}
