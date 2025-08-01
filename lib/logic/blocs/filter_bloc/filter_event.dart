enum TaskFilter { all, active, completed }

class FilterEvent {
  final TaskFilter filter;

  FilterEvent(this.filter);
}
