import 'package:flutter/material.dart';
import 'package:to_do_application/domain/entities/task.dart';
import '../widgets/task_form.dart';


class TaskDialog extends StatelessWidget {
  final Task? existingTask;
  final void Function(Task) onSave;

  const TaskDialog({super.key, this.existingTask, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(existingTask == null ? 'Add Task' : 'Edit Task'),
      content: TaskForm(
        existingTask: existingTask,
        onSubmit: onSave,
      ),
    );
  }
}
