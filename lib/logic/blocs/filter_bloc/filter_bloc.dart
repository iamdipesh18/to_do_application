import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_event.dart';
import 'filter_state.dart';
import 'package:to_do_application/core/enums/task_filter.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState(activeFilter: TaskFilter.all)) {
    on<ChangeFilter>((event, emit) {
      emit(state.copyWith(activeFilter: event.filter));
    });
  }
}
