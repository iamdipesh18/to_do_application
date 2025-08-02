import 'package:equatable/equatable.dart';
import 'package:to_do_application/core/enums/task_filter.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class ChangeFilter extends FilterEvent {
  final TaskFilter filter;

  const ChangeFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}
