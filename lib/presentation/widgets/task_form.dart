import 'package:flutter/material.dart';
import 'package:to_do_application/core/enums/priority.dart';
import 'package:to_do_application/domain/entities/task.dart';
import 'package:uuid/uuid.dart';

// A form widget to add a new task or edit an existing one.
class TaskForm extends StatefulWidget {
  final Task? existingTask; // If set, form will edit this task
  final void Function(Task) onSubmit; // Called when form is submitted

  const TaskForm({super.key, this.existingTask, required this.onSubmit});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>(); // To validate and save form

  late String _title; // Task title entered by user
  late String _description; // Task description entered by user
  late DateTime _dueDate; // Task due date selected by user
  late Priority _priority; // Task priority selected by user

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;

    // Initialize form fields with existing task data or defaults
    _title = task?.title ?? '';
    _description = task?.description ?? '';
    _dueDate = task?.dueDate ??
        DateTime.now().add(const Duration(days: 1)); // Default: tomorrow
    _priority = task?.priority ?? Priority.medium; // Default priority is medium
  }

  // Opens a date picker dialog for user to select due date
  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate, // Current selected date shown first
      firstDate: DateTime.now(), // No past dates allowed
      lastDate: DateTime(2100), // Max allowed date
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked; // Update due date if user picks a date
      });
    }
  }

  // Called when the user presses the submit button
  void _submit() {
    // Validate form fields (e.g., title is not empty)
    if (_formKey.currentState?.validate() ?? false) {
      // Save the current form values to variables
      _formKey.currentState!.save();

      // Create a new Task object (new id if adding, keep id if editing)
      final task = Task(
        id: widget.existingTask?.id ??
            const Uuid().v4(), // Generate new unique id if new task
        title: _title,
        description: _description,
        dueDate: _dueDate,
        priority: _priority,
        isCompleted: widget.existingTask?.isCompleted ??
            false, // Preserve completed status if editing
      );

      // Call the onSubmit callback with the new/updated task
      widget.onSubmit(task);

      // Close the form dialog/screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Padding accounts for keyboard and screen edges
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey, // Connect form fields with the key for validation
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content vertically
            children: [
              // Title input field
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter a title'
                    : null, // Title is required
                onSaved: (value) =>
                    _title = value!.trim(), // Save trimmed title
              ),

              // Description input field (multi-line)
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) =>
                    _description = value ?? '', // Save description or empty
              ),

              const SizedBox(height: 12),

              // Due date selector row
              Row(
                children: [
                  Expanded(
                    child: Text(
                        'Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}'),
                  ),
                  TextButton(
                    onPressed: _selectDueDate, // Opens date picker
                    child: const Text('Select Date'),
                  ),
                ],
              ),

              // Priority dropdown selector
              DropdownButtonFormField<Priority>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: Priority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child:
                        Text(priority.label), // Show priority label e.g. "High"
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _priority = value; // Update priority when changed
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // Submit button to add or update task
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                    widget.existingTask == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
