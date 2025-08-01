import 'package:flutter/material.dart';
import 'package:to_do_application/logic/blocs/filter_bloc/filter_event.dart';

/// Widget to show filter buttons for All, Active, Completed tasks.
/// Highlights the currently selected filter.
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
          child: ElevatedButton(
            onPressed: () => onFilterSelected(filter),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
              foregroundColor: isSelected ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(filter.name.toUpperCase()),
          ),
        );
      }).toList(),
    );
  }
}
