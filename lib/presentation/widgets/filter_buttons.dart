import 'package:flutter/material.dart';
import 'package:to_do_application/core/enums/task_filter.dart';

// This widget shows a row of filter buttons for tasks: All, Active, Completed.
// It highlights the currently selected filter and calls a callback when a filter is selected.
class FilterButtons extends StatelessWidget {
  final TaskFilter activeFilter; // The currently selected filter
  final ValueChanged<TaskFilter> onFilterSelected; // Called when user picks a filter

  const FilterButtons({
    super.key,
    required this.activeFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the buttons horizontally
        children: TaskFilter.values.map((filter) {
          final isSelected = filter == activeFilter; // Check if this filter is active

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6), // Space between buttons
            child: ChoiceChip(
              label: Text(filter.label), // Show filter name like "All", "Active", "Completed"
              selected: isSelected, // Highlight if selected
              onSelected: (_) => onFilterSelected(filter), // Notify parent when tapped
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2), // Highlight color background
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : null, // Highlight text color if selected
                fontWeight: isSelected ? FontWeight.bold : null, // Bold text if selected
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Button padding
            ),
          );
        }).toList(), // Convert all filters to a list of widgets
      ),
    );
  }
}
