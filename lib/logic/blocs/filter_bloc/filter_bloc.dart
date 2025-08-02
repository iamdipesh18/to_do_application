import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState()) {
    on<ChangeFilter>(_onChangeFilter);
  }

  void _onChangeFilter(ChangeFilter event, Emitter<FilterState> emit) {
    emit(state.copyWith(activeFilter: event.filter));
  }
}
