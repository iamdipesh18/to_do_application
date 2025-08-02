// Import Equatable to help compare objects easily.
// This is useful for Bloc to detect when events change.
import 'package:equatable/equatable.dart';

// Import the TaskFilter enum which defines filters like all, pending, and completed.
import 'package:to_do_application/core/enums/task_filter.dart';

// This is the base abstract class for all filter-related events.
// It extends Equatable so that events can be compared by their properties.
abstract class FilterEvent extends Equatable {
  const FilterEvent();

  // This method returns the list of properties that determine equality.
  // Since this is the base class with no properties, it returns an empty list.
  @override
  List<Object?> get props => [];
}

// This event represents a request to change the active task filter.
class ChangeFilter extends FilterEvent {
  // The new filter to apply (all, pending, or completed).
  final TaskFilter filter;

  // Constructor: requires the new filter.
  const ChangeFilter(this.filter);

  // Include the filter in the list of properties for equality checks.
  @override
  List<Object?> get props => [filter];
}
