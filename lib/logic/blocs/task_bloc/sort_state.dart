import 'package:equatable/equatable.dart';
import '../../../core/enums/sort_order.dart';

class SortState extends Equatable {
  final SortOrder order;

  const SortState({this.order = SortOrder.ascending});

  @override
  List<Object> get props => [order];
}
