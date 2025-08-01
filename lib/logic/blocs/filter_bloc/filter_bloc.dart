import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterState.initial()) {
    on<FilterEvent>((event, emit) {
      emit(state.copyWith(currentFilter: event.filter));
    });
  }
}
