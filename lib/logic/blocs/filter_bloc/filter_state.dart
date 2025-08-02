import 'package:equatable/equatable.dart';
import 'package:to_do_application/core/enums/task_filter.dart';

class FilterState extends Equatable {
  final TaskFilter activeFilter;

  const FilterState({required this.activeFilter});

  FilterState copyWith({TaskFilter? activeFilter}) {
    return FilterState(activeFilter: activeFilter ?? this.activeFilter);
  }

  @override
  List<Object?> get props => [activeFilter];
}
