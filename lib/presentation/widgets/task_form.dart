import 'package:flutter/material.dart';
import 'package:to_do_application/core/enums/priority.dart';
import 'package:to_do_application/domain/entities/task.dart';
import 'package:uuid/uuid.dart';

class TaskForm extends StatefulWidget {
  final Task? existingTask;
  final void Function(Task) onSubmit;

  const TaskForm({super.key, this.existingTask, required this.onSubmit});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _description;
  late DateTime _dueDate;
  late Priority _priority;

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    _title = task?.title ?? '';
    _description = task?.description ?? '';
    _dueDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _priority = task?.priority ?? Priority.medium;
  }

  Future<void> _selectDueDate() async {
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
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final task = Task(
        id: widget.existingTask?.id ?? const Uuid().v4(),
        title: _title,
        description: _description,
        dueDate: _dueDate,
        priority: _priority,
        isCompleted: widget.existingTask?.isCompleted ?? false,
      );

      widget.onSubmit(task);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!.trim(),
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text('Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}'),
                  ),
                  TextButton(
                    onPressed: _selectDueDate,
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              DropdownButtonFormField<Priority>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: Priority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _priority = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.existingTask == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
