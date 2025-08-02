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
    final textStyle = task.isCompleted
        ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)
        : null;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red.shade600,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
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
      onDismissed: (_) {
        context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (_) => TaskDialog(
                task: task,
                onSave: (updatedTask) {
                  context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
                },
              ),
            );
          },
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) {
              context.read<TaskBloc>().add(ToggleTaskStatusEvent(task.id));
            },
          ),
          title: Text(task.title, style: textStyle),
          subtitle: Text(
            '${task.description}\nDue: ${task.dueDate.toLocal().toString().split(' ')[0]}',
            style: textStyle,
          ),
          isThreeLine: true,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _priorityColor(task.priority).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              task.priority.label,
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
