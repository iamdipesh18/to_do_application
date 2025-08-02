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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        children: TaskFilter.values.map((filter) {
          final isSelected = filter == activeFilter;
          return ChoiceChip(
            label: Text(
              filter.label,
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onFilterSelected(filter),
            selectedColor: theme.colorScheme.primaryContainer,
            backgroundColor: theme.colorScheme.surfaceVariant,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            elevation: isSelected ? 4 : 0,
            shadowColor: theme.colorScheme.primary.withOpacity(0.3),
          );
        }).toList(),
      ),
    );
  }
}
