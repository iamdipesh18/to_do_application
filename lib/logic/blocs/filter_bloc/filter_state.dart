// Import Equatable to help compare objects by their properties.
// This makes state management efficient by detecting changes easily.
import 'package:equatable/equatable.dart';

// Import the TaskFilter enum which defines filters like all, pending, completed.
import 'package:to_do_application/core/enums/task_filter.dart';

// This class represents the current state of the filter in the app.
// It keeps track of which task filter is currently active.
class FilterState extends Equatable {
  // The currently selected filter (e.g., all, pending, completed).
  final TaskFilter activeFilter;

  // Constructor: requires the active filter to create a FilterState instance.
  const FilterState({required this.activeFilter});

  // This method creates a new FilterState with an updated filter,
  // or keeps the existing one if no new filter is provided.
  FilterState copyWith({TaskFilter? activeFilter}) {
    return FilterState(activeFilter: activeFilter ?? this.activeFilter);
  }

  // This tells Equatable which properties to use to determine if two states are equal.
  @override
  List<Object?> get props => [activeFilter];
}
