// Import the flutter_bloc package to use the Bloc pattern for state management.
import 'package:flutter_bloc/flutter_bloc.dart';

// Import the events related to filtering tasks.
import 'filter_event.dart';

// Import the states related to filtering tasks.
import 'filter_state.dart';

// Import the TaskFilter enum which defines different filters (all, pending, completed).
import 'package:to_do_application/core/enums/task_filter.dart';

// This class manages the filtering state of the task list using the Bloc pattern.
// Bloc listens for filter events and updates the filter state accordingly.
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  
  // The constructor initializes the Bloc with an initial filter state.
  // The initial filter is set to 'all' tasks (showing every task).
  FilterBloc() : super(const FilterState(activeFilter: TaskFilter.all)) {
    
    // This listens for the ChangeFilter event.
    // When a ChangeFilter event happens, it updates the filter state with the new filter.
    on<ChangeFilter>((event, emit) {
      emit(state.copyWith(activeFilter: event.filter));
    });
  }
}
