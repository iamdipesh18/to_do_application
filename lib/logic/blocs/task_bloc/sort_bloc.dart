import 'package:flutter_bloc/flutter_bloc.dart';
import 'sort_event.dart';
import 'sort_state.dart';

class SortBloc extends Bloc<SortEvent, SortState> {
  SortBloc() : super(const SortState()) {
    on<ChangeSortOrder>((event, emit) {
      emit(SortState(order: event.order));
    });
  }
}
