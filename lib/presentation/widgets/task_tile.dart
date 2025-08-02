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

  // Get color based on task priority
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
    final theme = Theme.of(context);

    // Apply strikethrough style for completed tasks
    final textStyle = task.isCompleted
        ? const TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Colors.grey,
          )
        : theme.textTheme.bodyLarge;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red.shade600,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog before delete
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Delete')),
            ],
          ),
        );
      },
      onDismissed: (_) {
        context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onLongPress: () {
            // Show edit dialog on long press
            showTaskBottomSheet(
              context: context,
              task: task,
              onSave: (updatedTask) =>
                  context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask)),
            );
          },
          child: Row(
            children: [
              // Left color bar based on priority
              Container(
                width: 6,
                height: 80,
                decoration: BoxDecoration(
                  color: _priorityColor(task.priority),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  // Checkbox to toggle task status
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => context
                        .read<TaskBloc>()
                        .add(ToggleTaskStatusEvent(task.id)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    activeColor: _priorityColor(task.priority),
                  ),
                  // Task title
                  title: Text(task.title, style: textStyle),
                  // Task subtitle with description and due date
                  subtitle: Text(
                    '${task.description}\nDue: ${task.dueDate.toLocal().toString().split(' ')[0]}',
                    style: textStyle?.copyWith(fontSize: 13),
                  ),
                  isThreeLine: true,
                  // Removed the trailing icon for minimal design
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
