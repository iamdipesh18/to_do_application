import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_application/domain/entities/task.dart';
import 'package:to_do_application/core/enums/priority.dart';
import 'package:to_do_application/presentation/widgets/task_form.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_bloc.dart';
import 'package:to_do_application/logic/blocs/task_bloc/task_event.dart';

/// Dialog for adding a new task or editing an existing one.
/// Uses TaskForm for input fields and sends corresponding events.
class TaskDialog extends StatelessWidget {
  final Task? taskToEdit;

  const TaskDialog({super.key, this.taskToEdit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(taskToEdit == null ? 'Add Task' : 'Edit Task'),
      content: SingleChildScrollView(
        child: TaskForm(
          initialTask: taskToEdit,
          onSubmit: ({
            required String title,
            String? description,
            required TaskPriority priority,
            required DateTime dueDate,
          }) {
            if (taskToEdit == null) {
              // Add mode: create new task and dispatch add event
              final newTask = Task(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: title,
                description: description ?? '',
                isCompleted: false,
                priority: priority,
                dueDate: dueDate,
              );
              context.read<TaskBloc>().add(AddTaskEvent(newTask));
            } else {
              // Edit mode: update existing task and dispatch update event
              final updatedTask = taskToEdit!.copyWith(
                title: title,
                description: description ?? '',
                priority: priority,
                dueDate: dueDate,
              );
              context
                  .read<TaskBloc>()
                  .add(UpdateTaskEvent(taskToEdit!.id, updatedTask));
            }

            Navigator.of(context).pop(); // Close dialog
          },
        ),
      ),
    );
  }
}
