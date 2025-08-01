/// TaskPriority defines the importance level of a task.
/// It's used to categorize tasks as low, medium, or high priority.
enum TaskPriority {
  low,
  medium,
  high,
}

/// A utility method to convert enum to a readable string.
String taskPriorityToString(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.low:
      return 'Low';
    case TaskPriority.medium:
      return 'Medium';
    case TaskPriority.high:
      return 'High';
  }
}
