import 'package:flutter/material.dart';
import 'package:to_do_application/core/enums/task_filter.dart';

class FilterButtons extends StatelessWidget {
  final TaskFilter activeFilter;
  final ValueChanged<TaskFilter> onFilterSelected;

  const FilterButtons({
    super.key,
    required this.activeFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: TaskFilter.values.map((filter) {
        final isSelected = filter == activeFilter;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ChoiceChip(
            label: Text(filter.label),
            selected: isSelected,
            onSelected: (_) => onFilterSelected(filter),
          ),
        );
      }).toList(),
    );
  }
}
