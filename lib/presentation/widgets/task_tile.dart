import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_application/core/constants/colors.dart';
import 'package:to_do_application/core/enums/priority.dart';
import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/presentation/dialogs/task_dialog.dart';
import '../../logic/blocs/task_bloc/task_bloc.dart';
import '../../logic/blocs/task_bloc/task_event.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  // Returns the color associated with each priority level
  Color _priorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return AppColors.highPriority;
      case Priority.medium:
        return AppColors.mediumPriority;
      case Priority.low:
        return AppColors.lowPriority;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If task is completed, show text with line-through and grey color
    final textStyle = task.isCompleted
        ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)
        : null;

    return Dismissible(
      // Unique key for dismissible widget, using task ID
      key: Key(task.id),

      // Swipe direction allowed: right to left (end to start)
      direction: DismissDirection.endToStart,

      // Background shown behind the item when swiping (red delete background with trash icon)
      background: Container(
        color: Colors.red.shade600,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      // Confirm dismissal by showing a dialog asking user to confirm deletion
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
            ],
          ),
        );
      },

      // Called when the item is dismissed (after confirmation)
      onDismissed: (_) {
        // Dispatch event to Bloc to delete the task by ID
        context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
        // Show a snackbar to notify the user task was deleted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      },

      // The visible card containing the task info
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          // Long press on the tile opens the edit task dialog
          onLongPress: () {
            showDialog(
              context: context,
              builder: (_) => TaskDialog(
                task: task, // pass current task for editing
                onSave: (updatedTask) {
                  // When user saves changes, dispatch update event to Bloc
                  context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
                },
              ),
            );
          },

          // Checkbox to toggle completion status of task
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) {
              // When toggled, dispatch toggle completion status event
              context.read<TaskBloc>().add(ToggleTaskStatusEvent(task.id));
            },
          ),

          // Title of the task with conditional style if completed
          title: Text(task.title, style: textStyle),

          // Subtitle shows description and due date, styled similarly
          subtitle: Text(
            '${task.description}\nDue: ${task.dueDate.toLocal().toString().split(' ')[0]}',
            style: textStyle,
          ),

          isThreeLine: true, // to allow space for multiline subtitle

          // Trailing widget shows priority label with background color indicating priority
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _priorityColor(task.priority).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              task.priority.label, // e.g., "High", "Medium", "Low"
              style: TextStyle(
                color: _priorityColor(task.priority),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
