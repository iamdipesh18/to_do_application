import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/core/enums/priority.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_bloc.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_event.dart';
import 'package:to_do_application/presentation/dialogs/task_dialog.dart';

/// A single task list item showing title, description, priority,
/// checkbox to toggle completion, and delete button.
/// Tapping the tile opens the edit dialog.
class TaskTile extends StatelessWidget {
  final Task task;
  final int index;

  const TaskTile({
    super.key,
    required this.task,
    required this.index,
  });

  // Map task priority to color for quick visual identification
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (_) {
          // Toggle task completion state
          context.read<TaskBloc>().add(ToggleTaskStatusEvent(index));
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: task.description.isNotEmpty ? Text(task.description) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circle showing priority color
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getPriorityColor(task.priority),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(index));
            },
          ),
        ],
      ),
      onTap: () async {
        // Open dialog for editing the task
        final editedTask = await showDialog<Task>(
          context: context,
          builder: (_) => TaskDialog(taskToEdit: task),
        );

        if (editedTask != null) {
          // Send update event to BLoC
          context.read<TaskBloc>().add(UpdateTaskEvent(index, editedTask));
        }
      },
    );
  }
}
