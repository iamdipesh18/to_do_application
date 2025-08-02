import 'package:flutter/material.dart';
import 'package:to_do_application/core/enums/priority.dart';
import 'package:to_do_application/domain/entities/task.dart';

class TaskDialog extends StatefulWidget {
  final Task? task; // null means new task, non-null means edit
  final Function(Task) onSave;

  const TaskDialog({super.key, this.task, required this.onSave});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _description;
  late Priority _priority;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _title = task?.title ?? '';
    _description = task?.description ?? '';
    _priority = task?.priority ?? Priority.medium;
    _dueDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final task = widget.task == null
          ? Task(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: _title,
              description: _description,
              dueDate: _dueDate,
              priority: _priority,
              isCompleted: false,
            )
          : widget.task!.copyWith(
              title: _title,
              description: _description,
              dueDate: _dueDate,
              priority: _priority,
            );

      widget.onSave(task);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter task title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Title required'
                      : null,
                  onSaved: (value) => _title = value!.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onSaved: (value) => _description = value ?? '',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Priority:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 16),
                    DropdownButton<Priority>(
                      value: _priority,
                      items: Priority.values
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(p.label),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _priority = value!),
                      underline: Container(height: 1, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Due Date:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 16),
                    Text(
                      '${_dueDate.toLocal()}'.split(' ')[0],
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickDueDate,
                      tooltip: 'Select due date',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.task == null ? 'Add Task' : 'Save Changes'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}
