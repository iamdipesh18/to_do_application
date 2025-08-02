// This enum defines filters that can be applied to a task list:
// - all: show every task
// - pending: show only tasks that are not completed
// - completed: show only the finished tasks
enum TaskFilter {
  all, // Show all tasks
  pending, // Show only unfinished tasks
  completed // Show only completed tasks
}

// This extension adds a method to the TaskFilter enum that lets us
// get a readable string label for each filter.
extension TaskFilterExtension on TaskFilter {
  // This getter returns a text label depending on which filter is selected.
  String get label {
    switch (this) {
      case TaskFilter.all:
        return 'All'; // Label for showing all tasks
      case TaskFilter.pending:
        return 'Active'; // Label for pending tasks (not yet done)
      case TaskFilter.completed:
        return 'Completed'; // Label for finished tasks
    }
  }
}
