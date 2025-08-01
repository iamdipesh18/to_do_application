import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_application/core/enums/priority.dart';
import 'package:to_do_application/domain/entities/task.dart';

/// Form widget to add or edit a Task.
/// Handles title, optional description, priority, and due date.
class TaskForm extends StatefulWidget {
  final Task? initialTask; // Prefill fields when editing
  final void Function({
    required String title,
    String? description,
    required TaskPriority priority,
    required DateTime dueDate,
  }) onSubmit;

  const TaskForm({
    super.key,
    this.initialTask,
    required this.onSubmit,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _selectedPriority;
  late DateTime _selectedDueDate;

  @override
  void initState() {
    super.initState();

    // Initialize controllers and selected values with editing data or defaults
    _titleController =
        TextEditingController(text: widget.initialTask?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialTask?.description ?? '');
    _selectedPriority = widget.initialTask?.priority ?? TaskPriority.medium;
    _selectedDueDate = widget.initialTask?.dueDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Opens date picker and updates _selectedDueDate if a date is picked.
  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  /// Validates and submits the form, calling the parent callback with data.
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        priority: _selectedPriority,
        dueDate: _selectedDueDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Fits content height
        children: [
          // Title input (required)
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Title is required'
                : null,
          ),
          const SizedBox(height: 10),

          // Optional description input
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 2,
          ),
          const SizedBox(height: 10),

          // Priority dropdown
          DropdownButtonFormField<TaskPriority>(
            value: _selectedPriority,
            decoration: const InputDecoration(labelText: 'Priority'),
            items: TaskPriority.values.map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Text(priority.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedPriority = value;
                });
              }
            },
          ),
          const SizedBox(height: 10),

          // Due date picker
          InkWell(
            onTap: _pickDueDate,
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Due Date'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat.yMMMd().format(_selectedDueDate)),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Submit button changes label based on add/edit mode
          ElevatedButton(
            onPressed: _handleSubmit,
            child:
                Text(widget.initialTask == null ? 'Add Task' : 'Update Task'),
          ),
        ],
      ),
    );
  }
}
