import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_application/core/constants/colors.dart';
import 'package:to_do_application/core/enums/priority.dart';
import 'package:to_do_application/domain/entities/task.dart';
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) {
            context.read<TaskBloc>().add(ToggleTaskStatusEvent(task.id));
          },
        ),
        title: Text(task.title, style: textStyle),
        subtitle: Text(task.description, style: textStyle),
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
    );
  }
}
