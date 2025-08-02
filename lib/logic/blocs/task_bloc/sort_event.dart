// Import Equatable to make it easier to compare event objects.
import 'package:equatable/equatable.dart';

// Import the SortOrder enum which defines sorting options (ascending, descending).
import '../../../core/enums/sort_order.dart';

// This is the base abstract class for all sorting-related events.
// Extending Equatable allows Bloc to easily check if events are equal.
abstract class SortEvent extends Equatable {
  const SortEvent();

  // This tells Equatable which properties to use for comparison.
  // Since this base class has no properties, it returns an empty list.
  @override
  List<Object> get props => [];
}

// This event represents a change in the sorting order.
class ChangeSortOrder extends SortEvent {
  // The new sort order (ascending or descending).
  final SortOrder order;

  // Constructor requires the new sort order.
  const ChangeSortOrder(this.order);

  // Include the 'order' property for equality checks.
  @override
  List<Object> get props => [order];
}
