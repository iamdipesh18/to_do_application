enum TaskFilter { all, pending, completed }

extension TaskFilterExtension on TaskFilter {
  String get label {
    switch (this) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.pending:
        return 'Active';
      case TaskFilter.completed:
        return 'Completed';
    }
  }
}
