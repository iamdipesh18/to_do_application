import 'package:flutter/material.dart';
import '../../logic/blocs/filter_bloc/filter_event.dart';

class FilterButtons extends StatelessWidget {
  final TaskFilter activeFilter;
  final Function(TaskFilter) onFilterSelected;

  const FilterButtons({
    super.key,
    required this.activeFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 12,
        children: TaskFilter.values.map((filter) {
          final isActive = filter == activeFilter;
          return ChoiceChip(
            label: Text(filter.name.toUpperCase()),
            selected: isActive,
            onSelected: (_) => onFilterSelected(filter),
          );
        }).toList(),
      ),
    );
  }
}
