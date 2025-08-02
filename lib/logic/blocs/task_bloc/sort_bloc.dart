// Import flutter_bloc package to use the Bloc pattern for state management.
import 'package:flutter_bloc/flutter_bloc.dart';

// Import the events related to sorting tasks.
import 'sort_event.dart';

// Import the states related to sorting tasks.
import 'sort_state.dart';

// This class manages the sorting state of the task list using the Bloc pattern.
// It listens for sorting events and updates the sort order state accordingly.
class SortBloc extends Bloc<SortEvent, SortState> {
  
  // The constructor initializes the Bloc with an initial state.
  // The initial sort state is set with default values (e.g., ascending order).
  SortBloc() : super(const SortState()) {
    
    // This listens for the ChangeSortOrder event.
    // When this event happens, it updates the sort state with the new order.
    on<ChangeSortOrder>((event, emit) {
      emit(SortState(order: event.order));
    });
  }
}
