import 'filter_event.dart';

class FilterState {
  final TaskFilter currentFilter;

  FilterState({required this.currentFilter});

  factory FilterState.initial() {
    return FilterState(currentFilter: TaskFilter.all);
  }

  FilterState copyWith({TaskFilter? currentFilter}) {
    return FilterState(
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}
