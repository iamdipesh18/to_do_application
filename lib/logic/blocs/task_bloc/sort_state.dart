// Import Equatable to help compare state objects easily,
// which is important for efficient state management.
import 'package:equatable/equatable.dart';

// Import the SortOrder enum which defines sorting options (ascending or descending).
import '../../../core/enums/sort_order.dart';

// This class represents the current state of sorting in the app.
// It keeps track of the current sort order for tasks.
class SortState extends Equatable {
  // The current sorting order, defaulting to ascending if none is provided.
  final SortOrder order;

  // Constructor: allows setting the sort order, defaults to ascending.
  const SortState({this.order = SortOrder.ascending});

  // This tells Equatable which properties to use to determine equality of states.
  @override
  List<Object> get props => [order];
}
