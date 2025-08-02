import 'package:equatable/equatable.dart';
import 'filter_event.dart';

class FilterState extends Equatable {
  final TaskFilter activeFilter;

  const FilterState({this.activeFilter = TaskFilter.all});

  FilterState copyWith({TaskFilter? activeFilter}) {
    return FilterState(
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object?> get props => [activeFilter];
}
