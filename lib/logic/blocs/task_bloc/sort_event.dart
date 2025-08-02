import 'package:equatable/equatable.dart';
import '../../../core/enums/sort_order.dart';

abstract class SortEvent extends Equatable {
  const SortEvent();

  @override
  List<Object> get props => [];
}

class ChangeSortOrder extends SortEvent {
  final SortOrder order;

  const ChangeSortOrder(this.order);

  @override
  List<Object> get props => [order];
}
